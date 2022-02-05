import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/model_list_bloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/modelList_model.dart';
import 'package:desire_production/pages/admin/customer/customer_list_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/drawer_admin.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CustomerPricingPage extends StatefulWidget {
  final String customerId;
  final String salesId;

  const CustomerPricingPage(
      {@required this.customerId, @required this.salesId});

  @override
  _CustomerPricingPageState createState() => _CustomerPricingPageState();
}

class _CustomerPricingPageState extends State<CustomerPricingPage> {
  final modelBloc = ModelListBloc();

  List<bool> check = [];
  bool checkAll = false;
  List<ModelList> send = [];

  AsyncSnapshot<ModelListModel> as;

  List<TextEditingController> newPrice = [];

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    print("customers ${widget.customerId} ${widget.salesId}");
    modelBloc.fetchModelList(widget.customerId);
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
  void dispose() {
    super.dispose();
    modelBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        // leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
        //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => SalesHomePage()));
        // },),
        title: Text(
          "Customer Pricing List",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        // leading: Builder(
        //   builder: (c){
        //     return IconButton(icon: Image.asset("assets/images/logo_new.png"), onPressed: (){
        //       Scaffold.of(c).openDrawer();
        //     },);
        //   },
        // ),
        actions: [
          PopupMenuButton(
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.black,
              ),
              itemBuilder: (b) => [
                    PopupMenuItem(
                        child: TextButton(
                      child: Text(
                        "Log Out",
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        Alerts.showLogOut(context, "Log Out", "Are you sure?");
                      },
                    )),
                  ])
        ],
      ),
      // drawer: DrawerAdmin(),
      body: _body(),
    ));
  }

  Widget _body() {
    return RefreshIndicator(
      onRefresh: () {
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (builder) => CustomerPricingPage(
                      customerId: widget.customerId,
                      salesId: widget.salesId,
                    )),
            (route) => false);
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            StreamBuilder<ModelListModel>(
                stream: modelBloc.productStream,
                builder: (c, s) {
                  if (s.connectionState != ConnectionState.active) {
                    print("all connection");
                    return Container(
                        height: 300,
                        alignment: Alignment.center,
                        child: Center(
                          heightFactor: 50,
                          child: CircularProgressIndicator(),
                        ));
                  }
                  if (s.hasError) {
                    print("as3 error");
                    return Container(
                      height: 300,
                      alignment: Alignment.center,
                      child: Text(
                        "Error Loading Data",
                      ),
                    );
                  }
                  if (s.data.modelList.length == 0) {
                    print("as3 empty");
                    return Container(
                      height: 300,
                      alignment: Alignment.center,
                      child: Text(
                        "No Details Found",
                      ),
                    );
                  }
                  as = s;

                  if (check.length == 0) {
                    for (int i = 0; i < s.data.modelList.length; i++) {
                      if (s.data.modelList[i].checked == true) {
                        check.add(true);
                        send.add(s.data.modelList[i]);
                      } else {
                        check.add(false);
                      }

                      newPrice.add(TextEditingController(
                          text: s.data.modelList[i].listPrice));
                      print("checked value ${check[i]}");
                    }
                  }
                  print(
                      "object length ${s.data.modelList.length} ${check.length}");

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFFA53E),
                                      border: Border(
                                          top: BorderSide(color: Colors.black),
                                          right:
                                              BorderSide(color: Colors.black),
                                          bottom:
                                              BorderSide(color: Colors.black),
                                          left:
                                              BorderSide(color: Colors.black)),
                                    ),
                                    child: Checkbox(
                                      value: checkAll,
                                      checkColor: Colors.white,
                                      onChanged: (value) {
                                        setState(() {
                                          checkAll = value;
                                        });
                                        print("object remember $checkAll");
                                        if (checkAll == true) {
                                          for (int i = 0;
                                              i < s.data.modelList.length;
                                              i++) {
                                            check[i] = true;
                                            send.add(s.data.modelList[i]);
                                          }
                                        } else {
                                          for (int i = 0;
                                              i < s.data.modelList.length;
                                              i++) {
                                            check[i] = false;
                                            send = [];
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFA53E),
                                          border: Border(
                                              right: BorderSide(
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  color: Colors.black),
                                              top: BorderSide(
                                                  color: Colors.black)),
                                        ),
                                        child: Text(
                                          'Model Name', //style: content1,
                                          textAlign: TextAlign.center,
                                        ),
                                        alignment: Alignment.center,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFA53E),
                                          border: Border(
                                              right: BorderSide(
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  color: Colors.black),
                                              top: BorderSide(
                                                  color: Colors.black)),
                                        ),
                                        child: Text(
                                          'MRP', //style: content1,
                                          textAlign: TextAlign.center,
                                        ),
                                        alignment: Alignment.center,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFA53E),
                                          border: Border(
                                              right: BorderSide(
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  color: Colors.black),
                                              top: BorderSide(
                                                  color: Colors.black)),
                                        ),
                                        child: Text(
                                          'Sales Price', //style: content1,
                                          textAlign: TextAlign.center,
                                        ),
                                        alignment: Alignment.center,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFFFA53E),
                                          border: Border(
                                              right: BorderSide(
                                                  color: Colors.black),
                                              bottom: BorderSide(
                                                  color: Colors.black),
                                              top: BorderSide(
                                                  color: Colors.black)),
                                        ),
                                        child: Text(
                                          'New Price', //style: content1,
                                          textAlign: TextAlign.center,
                                        ),
                                        alignment: Alignment.center,
                                      )),
                                ],
                              ),
                            ),
                            for (int i = 0; i < s.data.modelList.length; i++)
                              s.data.modelList.length == 0
                                  ? Container(
                                      height: 300,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "No Orders Found",
                                      ),
                                    )
                                  : AnimationConfiguration.staggeredList(
                                      position: i,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: Container(
                                            height: 50,
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    //color: bg,
                                                    border: Border(
                                                        right: BorderSide(
                                                            color:
                                                                Colors.black),
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.black),
                                                        left: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  child: Checkbox(
                                                    value: check[i],
                                                    activeColor: kPrimaryColor,
                                                    onChanged: (value) {
                                                      //check.clear();
                                                      setState(() {
                                                        check[i] = value;
                                                      });
                                                      print(
                                                          "object remember ${check[i]}");
                                                      if (check[i] == true) {
                                                        print("object added");
                                                        send.add(s
                                                            .data.modelList[i]);
                                                      } else {
                                                        print("object removed");
                                                        send.remove(s
                                                            .data
                                                            .modelList[i]
                                                            .modelNoId);
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                      child: Text(
                                                        '${s.data.modelList[i].modelNo}', //style: content1,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                      child: Text(
                                                        '${s.data.modelList[i].customerPrice}', //style: content1,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                      child: Text(
                                                        '${s.data.modelList[i].salesPrice}', //style: content1,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                      child: TextFormField(
                                                        controller: newPrice[i],
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                          LengthLimitingTextInputFormatter(
                                                              4)
                                                        ],
                                                        //style: content1,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(20),
              child: DefaultButton(
                text: "Submit Pricing",
                press: () {
                  print("send value ${send.length}");
                  if (send.length > 0) {
                    submitPricing();
                  } else {
                    final snackBar = SnackBar(
                        content: Text(
                      "No Products Selected",
                      textAlign: TextAlign.center,
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  submitPricing() async {
    List<Map<String, String>> pricingList = [];
    for (int i = 0; i < send.length; i++) {
      String price;
      for (int j = 0; j < newPrice.length; j++) {
        if (send[i].modelNoId == as.data.modelList[j].modelNoId) {
          price = newPrice[i].text;
        }
      }
      print(
          "object values to be added ${send[i].modelNo} ${send[i].listOldPrice} ${newPrice[i].text} $price");
      var prices = {
        '"model_no_id"': "\"${send[i].modelNoId}\"",
        '"price"': "\"$price\"",
        '"old_price"': send[i].listOldPrice == ""
            ? "\"${newPrice[i].text}\""
            : "\"${send[i].listOldPrice}\"",
      };
      pricingList.add(prices);
    }

    print("pricing list $pricingList");
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
    var response = await http.post(Uri.parse(Connection.editmodelList), body: {
      'secretkey': Connection.secretKey,
      "sales_id": widget.salesId == null ? "2" : widget.salesId,
      "customer_id": widget.customerId,
      "terms_and_condition": "Test",
      "product_list": "$pricingList",
      "price_list": "TRUE",
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true) {
      final snackBar = SnackBar(
          content: Text(
        "Status Updated",
        textAlign: TextAlign.center,
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => CustomerPricingPage(
                  customerId: widget.customerId, salesId: widget.salesId)),
          (Route<dynamic> route) => false);
    } else {
      print('error deleting address');
      Alerts.showAlertAndBack(context, 'Error', 'Address not Deleted.');
    }
  }
}
