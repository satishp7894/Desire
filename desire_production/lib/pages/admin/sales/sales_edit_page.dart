import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/user_model.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../admin_user_list_page.dart';

class SalesEditPage extends StatefulWidget {
  final User salesman;
  final String userId;

  const SalesEditPage({@required this.salesman, @required this.userId});
  @override
  _SalesEditPageState createState() => _SalesEditPageState();
}

class _SalesEditPageState extends State<SalesEditPage> with Validator{

  TextEditingController fname;
  TextEditingController lname;
  TextEditingController email;
  TextEditingController phone;
  TextEditingController uName;
  TextEditingController address;
  TextEditingController city;
  TextEditingController state;
  TextEditingController pincode;

  final _imagePicker = ImagePicker();
  File _imageFile;
  String photo;

  String id;
  final _focusNode = FocusNode();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    checkConnectivity();
    fname = TextEditingController(text: widget.salesman.firstname);
    lname = TextEditingController(text: widget.salesman.lastname);
    email = TextEditingController(text: widget.salesman.email);
    phone = TextEditingController(text: widget.salesman.userMobile);
    uName = TextEditingController(text: widget.salesman.username);
    address = TextEditingController(text: widget.salesman.address);
    city = TextEditingController(text: widget.salesman.city);
    state = TextEditingController(text: widget.salesman.state);
    pincode = TextEditingController(text: widget.salesman.pincode);
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
    });
    super.initState();
  }

  checkConnectivity() async{
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }

  @override
  void dispose() {
    fname.dispose();
    lname.dispose();
    email.dispose();
    phone.dispose();
    uName.dispose();
    address.dispose();
    city.dispose();
    state.dispose();
    pincode.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
          appBar: AppBar(
            title: Text("User Details"),
            centerTitle: true,
            elevation: 0,
            backgroundColor:kSecondaryColor.withOpacity(0),
            titleTextStyle: headingStyle,
            textTheme: Theme.of(context).textTheme,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: (){
              Navigator.of(context).pop();
            },),
          ),
          body: _body(),
        )
    );
  }

  Widget _body(){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: Form(
              autovalidateMode: _autovalidateMode,
              key: _formkey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 25.0),
                      child: new Text(
                        'Personal Information',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'First Name',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: TextFormField(
                              validator: validateName,
                              controller: fname,
                              decoration: const InputDecoration(
                                hintText: "Enter Your First Name",
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Last Name',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: TextFormField(
                              validator: validateName,
                              controller: lname,
                              decoration: const InputDecoration(
                                hintText: "Enter Your Last Name",
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'User Name',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: TextFormField(
                              validator: validateRequired,
                              controller: uName,
                              decoration: const InputDecoration(
                                hintText: "Enter Your User Name",
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Email ID',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              validator: validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              controller: email,
                              decoration: const InputDecoration(
                                  hintText: "Enter Email ID"),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Mobile',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: TextFormField(
                              controller: phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validator: validateMobile,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  hintText: "Enter Mobile Number"),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Flat No/House No',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              //readOnly: true,
                              controller: address,
                              validator: validateRequired,
                              keyboardType: TextInputType.streetAddress,
                              decoration: const InputDecoration(
                                  hintText: "Enter Flat No/ House No."),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'City',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              //readOnly: true,
                              controller: city,
                              validator: validateRequired,
                              keyboardType: TextInputType.streetAddress,
                              decoration: const InputDecoration(
                                  hintText: "Enter City"),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Pincode',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: Focus(
                              onFocusChange: (v){
                                // getOtherAttributes(pincode.text);
                                print("object focus changed rsponse $v");
                                if(v == false){
                                  if (pincode.text.length == 6) {
                                    getOtherAttributes(pincode.text);
                                  } else {
                                    Alerts.showAlertAndBack(context, "Incorrect PinCode", "Enter a valid Pincode");
                                  }
                                }
                              },
                              child: TextFormField(
                                controller: pincode,
                                focusNode: _focusNode,
                                validator: validatePinCode,
                                // onFieldSubmitted: (value){
                                //   getOtherAttributes(value);
                                // },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: "Enter Pincode"),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'State',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              readOnly: true,
                              controller: state,
                              validator: validateRequired,
                              keyboardType: TextInputType.streetAddress,
                              decoration: const InputDecoration(
                                  hintText: "Enter State"),
                            ),
                          ),
                        ],
                      )),
                  _imageFile == null ? widget.salesman.userPhoto == "" ? Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                    child: Icon(Icons.person_outline, color: Colors.black, size: 150,),
                  ) : Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                      child: Image.network("http://loccon.in/desiremoulding/upload/Image/Admin/${widget.salesman.userPhoto}",height: 150, width: 150,)
                    ) :
                  Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                      child: Image.file(_imageFile, height: 150, width: 150,)),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: TextButton(
                        onPressed: () {
                          futureShowChoiceDialog();
                        },
                        child: Text("Upload Image"),),
                    ),
                  ),
                  _getActionButtons()
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: DefaultButton(
                    text: "Save",
                    press: () async{
                      print("secretkey"+Connection.secretKey+
                          "user_role"+widget.salesman.roleId+
                          "firstname"+fname.text+
                          "lastname"+lname.text+
                          "email"+email.text+
                          "username"+uName.text+
                          "mobile_no"+phone.text+
                          "pincode"+pincode.text+
                          "state"+state.text+
                          "city"+city.text+
                          "address"+address.text+
                          "user_id"+widget.userId+
                          "admin_user_id"+widget.salesman.userId+"imagefile $_imageFile");
                      if (_formkey.currentState.validate()) {
                        _formkey.currentState.save();
                        ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
                        pr.style(message: 'Uploading Data');
                        pr.show();

                        String value = await updateUser(_imageFile);
                        print("value $value");

                        setState(() {
                          if(value == "success"){
                            final snackBar = SnackBar(content: Text('User Updated Successfully'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AdminUserListPage(adminUserId: widget.userId,)), (Route<dynamic> route) => false);
                          } else {
                            pr.hide();
                            Alerts.showAlertAndBack(context, "Error", "Error Updating User");
                          }
                        });

                        pr.hide();
                      } else{
                        setState(() {
                          _autovalidateMode = AutovalidateMode.always;
                        });
                      }
                    },
                  )
              ),),),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                child: DefaultButton1(
                  text: "Cancel",
                  press: (){
                    setState(() {
                      fname.text = widget.salesman.firstname;
                      lname.text = widget.salesman.lastname;
                      email.text = widget.salesman.email;
                      phone.text = widget.salesman.userMobile;
                      uName.text = widget.salesman.username;
                      address.text = widget.salesman.address;
                      city.text = widget.salesman.city;
                      state.text = widget.salesman.state;
                      pincode.text = widget.salesman.pincode;
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // getUpdated() async{
  //
  //   print("secretkey"+Connection.secretKey+
  //     "user_role"+widget.salesman.roleId+
  //     "firstname"+fname.text+
  //     "lastname"+lname.text+
  //     "email"+email.text+
  //     "username"+uName.text+
  //     "mobile_no"+phone.text+
  //     "pincode"+pincode.text+
  //     "state"+state.text+
  //     "city"+city.text+
  //     "address"+address.text+
  //     "user_id"+widget.userId+
  //     "admin_user_id"+widget.salesman.userId);
  //
  //   if (_formkey.currentState.validate()) {
  //     _formkey.currentState.save();
  //     ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
  //       isDismissible: false,);
  //     pr.style(message: 'Please wait...',
  //       progressWidget: Center(child: CircularProgressIndicator()),);
  //     pr.show();
  //     var response = await http.post(Uri.parse(Connection.editAdminDetails), body: {
  //       "secretkey":Connection.secretKey,
  //       "user_role":widget.salesman.roleId,
  //       "firstname":fname.text,
  //       "lastname":lname.text,
  //       "email":email.text,
  //       "username":uName.text,
  //       "password":"8866123",
  //       "mobile_no":phone.text,
  //       "pincode":pincode.text,
  //       "state":state.text,
  //       "city":city.text,
  //       "address":address.text,
  //       "user_id":"2",
  //       "admin_user_id":widget.salesman.userId,
  //       "image":""
  //     });
  //     var results = json.decode(response.body);
  //     print('response == $results  ${response.body}');
  //     pr.hide();
  //     if (results['status'] == true) {
  //       final snackBar = SnackBar(content: Text('User Profile Updated Successfully'));
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AdminUserListPage(adminUserId: widget.userId,)), (Route<dynamic> route) => false);
  //     } else {
  //       print('error in updating profile');
  //       Alerts.showAlertAndBack(context, 'Error', 'User Profile not Updated. Please try again later');
  //     }
  //   } else {
  //     setState(() {
  //       _autovalidateMode = AutovalidateMode.always;
  //     });
  //   }
  //
  // }

  getOtherAttributes(String pin) async{
    print("object pin $pin");
    if(pin.isEmpty || pin.length > 6){
      Alerts.showAlertAndBack(context, "Invalid Value", "Please Enter 6 digit Pincode");
    } else {
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();
      var response = await http.get(Uri.parse(Connection.getAttributes+"$pin"));
      var result = json.decode(response.body);


      if(result[0]["Message"] == "No records found"){
        pr.hide();
        Alerts.showAlertAndBack(context, "Incorrect PinCode", "Enter a valid Pincode");
      } else {
        //String cityN = result[0]["PostOffice"][0]["Division"];
        String stateN = result[0]["PostOffice"][0]["State"];
        //String districtN = result[0]["PostOffice"][0]["District"];

        setState(() {
          //city = TextEditingController(text: cityN);
          state = TextEditingController(text: stateN);
          //district = TextEditingController(text: districtN);
          // for(int i=0; i<result[0]["PostOffice"].length; i++){
          //   print("value for areas ${result[0]["PostOffice"][i]["Name"]}");
          //   areaWise.add("${result[0]["PostOffice"][i]["Name"]}");
          // }
        });

        print(
            "object value for the region ${result[0]["Message"]} ${result[0]["PostOffice"][0]["Region"]}");
        pr.hide();
      }
    }
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
                  _uploadGallery();

                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _uploadCamera();
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
            ],
          ),
        ),);
    });
  }

  _uploadGallery() async {

    final _pickedPic = await _imagePicker.pickImage(source: ImageSource.gallery);

    _imageFile = File(_pickedPic.path);

  }

  _uploadCamera() async {

    final _pickedPic = await _imagePicker.pickImage(source: ImageSource.camera);

    _imageFile = File(_pickedPic.path);

  }

  Future<String> updateUser(File photo) async {

    //print("object inside upload ${photo.path}");

    var request = http.MultipartRequest("POST", Uri.parse(Connection.editAdminDetails));

    request.fields['secretkey'] = '${Connection.secretKey}';
    request.fields['user_role'] = '${widget.salesman.roleId}';
    request.fields['firstname'] = '${fname.text}';
    request.fields['lastname'] = '${lname.text}';
    request.fields['email'] = '${email.text}';
    request.fields['username'] = '${uName.text}';
    request.fields['password'] = '8866123853';
    request.fields['mobile_no'] = '${phone.text}';
    request.fields['pincode'] = '${pincode.text}';
    request.fields['state'] = '${state.text}';
    request.fields['city'] = '${city.text}';
    request.fields['address'] = '${address.text}';
    request.fields['user_id'] = '2';
    request.fields['admin_user_id'] = '${widget.salesman.userId}';
    photo == null ? request.files.add(await http.MultipartFile.fromString("image","", filename: "DisplayPicture${widget.userId}.jpg", contentType: MediaType('image', 'jpeg'))) :
    request.files.add(await http.MultipartFile.fromPath('image', photo.path, filename: 'DisplayPicture${widget.userId}.jpg', contentType: MediaType('image', 'jpeg')));

    final streamResponse = await request.send();

    print("object ${streamResponse.statusCode}");
    print("object response ${streamResponse.statusCode} ${streamResponse.request}");

    if (streamResponse.statusCode >= 200 && streamResponse.statusCode <= 299) {
      final http.Response response = await http.Response.fromStream(streamResponse);
      final results = json.decode(response.body);
      if (results['data'] != null) {
        print("object ${results['data']}");
        return "success";
      } else {
        return null;
      }
    } else {
      return "false";
    }
  }
}
