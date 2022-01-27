import 'dart:convert';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/kyc_bloc.dart';
import 'package:desire_users/models/kyc_view_model.dart';
import 'package:desire_users/pages/intro/success_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/sales/utils_sales/validator.dart';
import 'package:desire_users/services/api_client.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;

class VerifyKycScreenOld extends StatefulWidget {
  final String userId;
  final String aadharNumber;
  final String panNumber;
  final String gstNumber;
  final String aadharImage;

  const VerifyKycScreenOld(
      {Key key,
      this.userId,
      this.aadharNumber,
      this.panNumber,
      this.gstNumber,
      this.aadharImage})
      : super(key: key);

  @override
  _VerifyKycScreenOldState createState() => _VerifyKycScreenOldState();
}

//customerList[i].kycStatus == "2" && customerList[i].kycApprove == "0" || customerList[i].kycApprove == "2"

class _VerifyKycScreenOldState extends State<VerifyKycScreenOld>
    with Validator {
  final _imagePicker = ImagePicker();
  static String aadharKycId = "2";

  File _aadharImage;
  File gstImage;
  File panImage;
  TextEditingController aadharNumberController;

  bool checkBoxGst = false;
  bool checkboxAadhar = false;
  bool checkBoxPan = false;
  PageController controller;

  String gstPhoto;
  String aadharPhoto;
  String panPhoto;

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
    aadharNumberController = TextEditingController();

    controller = PageController();
    if (widget.aadharImage != null &&
        widget.aadharImage != "" &&
        widget.aadharNumber != null &&
        widget.aadharNumber != "") {
      aadharNumberController.text = widget.aadharNumber;
      checkboxAadhar = true;
    }
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
    aadharNumberController.dispose();
  }

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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kBlackColor),
              centerTitle: false,
              elevation: 0.0,
            ),
            body: PageView(
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
                          "Verify Aaadhar",
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
                          readOnly:
                              aadharNumberController.text == "" ? false : true,
                          cursorColor: kBlackColor,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(12)
                          ],
                          decoration: InputDecoration(
                              labelText: "Aadhar Number",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(color: kPrimaryColor),
                              hintText: "Enter your Aadhar Number",
                              hintStyle: TextStyle(
                                  color: kSecondaryColor, fontSize: 12),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: kPrimaryColor))),
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
                                        content: Text(
                                            'Enter your Aadhar number first',
                                            style:
                                                TextStyle(color: kWhiteColor)));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else if (aadharNumberController
                                          .text.length <
                                      12) {
                                    final snackBar = SnackBar(
                                        backgroundColor: kSecondaryColor,
                                        content: Text(
                                          'Enter correct aadhar number',
                                          style: TextStyle(color: kWhiteColor),
                                        ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else if (!regExp
                                      .hasMatch(aadharNumberController.text)) {
                                    final snackBar = SnackBar(
                                        backgroundColor: kSecondaryColor,
                                        content: Text(
                                          'Enter correct aadhar number',
                                          style: TextStyle(color: kWhiteColor),
                                        ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    aadharShowChoiceDialog();
                                  }
                                },
                                child: widget.aadharImage != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.network(
                                            imagePath + widget.aadharImage,
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover),
                                      )
                                    : _aadharImage == null
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
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text(
                                                        "Upload Aaadhar Card Image"),
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
                                color: aadharNumberController.text.isEmpty &&
                                        _aadharImage == null
                                    ? kSecondaryColor
                                    : kPrimaryColor,
                                child: aadharNumberController.text.isEmpty &&
                                        _aadharImage == null
                                    ? Text("Complete Step 1")
                                    : Text("Continue"),
                                onPressed: () {
                                  if (aadharNumberController.text.isEmpty) {
                                    final snackBar = SnackBar(
                                        backgroundColor: kSecondaryColor,
                                        content: Text(
                                            'Enter your Aadhar number or Pan card numer first',
                                            style:
                                                TextStyle(color: kWhiteColor)));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else if (aadharNumberController
                                          .text.length <
                                      12) {
                                    final snackBar = SnackBar(
                                        backgroundColor: kSecondaryColor,
                                        content: Text(
                                          'Enter correct aadhar number/pan number',
                                          style: TextStyle(color: kWhiteColor),
                                        ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else if (_aadharImage == null && widget.aadharImage == null && widget.aadharImage == "") {
                                    final snackBar = SnackBar(
                                        backgroundColor: kSecondaryColor,
                                        content: Text(
                                          'Upload Your Aaadhar Image/Pan Image First',
                                          style: TextStyle(color: kWhiteColor),
                                        ));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  } else {
                                    verifyGST();
                                  }
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )));
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
              "Verify Aaadhar",
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
                        } else if (aadharPhoto != null) {
                          final snackBar = SnackBar(
                              backgroundColor: kSecondaryColor,
                              content: Text(
                                'Aadhar card already uploaded',
                                style: TextStyle(color: kWhiteColor),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else if (!regExp
                            .hasMatch(aadharNumberController.text)) {
                          final snackBar = SnackBar(
                              backgroundColor: kSecondaryColor,
                              content: Text(
                                'Enter correct aadhar number',
                                style: TextStyle(color: kWhiteColor),
                              ));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
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
                widget.aadharImage == null && widget.aadharImage == "" && aadharPhoto == null
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
                    color:
                        aadharNumberController.text.isEmpty && aadharPhoto == ""
                            ? kSecondaryColor
                            : kPrimaryColor,
                    child: aadharNumberController.text.isEmpty &&
                            aadharPhoto == " "
                        ? Text("Complete Step 1")
                        : Text("Continue"),
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
                      } else if (aadharPhoto == null) {
                        final snackBar = SnackBar(
                            backgroundColor: kSecondaryColor,
                            content: Text(
                              'Upload Your Aaadhar Image Image First',
                              style: TextStyle(color: kWhiteColor),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        verifyGST();
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
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

  verifyGST() async {
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );
    pr.style(
      message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),
    );
    pr.show();
    var request = http.MultipartRequest('POST', Uri.parse('http://loccon.in/desiremoulding/api/UserApiController/submitAadharcard'));

    request.fields.addAll({
      'secretkey': '12!@34#\$5%',
      'aadhar_number': '123456789876',
      'customer_id': '108'
    });
    request.files.add(await http.MultipartFile.fromPath('aadhar_image', _aadharImage.path));

    http.StreamedResponse response = await request.send();
    pr.hide();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());


      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (builder) => SuccessPage(
                userId: widget.userId,
              )),
              (route) => false);
    }
    else {
      print(response.reasonPhrase);
    }
  }

  navigatePanPage() {
    current = 2;
    controller.jumpToPage(current);
  }

  showCantSkipSnackBar() {
    final snackBar =
        SnackBar(content: Text('Gstin Uploaded can"t skip.Please submit'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
