import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/models/verify_gst_model.dart';
import 'package:desire_users/pages/intro/verify_kyc_screen_old.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class VerifyKycScreen extends StatefulWidget {
  final String userId;
  final String type;

  const VerifyKycScreen({Key key, this.userId, this.type}) : super(key: key);

  @override
  _VerifyKycScreenState createState() => _VerifyKycScreenState();
}

class _VerifyKycScreenState extends State<VerifyKycScreen> {
  TextEditingController gstNumberController, panNumberController;

  @override
  void initState() {
    super.initState();
    checkConnectivity();

    gstNumberController = TextEditingController();
    panNumberController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    gstNumberController.dispose();
    panNumberController.dispose();
  }

  checkConnectivity() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(
          context, "No Internet Connection", "Please check your internet");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("KYC Form"),
              titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kBlackColor),
              centerTitle: false,
              elevation: 0.0,
            ),
            body: widget.type == "0"
                ? Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          "Verify GST",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          controller: gstNumberController,
                          readOnly:
                              gstNumberController.text.isEmpty ? false : true,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15)
                          ],
                          decoration: InputDecoration(
                              labelText: "Gst Number",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(color: kPrimaryColor),
                              hintText: "Enter your Gst Number",
                              hintStyle: TextStyle(
                                  color: kSecondaryColor, fontSize: 12),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: kPrimaryColor))),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            child: CupertinoButton(
                                color: kPrimaryColor,
                                child: Text("Verify GST"),
                                onPressed: () {
                                  if (gstNumberController.text.isEmpty) {
                                    final snackBar = SnackBar(
                                        backgroundColor: kSecondaryColor,
                                        content: Text(
                                            'Enter your gst number first',
                                            style:
                                                TextStyle(color: kWhiteColor)));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else if (gstNumberController.text.length <
                                      15) {
                                    final snackBar = SnackBar(
                                        backgroundColor: kSecondaryColor,
                                        content: Text(
                                          'Enter correct gst number',
                                          style: TextStyle(color: kWhiteColor),
                                        ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    verifyGST();
                                  }
                                })),
                      ],
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          "Verify Pan",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          controller: panNumberController,
                          readOnly:
                              panNumberController.text.isEmpty ? false : true,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10)
                          ],
                          decoration: InputDecoration(
                              labelText: "Pan Number",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(color: kPrimaryColor),
                              hintText: "Enter your PAN Number",
                              hintStyle: TextStyle(
                                  color: kSecondaryColor, fontSize: 12),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: kPrimaryColor))),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: CupertinoButton(
                              color: kPrimaryColor,
                              child: Text("Verify Pan"),
                              onPressed: () {
                                if (panNumberController.text.isEmpty) {
                                  final snackBar = SnackBar(
                                      backgroundColor: kSecondaryColor,
                                      content: Text(
                                          'Enter your pan number first',
                                          style:
                                              TextStyle(color: kWhiteColor)));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else if (panNumberController.text.length <
                                    10) {
                                  final snackBar = SnackBar(
                                      backgroundColor: kSecondaryColor,
                                      content: Text(
                                        'Enter correct pan number',
                                        style: TextStyle(color: kWhiteColor),
                                      ));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  verifyPan();
                                }
                              }),
                        ),
                      ],
                    ))));
  }

  verifyGST() async {
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),
    );
    pr.show();
    var response = await http.post(
        Uri.parse(
            "http://loccon.in/desiremoulding/api/UserApiController/verifyGST"),
        body: {
          'secretkey': Connection.secretKey,
          'gst_number': gstNumberController.text.toString()
        });

    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true) {
      final snackBar = SnackBar(
          content: Row(
        children: [
          Text(results['message']),
        ],
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => VerifyKycScreenOld(
                  userId: widget.userId, pagerTab: "2",)));
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>AccessoryDetailPage(product: widget.product,page: widget.page,snapshot: widget.snapshot,status: true, orderCount: widget.orderCount,)), (route) => false);
    } else {
      Alerts.showAlertAndBack(
          context, results["response_status"], results['message']);
    }
    pr.hide();
  }

  verifyPan() async {
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),
    );
    pr.show();
    var response = await http.post(
        Uri.parse(
            "http://loccon.in/desiremoulding/api/UserApiController/verifyPancard"),
        body: {
          'secretkey': Connection.secretKey,
          'pan_number': panNumberController.text.toString()
        });

    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true) {
      final snackBar = SnackBar(
          content: Row(
        children: [
          Text(results['message']),
        ],
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => VerifyKycScreenOld(
                  userId: widget.userId, pagerTab: "2",)));
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>AccessoryDetailPage(product: widget.product,page: widget.page,snapshot: widget.snapshot,status: true, orderCount: widget.orderCount,)), (route) => false);
    } else {
      Alerts.showAlertAndBack(
          context, results["response_status"], results['message']);
    }
    pr.hide();
  }
}
