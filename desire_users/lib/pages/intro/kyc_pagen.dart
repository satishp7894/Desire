import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/kyc_bloc.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/models/kyc_view_model.dart';
import 'package:desire_users/pages/intro/success_page.dart';
import 'package:desire_users/services/api_client.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/progress_dialog.dart';
import 'package:desire_users/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class KYCPageN extends StatefulWidget {

  final String userId;

  KYCPageN({@required this.userId});

  @override
  _KYCPageNState createState() => _KYCPageNState();
}

class _KYCPageNState extends State<KYCPageN> with Validator{

  final _imagePicker = ImagePicker();
  File _imageFile1;
  File _imageFile2;
  File _imageFile3;
  TextEditingController kyc1, kyc2, kyc3;

  bool check1 = false;
  bool check2 = false;
  bool check3 = false;

  String photo1;
  String photo2;
  String photo3;

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
    kyc1 = TextEditingController();
    kyc2 = TextEditingController();
    kyc3 = TextEditingController();
  }

  checkConnectivity() async{
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }

  @override
  void dispose() {
    super.dispose();
    kyc1.dispose();
    kyc2.dispose();
    kyc3.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          // appBar: AppBar(
          //   //title: Text("KYC Form",style: headingStyle,),
          //   centerTitle: true,
          //   automaticallyImplyLeading: false,
          //   backgroundColor: Colors.transparent,
          //   elevation: 0,
          //   titleTextStyle: headingStyle,
          //   textTheme: Theme.of(context).textTheme,
          // ),
          body: RefreshIndicator(
            onRefresh: (){
              return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => KYCPageN(userId: widget.userId)), (route) => false);
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                  children:[
                    clipShape(),
                    Text("KYC Form",style: headingStyle,textAlign: TextAlign.center,),
                    Text(
                      "Please submit your KYC details",
                      textAlign: TextAlign.center,
                    ),
                    _body()]),
            ),
          ),
        ));
  }

  Widget _body(){
    return StreamBuilder<KycViewModel>(
      stream: kycBloc.kycViewStream,
      builder: (c, s) {

        if (s.connectionState != ConnectionState.active) {
          print("all connection");
          return Container(height: 300,
              alignment: Alignment.center,
              child: Center(
                heightFactor: 50, child: CircularProgressIndicator(),));
        }
        if (s.hasError) {
          print("as3 error");
          return Container(height: 300,
            alignment: Alignment.center,
            child: Text("Error Loading Data",),);
        }
        if (s.data.data == null) {
          print("as3 empty");
          return Form(
            autovalidateMode: _autoValidateMode,
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              autofocus: true,
                              controller: kyc2,
                              textCapitalization: TextCapitalization.characters,
                              //validator: validateAdhaarNo,
                              maxLength: 12,
                              inputFormatters: [
                                //FilteringTextInputFormatter.allow(RegExp("^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}\$")),
                                LengthLimitingTextInputFormatter(12),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Aadhaar No.",
                                hintStyle: TextStyle(color: Colors.black45),
                                //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(30)),
                                //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(30)),
                                //focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Expanded(child: _imageFile2 == null ? Container(height: 100,width: 50, child: Text("Add Image"),) : Image.file(_imageFile2, height: 140, width: 140, fit: BoxFit.cover)),
                          SizedBox(width: 10,),
                          GestureDetector(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Icon(Icons.collections, color: Colors.black, size: 50,)),
                            onTap: () {
                              if(kyc2.text.isEmpty){
                                Alerts.showAlertAndBack(context, "Textfield", "Please enter Aadhaar No.");
                              }else if(kyc2.text.length < 12){
                                Alerts.showAlertAndBack(context, "Incorrect", "Please enter Correct Aadhaar No.");
                              }  else {
                                futureShowChoiceDialog1();
                              }
                            },
                          ),
                          Checkbox(value: check2 ? true : false, onChanged: (v){
                            setState(() {
                              check2 =!v;
                              Alerts.showAlertAndBack(context, "", "You cannot change this value");
                            });
                          }),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              autofocus: true,
                              controller: kyc1,
                              textCapitalization: TextCapitalization.characters,
                              //validator: validateGSTNo,
                              maxLength: 15,
                              inputFormatters: [
                                //FilteringTextInputFormatter.allow(RegExp("[0-9]{2}[a-zA-Z]{5}[0-9]{4}[a-zA-Z]{1}[1-9A-Za-z]{1}[Z]{1}[0-9a-zA-Z]{1}")),
                                LengthLimitingTextInputFormatter(15),
                              ],
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "GST No.",
                                hintStyle: TextStyle(color: Colors.black45),
                                //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(30)),
                                //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(30)),
                                //focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Expanded(child: _imageFile1 == null ? Container(height: 100,width: 50, child: Text("Add Image"),) : Image.file(_imageFile1, height: 140, width: 140, fit: BoxFit.cover)),
                          SizedBox(width: 10,),
                          GestureDetector(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Icon(Icons.collections, color: Colors.black, size: 50,)),
                            onTap: () {
                              if(kyc1.text.isEmpty){
                                Alerts.showAlertAndBack(context, "Textfield", "Please enter GST No.");
                              } else if(kyc1.text.length < 15){
                                Alerts.showAlertAndBack(context, "Incorrect", "Please enter GST No.");
                              } else {
                                futureShowChoiceDialog();

                              }
                            },
                          ),
                          Checkbox(value: check1 ? true : false, onChanged: (v){
                            setState(() {
                              check1 =!v;
                              Alerts.showAlertAndBack(context, "", "You cannot change this value");
                            });
                          }),
                        ],
                      ),
                    ),
                  ),
                  Text("OR"),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              autofocus: true,
                              controller: kyc3,
                              textCapitalization: TextCapitalization.characters,
                              //validator: validatePANNo,
                              maxLength: 10,
                              inputFormatters: [
                                //FilteringTextInputFormatter.allow(RegExp("[A-Z]{5}[0-9]{4}[A-Z]{1}")),
                                LengthLimitingTextInputFormatter(10),
                              ],
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "PAN No.",
                                hintStyle: TextStyle(color: Colors.black45),
                                //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(30)),
                                //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(30)),
                                //focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          Expanded(child: _imageFile3 == null ? Container(height: 100,width: 50, child: Text("Add Image"),) : Image.file(_imageFile3, height: 140, width: 140, fit: BoxFit.cover)),
                          SizedBox(width: 10,),
                          GestureDetector(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Icon(Icons.collections, color: Colors.black, size: 50,)),
                            onTap: () {
                              if(kyc3.text.isEmpty){
                                Alerts.showAlertAndBack(context, "Textfield", "Please enter PAN No.");
                              } else if(kyc3.text.length < 10){
                                Alerts.showAlertAndBack(context, "Incorrect", "Please enter corrct PAN No.");
                              } else {
                                futureShowChoiceDialog2();
                              }
                            },
                          ),
                          Checkbox(value: check3 ? true : false, onChanged: (v){
                            setState(() {
                              check3 =!v;
                              Alerts.showAlertAndBack(context, "", "You cannot change this value");
                            });
                          }),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: DefaultButton(text: "Submit",press: (){
                      if(check2 == true && (check1 == true || check3 == true) && kyc2.text.length == 12 && ( kyc1.text.length == 15 || kyc3.text.length == 10)){
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SuccessPage(userId: widget.userId,)), (route) => false);
                        } else {
                          setState(() {
                            _autoValidateMode = AutovalidateMode.always;
                          });
                        }
                      } else {
                        Alerts.showAlertAndBack(context, "Incomplete", "Please add all details");
                      }
                    },),
                  )
                ]
            ),
          );
        }

        for(int i = 0; i < s.data.data.length; i++){
          if(s.data.data[i].kycId == "1"){
            check3 = true;
            kyc3.text = s.data.data[i].number;
            photo3 = "${s.data.data[i].photo}";
            print("object3 ${kyc3.text} $photo3 ");
          }

          if(s.data.data[i].kycId == "2"){
            check2 = true;
            kyc2.text = s.data.data[i].number;
            photo2 = "${s.data.data[i].photo}";
            print("object3 ${kyc2.text} $photo2 ");
          }

          if(s.data.data[i].kycId == "3"){
            check1 = true;
            kyc1.text = s.data.data[i].number;
            photo1 = "${s.data.data[i].photo}";
            print("object1 ${kyc1.text} $photo1 ");
          }

        }

        return Form(
          key: _formKey1,
          autovalidateMode: _autoValidateMode1,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Please submit your KYC details",
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            autofocus: kyc2.text == "" ? true : false,
                            readOnly: kyc2.text == "" ? false : true,
                            controller: kyc2,
                            textCapitalization: TextCapitalization.characters,
                            //validator: validateAdhaarNo,
                            maxLength: 12,
                            inputFormatters: [
                              //FilteringTextInputFormatter.allow(RegExp("[A-Z]{5}[0-9]{4}[A-Z]{1}")),
                              LengthLimitingTextInputFormatter(12),
                            ],
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Aadhaar No.",
                              hintStyle: TextStyle(color: Colors.black45),
                              //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(30)),
                              //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(30)),
                              //focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        photo2 == "" ? Expanded(child: _imageFile2 == null ? Container(height: 100,width: 50, child: Text("Add Image"),) : Image.file(_imageFile2, height: 140, width: 140, fit: BoxFit.cover)) : Expanded(child: Image.network("$imagePath$photo2", height: 140, width: 140, fit: BoxFit.cover)),
                        SizedBox(width: 10,),
                        kyc2.text == "" ? GestureDetector(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Icon(Icons.collections, color: Colors.black, size: 50,)),
                          onTap: () {
                            if(kyc2.text.isEmpty){
                              Alerts.showAlertAndBack(context, "Textfield", "Please enter Aadhaar No.");
                            }else if(kyc2.text.length < 12){
                              Alerts.showAlertAndBack(context, "Incorrect", "Please enter Correct Aadhaar No.");
                            }  else {
                              futureShowChoiceDialog1();
                            }
                          },
                        ) : Container(),
                        Checkbox(value: check2 ? true : false, onChanged: (v){
                          setState(() {
                            check2 =!v;
                            Alerts.showAlertAndBack(context, "", "You cannot change this value");
                          });
                        }),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            autofocus: kyc1.text == "" ? true : false,
                            readOnly: kyc1.text == "" ? false : true,
                            controller: kyc1,
                            textCapitalization: TextCapitalization.characters,
                            //validator: validateGSTNo,
                            maxLength: 15,
                            inputFormatters: [
                              //FilteringTextInputFormatter.allow(RegExp("[A-Z]{5}[0-9]{4}[A-Z]{1}")),
                              LengthLimitingTextInputFormatter(15),
                            ],
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "GST No.",
                              hintStyle: TextStyle(color: Colors.black45),
                              //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(30)),
                              //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(30)),
                              //focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        photo1 == "" ? Expanded(child: _imageFile1 == null ? Container(height: 100,width: 50, child: Text("Add Image"),) : Image.file(_imageFile1, height: 140, width: 140, fit: BoxFit.cover)) : Expanded(child: Image.network("$imagePath$photo1", height: 140, width: 140, fit: BoxFit.cover)),
                        SizedBox(width: 10,),
                        kyc1.text == "" ? GestureDetector(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Icon(Icons.collections, color: Colors.black, size: 50,)),
                          onTap: () {
                            if(kyc1.text.isEmpty){
                              Alerts.showAlertAndBack(context, "Textfield", "Please enter GST No.");
                            } else if(kyc1.text.length < 15){
                              Alerts.showAlertAndBack(context, "Incorrect", "Please enter GST No.");
                            } else {
                              print(Validator().validateGSTNo(kyc1.text));
                              futureShowChoiceDialog();
                            }
                          },
                        ) : Container(),
                        Checkbox(value: check1 ? true : false, onChanged: (v){
                          setState(() {
                            check1 =!v;
                            Alerts.showAlertAndBack(context, "", "You cannot change this value");
                          });
                        }),
                      ],
                    ),
                  ),
                ),
                Text("OR"),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            autofocus: kyc3.text == "" ? true : false,
                            controller: kyc3,
                            textCapitalization: TextCapitalization.characters,
                            //validator: validatePANNo,
                            maxLength: 10,
                            inputFormatters: [
                              //FilteringTextInputFormatter.allow(RegExp("[A-Z]{5}[0-9]{4}[A-Z]{1}")),
                              LengthLimitingTextInputFormatter(10),
                            ],
                            readOnly: kyc3.text == "" ? false : true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "PAN No.",
                              hintStyle: TextStyle(color: Colors.black45),
                              //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(30)),
                              //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(30)),
                              //focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(30)),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        photo3 == "" ? Expanded(child: _imageFile3 == null ? Container(height: 100,width: 50, child: Text("Add Image"),) : Image.file(_imageFile3, height: 140, width: 140, fit: BoxFit.cover)) : Expanded(child: Image.network("$imagePath$photo3", height: 140, width: 140, fit: BoxFit.cover)),
                        SizedBox(width: 10,),
                        kyc3.text == "" ? GestureDetector(
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Icon(Icons.collections, color: Colors.black, size: 50,)),
                          onTap: () {
                            if(kyc3.text.isEmpty){
                              Alerts.showAlertAndBack(context, "Textfield", "Please enter PAN No.");
                            } else if(kyc3.text.length < 10){
                              Alerts.showAlertAndBack(context, "Incorrect", "Please enter corrct PAN No.");
                            } else {
                              print(Validator().validatePANNo(kyc3.text));
                              futureShowChoiceDialog2();
                            }
                          },
                        ) : Container(),
                        Checkbox(value: check3 ? true : false, onChanged: (v){
                          setState(() {
                            check3 =!v;
                            Alerts.showAlertAndBack(context, "", "You cannot change this value");
                          });
                        }),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: DefaultButton(text: "Submit",press: (){
                    if(check2 == true && (check1 == true || check3 == true) && kyc2.text.length == 12 && ( kyc1.text.length == 15 || kyc3.text.length == 10)){
                      print("object condition true");
                      //if (_formKey.currentState.validate()) {
                        //_formKey.currentState.save();
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SuccessPage(userId: widget.userId,)), (route) => false);
                      //} else {
                        //setState(() {
                          //_autoValidateMode = AutovalidateMode.always;
                        //});
                      } else {
                      Alerts.showAlertAndBack(context, "Incomplete", "Please add all details");
                    }
                  },),
                )
              ]
          ),
        );
      }
    );
  }

  _uploadProfilePictureGallery1() async {
    print("values from text ${widget.userId}, ${kyc1.text}");
    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.gallery);

    _imageFile1 = File(_pickedPic.path);

    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Data');
    pr.show();
    final _apiClient = ApiClient();
    String value = await _apiClient.updateProfilePhoto(_imageFile1,"${widget.userId}","3","${kyc1.text}");
    print("value $value");

    setState(() {
      if(value == "success"){
        check1 = true;
        final snackBar = SnackBar(content: Text('Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        Alerts.showAlertAndBack(context, "Error", "Error loading image");
      }
    });
    pr.hide();
  }
  _uploadProfilePictureCamera1() async {
    print("values from text ${widget.userId}, ${kyc1.text}");
    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.camera);

    _imageFile1 = File(_pickedPic.path);


    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Data');
    pr.show();
    final _apiClient = ApiClient();
    String value = await _apiClient.updateProfilePhoto(_imageFile1,"${widget.userId}","3","${kyc1.text}");
    print("value $value");

    setState(() {
      if(value == "success"){
        check1 = true;
        final snackBar = SnackBar(content: Text('Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        Alerts.showAlertAndBack(context, "Error", "Error loading image");
      }
    });
    pr.hide();
  }
  _uploadProfilePictureGallery2() async {
    print("values from text ${widget.userId}, ${kyc2.text}");
    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.gallery);

    _imageFile2 = File(_pickedPic.path);


    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Data');
    pr.show();
    final _apiClient = ApiClient();
    String value = await _apiClient.updateProfilePhoto(_imageFile2,"${widget.userId}","2","${kyc2.text}");
    print("value $value");

    setState(() {
      if(value == "success"){
        check2 = true;
        final snackBar = SnackBar(content: Text('Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        Alerts.showAlertAndBack(context, "Error", "Error loading image");
      }
    });
    pr.hide();
  }
  _uploadProfilePictureCamera2() async {
    print("values from text ${widget.userId}, ${kyc2.text}");
    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.camera);

    _imageFile2 = File(_pickedPic.path);


    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Data');
    pr.show();
    final _apiClient = ApiClient();
    String value = await _apiClient.updateProfilePhoto(_imageFile2,"${widget.userId}","2","${kyc2.text}");
    print("value $value");

    setState(() {
      if(value == "success"){
        check2 = true;
        final snackBar = SnackBar(content: Text('Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        Alerts.showAlertAndBack(context, "Error", "Error loading image");
      }
    });
    pr.hide();
  }
  _uploadProfilePictureGallery3() async {

    print("values from text ${widget.userId}, ${kyc3.text}");

    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.gallery);

    _imageFile3 = File(_pickedPic.path);

    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Data');
    pr.show();

    final _apiClient = ApiClient();

    String value = await _apiClient.updateProfilePhoto(_imageFile3,"${widget.userId}","1","${kyc3.text}");

    print("value $value");

    setState(() {
      if(value == "success"){
        check3 = true;
        final snackBar = SnackBar(content: Text('Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        Alerts.showAlertAndBack(context, "Error", "Error loading image");
      }
    });

    pr.hide();

  }
  _uploadProfilePictureCamera3() async {

    print("values from text ${widget.userId}, ${kyc3.text}");

    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.camera);

    _imageFile3 = File(_pickedPic.path);


    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Data');
    pr.show();
    final _apiClient = ApiClient();
    String value = await _apiClient.updateProfilePhoto(_imageFile3,"${widget.userId}","1","${kyc3.text}");
    print("value $value");

    setState(() {
      if(value == "success"){
        check3 = true;
        final snackBar = SnackBar(content: Text('Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        Alerts.showAlertAndBack(context, "Error", "Error loading image");
      }
    });
    pr.hide();
  }
  futureShowChoiceDialog() {
    return showDialog(context: context,builder: (BuildContext context){

      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.blue),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _uploadProfilePictureGallery1();

                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _uploadProfilePictureCamera1();
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
            ],
          ),
        ),);
    });
  }
  futureShowChoiceDialog1() {
    return showDialog(context: context,builder: (BuildContext context){

      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.blue),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _uploadProfilePictureGallery2();

                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _uploadProfilePictureCamera2();
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
            ],
          ),
        ),);
    });
  }
  futureShowChoiceDialog2() {
    return showDialog(context: context,builder: (BuildContext context){

      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.blue),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _uploadProfilePictureGallery3();

                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _uploadProfilePictureCamera3();
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
            ],
          ),
        ),);
    });
  }

  Widget clipShape() {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large? _height/8 : (_medium? _height/7 : _height/6.5),
              decoration: BoxDecoration(
                gradient: kPrimaryGradientColor,
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large? _height/12 : (_medium? _height/11 : _height/10),
              decoration: BoxDecoration(
                gradient: kPrimaryGradientColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height-70);

    var firstEndPoint = Offset(size.width * .5, size.height - 30.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height - 50.0);
    path.quadraticBezierTo(firstControlpoint.dx, firstControlpoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height - 50.0);
    var secondControlPoint = Offset(size.width * .75, size.height - 10);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;


}

class CustomShapeClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 20);

    var firstEndPoint = Offset(size.width * .5, size.height - 30.0);
    var firstControlpoint = Offset(size.width * 0.25, size.height - 50.0);
    path.quadraticBezierTo(
        firstControlpoint.dx, firstControlpoint.dy, firstEndPoint.dx,
        firstEndPoint.dy);

    var secondEndPoint = Offset(size.width, size.height-5);
    var secondControlPoint = Offset(size.width * .75, size.height - 20);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx,
        secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;


}

class ResponsiveWidget{

  static bool isScreenLarge(double width, double pixel) {
    return width * pixel >= 1440;
  }

  static bool isScreenMedium(double width, double pixel) {
    return width * pixel < 1440 && width * pixel >=1080;
  }

  static bool isScreenSmall(double width, double pixel) {
    return width * pixel <= 720;
  }
}
