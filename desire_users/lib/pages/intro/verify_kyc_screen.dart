import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/kyc_bloc.dart';
import 'package:desire_users/models/kyc_view_model.dart';
import 'package:desire_users/pages/intro/success_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/sales/utils_sales/validator.dart';
import 'package:desire_users/services/api_client.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

class VerifyKycScreen extends StatefulWidget {
  final String userId;
  const VerifyKycScreen({Key key, this.userId}) : super(key: key);

  @override
  _VerifyKycScreenState createState() => _VerifyKycScreenState();
}

//customerList[i].kycStatus == "2" && customerList[i].kycApprove == "0" || customerList[i].kycApprove == "2"

class _VerifyKycScreenState extends State<VerifyKycScreen> with Validator {
  final _imagePicker = ImagePicker();
  static String panKycId = "1";
  static String aadharKycId = "2";
  static String gstKycId = "3";


  File _aadharImage;
  File gstImage;
  File panImage;
  TextEditingController gstNumberController,
      aadharNumberController,
      panNumberController;

  bool checkBoxGst = false;
  bool checkboxAadhar = false;
  bool checkBoxPan = false;

  String gstPhoto;
  String aadharPhoto;
  String panPhoto;

  final kycBloc = KYCBloc();
  String imagePath = "http://loccon.in/desiremoulding/upload/Image/Kyc/";

  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  final _formKey1 = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode1 = AutovalidateMode.disabled;

  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    kycBloc.fetchKycView(widget.userId);
    gstNumberController = TextEditingController();
    aadharNumberController = TextEditingController();
    panNumberController = TextEditingController();
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
    gstNumberController.dispose();
    aadharNumberController.dispose();
    panNumberController.dispose();
  }

  PageController controller = PageController();

  int current = 0;
  bool loading = false;

 static String pattern = r'^[2-9]{1}[0-9]{11}$';
  RegExp regExp = RegExp(pattern);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          title: Text("KYC Form"),
          titleTextStyle: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: kBlackColor),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: RefreshIndicator(
            color: kPrimaryColor,
            backgroundColor: kWhiteColor,
            onRefresh: () {
              return Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (builder) =>
                          VerifyKycScreen(userId: widget.userId)),
                  (route) => false);
            },
            child: StreamBuilder<KycViewModel>(
                stream: kycBloc.kycViewStream,
                builder: (context, s) {
                  if (s.connectionState != ConnectionState.active) {
                    print("all connection");
                    return Container(
                        height: 300,
                        alignment: Alignment.center,
                        child: Center(
                          heightFactor: 50,
                          child: CircularProgressIndicator(
                            color: kPrimaryColor,
                          ),
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
                  if (s.data.data == null) {
                    return PageView(
                      pageSnapping: false,
                      controller: controller,
                      physics: new NeverScrollableScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                Text(
                                  "Step 1 : Verify Aaadhar",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: aadharNumberController,
                                  readOnly: aadharNumberController.text == "" ? false : true,
                                  cursorColor: kBlackColor,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(12)
                                  ],
                                  decoration: InputDecoration(
                                      labelText: "Aadhar Number",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelStyle:
                                          TextStyle(color: kPrimaryColor),
                                      hintText: "Enter your Aadhar Number",
                                      hintStyle: TextStyle(
                                          color: kSecondaryColor, fontSize: 12),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kPrimaryColor))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 20),
                                  child: DottedBorder(
                                      strokeWidth: 1,
                                      color: kPrimaryColor,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (aadharNumberController
                                              .text.isEmpty) {
                                            final snackBar = SnackBar(
                                                backgroundColor:
                                                    kSecondaryColor,
                                                content: Text(
                                                    'Enter your Aadhar number first',
                                                    style: TextStyle(
                                                        color: kWhiteColor)));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else if (aadharNumberController
                                                  .text.length <
                                              12 ) {
                                            final snackBar = SnackBar(
                                                backgroundColor:
                                                    kSecondaryColor,
                                                content: Text(
                                                  'Enter correct aadhar number',
                                                  style: TextStyle(
                                                      color: kWhiteColor),
                                                ));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                          else if(!regExp.hasMatch(aadharNumberController.text) ){
                                            final snackBar = SnackBar(
                                                backgroundColor:
                                                kSecondaryColor,
                                                content: Text(
                                                  'Enter correct aadhar number',
                                                  style: TextStyle(
                                                      color: kWhiteColor),
                                                ));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                          else {
                                            aadharShowChoiceDialog();
                                          }
                                        },
                                        child: _aadharImage == null
                                            ? Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.add_a_photo),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Text(
                                                            "Upload Aaadhar Card Image"),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Image.file(_aadharImage,
                                                    height: 200,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover),
                                              ),
                                      )),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      child: Checkbox(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          activeColor: kPrimaryColor,
                                          value: checkboxAadhar ? true : false,
                                          onChanged: (v) {
                                            setState(() {
                                              checkboxAadhar = !v;
                                              print("No Change");
                                            });
                                          }),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      _aadharImage == null
                                          ? "Please Upload your Aadhar card"
                                          : "Aadhar Card Uploaded Successfully",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: _aadharImage == null
                                              ? kSecondaryColor
                                              : kPrimaryColor,
                                          fontSize: 14),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Center(
                                    child: CupertinoButton(
                                        color: aadharNumberController
                                                    .text.isEmpty &&
                                                _aadharImage == null
                                            ? kSecondaryColor
                                            : kPrimaryColor,
                                        child: aadharNumberController
                                                    .text.isEmpty &&
                                                _aadharImage == null
                                            ? Text("Complete Step 1")
                                            : Text("Continue with Step 2"),
                                        onPressed: () {
                                          if (aadharNumberController
                                              .text.isEmpty) {
                                            final snackBar = SnackBar(
                                                backgroundColor:
                                                    kSecondaryColor,
                                                content: Text(
                                                    'Enter your Aadhar number first',
                                                    style: TextStyle(
                                                        color: kWhiteColor)));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else if (aadharNumberController
                                                  .text.length <
                                              12) {
                                            final snackBar = SnackBar(
                                                backgroundColor:
                                                    kSecondaryColor,
                                                content: Text(
                                                  'Enter correct aadhar number',
                                                  style: TextStyle(
                                                      color: kWhiteColor),
                                                ));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else if (_aadharImage == null) {
                                            final snackBar = SnackBar(
                                                backgroundColor:
                                                    kSecondaryColor,
                                                content: Text(
                                                  'Upload Your Aaadhar Image First',
                                                  style: TextStyle(
                                                      color: kWhiteColor),
                                                ));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else {
                                            current = 1;
                                            controller.jumpToPage(current);
                                          }
                                        }),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Text(
                                  "Step 2 : Verify Gst Number",
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: gstNumberController,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(15)
                                  ],
                                  decoration: InputDecoration(
                                      labelText: "Gst Number",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelStyle:
                                          TextStyle(color: kPrimaryColor),
                                      hintText: "Enter your Gst Number",
                                      hintStyle: TextStyle(
                                          color: kSecondaryColor, fontSize: 12),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kPrimaryColor))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 20),
                                  child: DottedBorder(
                                      strokeWidth: 1,
                                      color: kPrimaryColor,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (gstNumberController
                                              .text.isEmpty) {
                                            final snackBar = SnackBar(
                                                backgroundColor:
                                                    kSecondaryColor,
                                                content: Text(
                                                    'Enter your Gst number first',
                                                    style: TextStyle(
                                                        color: kWhiteColor)));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else if (gstNumberController
                                                  .text.length <
                                              15) {
                                            final snackBar = SnackBar(
                                                backgroundColor:
                                                    kSecondaryColor,
                                                content: Text(
                                                  'Enter correct gst number',
                                                  style: TextStyle(
                                                      color: kWhiteColor),
                                                ));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else {
                                            gstShowChoiceDialog();
                                          }
                                        },
                                        child: gstImage == null
                                            ? Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.add_a_photo),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Text(
                                                            "Upload Gst Number Image"),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Image.file(gstImage,
                                                    height: 200,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover),
                                              ),
                                      )),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      child: Checkbox(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          activeColor: kPrimaryColor,
                                          value: checkBoxGst ? true : false,
                                          onChanged: (v) {
                                            setState(() {
                                              checkBoxGst = !v;
                                              print(
                                                  "You cannot change this value");
                                            });
                                          }),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    gstImage == null
                                        ? Text(
                                            "Please Upload your Gst Number Image",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: kSecondaryColor,
                                                fontSize: 14),
                                          )
                                        : Text(
                                            "Gst Number Image Uploaded Successfully",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 14),
                                          ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20,right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextButton(
                                          onPressed: (){

                                       navigatePanPage();


                                      }, child: Text("Skip Step 2",style: TextStyle(color: kPrimaryColor,fontSize: 16),)),
                                      CupertinoButton(
                                          color:  gstNumberController.text.isEmpty &&gstImage == null
                                               ? kSecondaryColor : kPrimaryColor,
                                          child: Text(gstNumberController.text.isEmpty &&gstImage == null
                                              ? "Submit": "Submit"),
                                          onPressed: () {
                                            if (checkboxAadhar == true &&
                                                checkBoxGst == true &&
                                                aadharNumberController.text.length == 12 &&
                                                gstNumberController.text.length == 15) {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) => SuccessPage(
                                                        userId: widget.userId,
                                                      )),
                                                      (route) => false);
                                            } else {
                                              Alerts.showAlertAndBack(
                                                  context, "Incomplete", "Something is missing");
                                            }
                                          }),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                Text(
                                  "Step 3 : Verify Pan Card",
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
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  controller: panNumberController,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  decoration: InputDecoration(
                                      labelText: "Pan Number",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      labelStyle:
                                          TextStyle(color: kPrimaryColor),
                                      hintText: "Enter your PAN Number",
                                      hintStyle: TextStyle(
                                          color: kSecondaryColor, fontSize: 12),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: kPrimaryColor))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0, bottom: 20),
                                  child: DottedBorder(
                                      strokeWidth: 1,
                                      color: kPrimaryColor,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (panNumberController
                                              .text.isEmpty) {
                                            final snackBar = SnackBar(
                                                backgroundColor:
                                                    kSecondaryColor,
                                                content: Text(
                                                    'Enter your pan number first',
                                                    style: TextStyle(
                                                        color: kWhiteColor)));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else if (panNumberController
                                                  .text.length <
                                              10) {
                                            final snackBar = SnackBar(
                                                backgroundColor:
                                                    kSecondaryColor,
                                                content: Text(
                                                  'Enter correct pan number',
                                                  style: TextStyle(
                                                      color: kWhiteColor),
                                                ));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else {
                                            panShowChoiceDialog();
                                          }
                                        },
                                        child: panImage == null
                                            ? Container(
                                                height: 200,
                                                width: double.infinity,
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.add_a_photo),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 8.0),
                                                        child: Text(
                                                            "Upload Pan Card Image"),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Image.file(panImage,
                                                    height: 200,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover),
                                              ),
                                      )),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 20,
                                      child: Checkbox(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          activeColor: kPrimaryColor,
                                          value: checkBoxPan ? true : false,
                                          onChanged: (v) {
                                            setState(() {
                                              checkBoxPan = !v;
                                            });
                                          }),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    panImage == null
                                        ? Text(
                                            "Please Upload your Pan Card Image",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: kSecondaryColor,
                                                fontSize: 14),
                                          )
                                        : Text(
                                            "pan Card Image Uploaded Successfully",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 14),
                                          ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20,right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextButton(
                                          onPressed: (){

                                            current = 1;
                                            controller.jumpToPage(current);


                                          }, child: Text("Go to Step 2",style: TextStyle(color: kPrimaryColor,fontSize: 16),)),
                                      CupertinoButton(
                                          color:  panNumberController.text.isEmpty &&panImage == null
                                              ? kSecondaryColor : kPrimaryColor,
                                          child: Text(panNumberController.text.isEmpty &&panImage == null
                                              ? "Submit": "Submit"),
                                          onPressed: () {
                                            if (checkboxAadhar == true &&
                                                checkBoxPan == true &&
                                                aadharNumberController.text.length == 12 &&
                                                panNumberController.text.length == 10) {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) => SuccessPage(
                                                        userId: widget.userId,
                                                      )),
                                                      (route) => false);
                                            } else {
                                              Alerts.showAlertAndBack(
                                                  context, "Incomplete", "Something is missing");
                                            }
                                          }),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  for (int i = 0; i < s.data.data.length; i++) {
                    if (s.data.data[i].kycId == "$aadharKycId") {
                      checkboxAadhar = true;
                      aadharNumberController.text = s.data.data[i].number;
                      aadharPhoto = "${s.data.data[i].photo}";
                      print(
                          "object3 ${aadharNumberController.text} $aadharPhoto ");
                    }

                    if (s.data.data[i].kycId == "$gstKycId") {
                      checkBoxGst = true;
                      gstNumberController.text = s.data.data[i].number;
                      gstPhoto = "${s.data.data[i].photo}";
                      print("object1 ${gstNumberController.text} $gstPhoto ");
                    }

                    if (s.data.data[i].kycId == "$panKycId") {
                      checkBoxPan = true;
                      panNumberController.text = s.data.data[i].number;
                      panPhoto = "${s.data.data[i].photo}";
                      print("object3 ${panNumberController.text} $panPhoto ");
                    }
                  }
                  return PageView(
                    pageSnapping: false,
                    controller: controller,
                    physics: new NeverScrollableScrollPhysics(),
                    children: [
                      aadharCardVerifyView(),
                      gstVerifyView(),
                      panCarVerifyView(),
                    ],
                  );
                })),
      ),
    );
  }

  Widget imageDialog(String path) {
    return PhotoView(
      imageProvider: NetworkImage(path),
      backgroundDecoration: BoxDecoration(
        color: Colors.transparent,
      ),
    );
  }

  Widget aadharCardVerifyView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Text(
              "Step 1 : Verify Aaadhar",
              style: TextStyle(
                  color: kPrimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: aadharNumberController,
              cursorColor: kBlackColor,
              readOnly: aadharNumberController.text == "" ? false : true,
              inputFormatters: [LengthLimitingTextInputFormatter(12)],
              decoration: InputDecoration(
                  labelText: "Aadhar Number",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(color: kPrimaryColor),
                  hintText: "Enter your Aadhar Number",
                  hintStyle: TextStyle(color: kSecondaryColor, fontSize: 12),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
              child: DottedBorder(
                  strokeWidth: 1,
                  color: kPrimaryColor,
                  child: GestureDetector(
                      onTap: () {
                        if (aadharNumberController.text.isEmpty) {
                          final snackBar = SnackBar(
                              backgroundColor: kSecondaryColor,
                              content: Text('Enter your Aadhar number first',
                                  style: TextStyle(color: kWhiteColor)));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (aadharNumberController.text.length < 12) {
                          final snackBar = SnackBar(
                              backgroundColor: kSecondaryColor,
                              content: Text(
                                'Enter correct aadhar number',
                                style: TextStyle(color: kWhiteColor),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (imagePath + aadharPhoto != null) {
                          final snackBar = SnackBar(
                              backgroundColor: kSecondaryColor,
                              content: Text(
                                'Aadhar card already uploaded',
                                style: TextStyle(color: kWhiteColor),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }  else if(!regExp.hasMatch(aadharNumberController.text) ){
                          final snackBar = SnackBar(
                              backgroundColor:
                              kSecondaryColor,
                              content: Text(
                                'Enter correct aadhar number',
                                style: TextStyle(
                                    color: kWhiteColor),
                              ));
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar);
                        }else {
                          aadharShowChoiceDialog();
                        }
                      },
                      child: aadharPhoto == ""
                          ? _aadharImage == null
                              ? Container(
                                  height: 200,
                                  width: double.infinity,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_a_photo),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child:
                                              Text("Upload Aaadhar Card Image"),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.file(_aadharImage,
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover),
                                )
                          : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (_) => imageDialog(
                                          "$imagePath$aadharPhoto"));
                                },
                                child: Image.network("$imagePath$aadharPhoto",
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: kPrimaryColor,
                                      value: loadingProgress
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes
                                          : null,
                                    ),
                                  );
                                },
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover),
                              ),
                            ))),
            ),
            Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      activeColor: kPrimaryColor,
                      value: checkboxAadhar ? true : false,
                      onChanged: (v) {
                        setState(() {
                          checkboxAadhar = !v;
                          print("No Change");
                        });
                      }),
                ),
                SizedBox(
                  width: 5,
                ),
                imagePath + aadharPhoto == null
                    ? Text(
                        "Please Upload your Aadhar card",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: kSecondaryColor, fontSize: 14),
                      )
                    : Text(
                        "Aadhar Card Uploaded Successfully",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: kPrimaryColor, fontSize: 14),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: CupertinoButton(
                    color: aadharNumberController.text.isEmpty &&
                            imagePath + aadharPhoto == ""
                        ? kSecondaryColor
                        : kPrimaryColor,
                    child: aadharNumberController.text.isEmpty &&
                            imagePath + aadharPhoto == " "
                        ? Text("Complete Step 1")
                        : Text("Continue with Step 2"),
                    onPressed: () {
                      if (aadharNumberController.text.isEmpty) {
                        final snackBar = SnackBar(
                            backgroundColor: kSecondaryColor,
                            content: Text('Enter your Aadhar number first',
                                style: TextStyle(color: kWhiteColor)));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (aadharNumberController.text.length < 12) {
                        final snackBar = SnackBar(
                            backgroundColor: kSecondaryColor,
                            content: Text(
                              'Enter correct aadhar number',
                              style: TextStyle(color: kWhiteColor),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (imagePath + aadharPhoto == null) {
                        final snackBar = SnackBar(
                            backgroundColor: kSecondaryColor,
                            content: Text(
                              'Upload Your Aaadhar Image First',
                              style: TextStyle(color: kWhiteColor),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        current = 1;
                        controller.jumpToPage(current);
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget gstVerifyView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              "Step 2 : Verify Gst Number",
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
              readOnly: gstNumberController.text.isEmpty ? false : true,
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              decoration: InputDecoration(
                  labelText: "Gst Number",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(color: kPrimaryColor),
                  hintText: "Enter your Gst Number",
                  hintStyle: TextStyle(color: kSecondaryColor, fontSize: 12),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
              child: DottedBorder(
                  strokeWidth: 1,
                  color: kPrimaryColor,
                  child: GestureDetector(
                    onTap: () {
                      if (gstNumberController.text.isEmpty) {
                        final snackBar = SnackBar(
                            backgroundColor: kSecondaryColor,
                            content: Text('Enter your gst number first',
                                style: TextStyle(color: kWhiteColor)));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (gstNumberController.text.length < 15) {
                        final snackBar = SnackBar(
                            backgroundColor: kSecondaryColor,
                            content: Text(
                              'Enter correct gst number',
                              style: TextStyle(color: kWhiteColor),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        panShowChoiceDialog();
                      }
                    },
                    child: gstPhoto == null
                        ? gstImage == null
                            ? Container(
                                height: 200,
                                width: double.infinity,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text("Upload Gst Card Image"),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: checkBoxGst == false
                                    ? Container(
                                        height: 200,
                                        width: double.infinity,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add_a_photo),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                    "Upload Gst Number Image"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Image.file(gstImage,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover),
                              )
                        : checkBoxGst == false
                            ? Container(
                                height: 200,
                                width: double.infinity,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text("Upload Gst Card Image"),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.network(imagePath + gstPhoto,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover),
                              ),
                  )),
            ),
            Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      activeColor: kPrimaryColor,
                      value: checkBoxGst ? true : false,
                      onChanged: (v) {
                        setState(() {
                          checkBoxGst = !v;
                        });
                      }),
                ),
                SizedBox(
                  width: 5,
                ),
                checkBoxGst == false
                    ? panPhoto == null && checkBoxGst == false
                        ? Text(
                            "Please Upload your Gst Number Image",
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(color: kSecondaryColor, fontSize: 14),
                          )
                        : Text(
                            "Gst Number Image Uploaded Successfully",
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 14),
                          )
                    : Text(
                        "Gst Number Image Uploaded Successfully",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: kPrimaryColor, fontSize: 14),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(onPressed: (){
                    current = 2;
                    controller.jumpToPage(current);

                  }, child: Text("Skip Step 2",style: TextStyle(color: kPrimaryColor,fontSize: 16),)),
                  CupertinoButton(
                      color: kPrimaryColor,
                      child: Text("Submit"),
                      onPressed: () {
                        if (checkboxAadhar == true &&
                            checkBoxGst == true &&
                            aadharNumberController.text.length == 12 &&
                            gstNumberController.text.length == 15) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => SuccessPage(
                                        userId: widget.userId,
                                      )),
                              (route) => false);
                        } else {
                          Alerts.showAlertAndBack(
                              context, "Incomplete", "Something is missing");
                        }
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget panCarVerifyView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              "Step 3 : Verify Pan Card",
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
              readOnly: panNumberController.text.isEmpty ? false : true,
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              decoration: InputDecoration(
                  labelText: "Pan Number",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: TextStyle(color: kPrimaryColor),
                  hintText: "Enter your PAN Number",
                  hintStyle: TextStyle(color: kSecondaryColor, fontSize: 12),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColor))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20),
              child: DottedBorder(
                  strokeWidth: 1,
                  color: kPrimaryColor,
                  child: GestureDetector(
                    onTap: () {
                      if (panNumberController.text.isEmpty) {
                        final snackBar = SnackBar(
                            backgroundColor: kSecondaryColor,
                            content: Text('Enter your pan number first',
                                style: TextStyle(color: kWhiteColor)));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (panNumberController.text.length < 10) {
                        final snackBar = SnackBar(
                            backgroundColor: kSecondaryColor,
                            content: Text(
                              'Enter correct pan number',
                              style: TextStyle(color: kWhiteColor),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        panShowChoiceDialog();
                      }
                    },
                    child: panPhoto == null
                        ? panImage == null
                            ? Container(
                                height: 200,
                                width: double.infinity,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text("Upload Pan Card Image"),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: checkBoxPan == false
                                    ? Container(
                                        height: 200,
                                        width: double.infinity,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add_a_photo),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                    "Upload Pan Card Image"),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Image.file(panImage,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover),
                              )
                        : checkBoxPan == false
                            ? Container(
                                height: 200,
                                width: double.infinity,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text("Upload Pan Card Image"),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.network(imagePath + panPhoto,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover),
                              ),
                  )),
            ),
            Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  child: Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      activeColor: kPrimaryColor,
                      value: checkBoxPan ? true : false,
                      onChanged: (v) {
                        setState(() {
                          checkBoxPan = !v;
                        });
                      }),
                ),
                SizedBox(
                  width: 5,
                ),
                checkBoxPan == false
                    ? panPhoto == null && checkBoxPan == false
                        ? Text(
                            "Please Upload your Pan Card Image",
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(color: kSecondaryColor, fontSize: 14),
                          )
                        : Text(
                            "Pan Card Image Uploaded Successfully",
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(color: kPrimaryColor, fontSize: 14),
                          )
                    : Text(
                        "Pan Card Image Uploaded Successfully",
                        textAlign: TextAlign.left,
                        style: TextStyle(color: kPrimaryColor, fontSize: 14),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: (){

                        current = 1;
                        controller.jumpToPage(current);


                      }, child: Text("Go to Step 2",style: TextStyle(color: kPrimaryColor,fontSize: 16),)),
                  CupertinoButton(
                      color:  panNumberController.text.isEmpty &&panImage == null
                          ? kSecondaryColor : kPrimaryColor,
                      child: Text(panNumberController.text.isEmpty &&panImage == null
                          ? "Submit": "Submit"),
                      onPressed: () {
                        if (checkboxAadhar == true &&
                            checkBoxPan == true &&
                            aadharNumberController.text.length == 12 &&
                            panNumberController.text.length == 10) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => SuccessPage(
                                    userId: widget.userId,
                                  )),
                                  (route) => false);
                        } else {
                          Alerts.showAlertAndBack(
                              context, "Incomplete", "Something is missing");
                        }
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _uploadGstNumberPictureGallery() async {
    print("values from text ${widget.userId}, ${gstNumberController.text}");
    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.gallery);

    gstImage = File(_pickedPic.path);

    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
        progressWidget: Center(
          child: CircularProgressIndicator(
            color: kPrimaryColor,
          ),
        ),
        message: 'Uploading Your Gst Number Image');
    pr.show();
    final _apiClient = ApiClient();
    String value = await _apiClient.updateProfilePhoto(gstImage,
        "${widget.userId}", "$gstKycId", "${gstNumberController.text}");
    print("value $value");

    setState(() {
      if (value == "success") {
        checkBoxGst = true;
        final snackBar = SnackBar(content: Text('Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        final snackBar =
            SnackBar(content: Text('Image Uploading Unsuccessful'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    pr.hide();
  }

  _uploadGstNumberPictureCamera() async {
    print("values from text ${widget.userId}, ${gstNumberController.text}");
    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.camera);

    gstImage = File(_pickedPic.path);

    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Your Gst Number Image');
    pr.show();
    final _apiClient = ApiClient();
    String value = await _apiClient.updateProfilePhoto(gstImage,
        "${widget.userId}", "$gstKycId", "${gstNumberController.text}");
    print("value $value");

    setState(() {
      if (value == "success") {
        checkBoxGst = true;
        final snackBar =
            SnackBar(content: Text('Gst Number Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        Alerts.showAlertAndBack(context, "Error", "Error loading image");
      }
    });
    pr.hide();
  }

  _uploadAadharNumberPictureGallery() async {
    print("values from text ${widget.userId}, ${aadharNumberController.text}");
    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.gallery);

    _aadharImage = File(_pickedPic.path);

    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Aadhar card Image');
    pr.show();
    final _apiClient = ApiClient();
    String value = await _apiClient.updateProfilePhoto(_aadharImage,
        "${widget.userId}", "$aadharKycId", "${aadharNumberController.text}");
    print("value $value");

    setState(() {
      if (value == "success") {
        checkboxAadhar = true;
        final snackBar =
            SnackBar(content: Text('Aadhar Card Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        final snackBar =
            SnackBar(content: Text('Aadhar Card Image Uploading UnSuccessful'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    pr.hide();
  }

  _uploadAadharNumberPictureCamera() async {
    print("values from text ${widget.userId}, ${aadharNumberController.text}");
    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.camera);

    _aadharImage = File(_pickedPic.path);

    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Aadhar Card Image');
    pr.show();
    final _apiClient = ApiClient();
    String value = await _apiClient.updateProfilePhoto(_aadharImage,
        "${widget.userId}", "$aadharKycId", "${aadharNumberController.text}");
    print("value $value");

    setState(() {
      if (value == "success") {
        checkboxAadhar = true;
        final snackBar =
            SnackBar(content: Text('Aadhar Card Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        final snackBar =
            SnackBar(content: Text('Aadhar Card Image Uploading UnSuccessful'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    pr.hide();
  }

  _uploadPanPictureGallery() async {
    print("values from text ${widget.userId}, ${panNumberController.text}");

    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.gallery);

    panImage = File(_pickedPic.path);

    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Your Pan card');
    pr.show();

    final _apiClient = ApiClient();

    String value = await _apiClient.updateProfilePhoto(panImage,
        "${widget.userId}", "$panKycId", "${panNumberController.text}");

    print("value $value");

    setState(() {
      if (value == "success") {
        checkBoxPan = true;
        final snackBar =
            SnackBar(content: Text('Pan Card Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        final snackBar =
            SnackBar(content: Text('Pan Card Image Uploading UnSuccessful'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });

    pr.hide();
  }

  _uploadPanPictureCamera() async {
    print("values from text ${widget.userId}, ${panNumberController.text}");

    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.camera);

    panImage = File(_pickedPic.path);

    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading your pan card Image');
    pr.show();
    final _apiClient = ApiClient();
    String value = await _apiClient.updateProfilePhoto(
        panImage, "${widget.userId}", panKycId, "${panNumberController.text}");
    print("value $value");

    setState(() {
      if (value == "success") {
        checkBoxPan = true;
        final snackBar =
            SnackBar(content: Text('Pan Card Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        final snackBar =
            SnackBar(content: Text('Pan Card Image Uploading UnSuccessful'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    pr.hide();
  }

  aadharShowChoiceDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.black),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _uploadAadharNumberPictureGallery();
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.photo,
                      color: Colors.black,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _uploadAadharNumberPictureCamera();
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  gstShowChoiceDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.black),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _uploadGstNumberPictureGallery();
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.photo,
                      color: Colors.black,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _uploadGstNumberPictureCamera();
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  panShowChoiceDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.black),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _uploadPanPictureGallery();
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.photo,
                      color: Colors.black,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      _uploadPanPictureCamera();
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  navigatePanPage() {
    current = 2;
    controller.jumpToPage(current);
  }

  showCantSkipSnackBar(){

    final snackBar =
    SnackBar(content: Text('Gstin Uploaded can"t skip.Please submit'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
}
