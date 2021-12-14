import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/services/connection.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/default_button.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/sales/utils_sales/validator.dart';
import 'package:desire_users/services/connection_sales.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesProfilePage extends StatefulWidget {
  @override
  _SalesProfilePageState createState() => _SalesProfilePageState();
}

class _SalesProfilePageState extends State<SalesProfilePage> with Validator{

  TextEditingController name;
  TextEditingController lname;
  TextEditingController email;
  TextEditingController pass;
  TextEditingController passNew;
  TextEditingController phone;
  TextEditingController uname;
  TextEditingController address;
  TextEditingController city;
  TextEditingController state;
  TextEditingController pincode;

  final myFocusNode = FocusNode();

  String id;
  String password;
  String passwordOld;


  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode1 = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();

  @override
  void initState() {
    checkConnectivity();
    name = TextEditingController();
    lname = TextEditingController();
    email = TextEditingController();
    pass = TextEditingController();
    passNew = TextEditingController();
    phone = TextEditingController();
    uname = TextEditingController();
    address = TextEditingController();
    city = TextEditingController();
    state = TextEditingController();
    pincode = TextEditingController();
    myFocusNode.addListener(() {
      print("Has focus: ${myFocusNode.hasFocus}");
    });
    getDetails();
    super.initState();
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
    name.dispose();
    lname.dispose();
    email.dispose();
    pass.dispose();
    passNew.dispose();
    phone.dispose();
    uname.dispose();
    address.dispose();
    city.dispose();
    state.dispose();
    pincode.dispose();
    myFocusNode.dispose();
    super.dispose();
  }

  getDetails() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString("sales_id");
    name.text = prefs.getString("sales_name");
    lname.text = prefs.getString("sales_lname");
    email.text = prefs.getString("sales_email");
    phone.text = prefs.getString("sales_mobile");
    uname.text = prefs.getString("sales_username");
    password = prefs.getString("sales_password");
    passwordOld = prefs.getString("sales_password");
    address.text = prefs.getString("sales_address");
    city.text = prefs.getString("sales_city");
    state.text = prefs.getString("sales_State");
    pincode.text = prefs.getString("sales_pincode");
    print("sales pass $passwordOld $password ${prefs.getString("sales_password")}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
              Navigator.of(context).pop();
            },),
            title: Text("Your Profile", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
            centerTitle: true,
          ),
          body: _body(),
        ));
  }

  bool _status = true;
  bool _status1 = true;
  bool _statusPass = false;

  Widget _body(){
    print("object value of pass $password $passwordOld");
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
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Personal Information',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _status ? _getEditIcon() : new Container(),
                            ],
                          )
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
                              controller: name,
                              decoration: const InputDecoration(
                                hintText: "Enter Your First Name",
                              ),
                              enabled: !_status,
                              autofocus: !_status,

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
                              enabled: !_status,
                              autofocus: !_status,

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
                              validator: validateName,
                              controller: uname,
                              decoration: const InputDecoration(
                                hintText: "Enter Your User Name",
                              ),
                              enabled: !_status,
                              autofocus: !_status,

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
                                'Email',
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
                              readOnly: true,
                              controller: email,
                              validator: validateRequired,
                              keyboardType: TextInputType.streetAddress,
                              decoration: const InputDecoration(
                                  hintText: "Enter Email"),
                              enabled: !_status,
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
                            child: new TextFormField(
                              controller: phone,
                              validator: validateMobile,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  hintText: "Enter Mobile Number"),
                              enabled: !_status,
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
                                'Address',
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
                              readOnly: true,
                              controller: address,
                              validator: validateRequired,
                              keyboardType: TextInputType.streetAddress,
                              decoration: const InputDecoration(
                                  hintText: "Enter Address"),
                              enabled: !_status,
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
                              enabled: !_status,
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
                                //readOnly: true,
                                controller: pincode,
                                focusNode: myFocusNode,
                                validator: validatePinCode,
                                onFieldSubmitted: (value){
                                  getOtherAttributes(value);
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: "Enter Pincode"),
                                enabled: !_status,
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
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              //readOnly: true,
                              controller: state,
                              validator: validateRequired,
                              keyboardType: TextInputType.streetAddress,
                              decoration: const InputDecoration(
                                  hintText: "Enter State"),
                              enabled: !_status,
                            ),
                          ),
                        ],
                      )),
                  !_status ? _getActionButtons() : new Container(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: Form(
              autovalidateMode: _autovalidateMode1,
              key: _formkey1,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Login Information',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              _status1 ? _getEditIcon1() : new Container(),
                            ],
                          )
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
                                'Email',
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
                              validator: validateEmail,
                              controller: email,
                              decoration: const InputDecoration(
                                hintText: "Enter Your EmailId",
                              ),
                              enabled: !_status1,
                              autofocus: !_status1,

                            ),
                          ),
                        ],
                      )
                  ),
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
                                'Old Password',
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
                              //validator: validateName,
                              controller: pass,
                              textInputAction: TextInputAction.next,
                              focusNode: myFocusNode,
                              validator: validateRequired,
                              decoration: const InputDecoration(
                                hintText: "Enter Your Old Password",
                              ),
                              onEditingComplete: (){
                                if(md5.convert(utf8.encode(pass.text)).toString() != password ){
                                  Alerts.showAlertAndBack(context, "Wrong Password", "Enter Correct Old Password");
                                } else {
                                  _statusPass = true;
                                }
                                print("object value of pass inside on edit complete $password $passwordOld");

                              },
                              enabled: !_status1,
                              autofocus: !_status1,

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
                                'New Password',
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
                              //validator: validateName,
                              readOnly: _statusPass ? false : true,
                              textInputAction: TextInputAction.done,
                              controller: passNew,
                              decoration: const InputDecoration(
                                hintText: "Enter Your New Password",
                              ),
                              onTap: (){
                                print("object ${myFocusNode.hasFocus}");
                                if(myFocusNode.hasFocus){
                                  if(md5.convert(utf8.encode(pass.text)).toString() != password ){
                                    Alerts.showAlertAndBack(context, "Wrong Password", "Enter Correct Old Password");
                                  } else {
                                    setState(() {
                                      _statusPass = true;
                                    });
                                  }
                                  print("object value of pass inside on edit complete $password $passwordOld");

                                }
                              },
                              enabled: !_status1,
                              autofocus: !_status1,

                            ),
                          ),
                        ],
                      )),
                  !_status1 ? _getActionButtons1() : new Container(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Widget _getEditIcon1() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status1 = false;
        });
      },
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
                  child: DefaultButtonSuccess(
                    text: "Save",
                    press: (){
                      getUpdated();
                    },
                  )
              ),),),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                child: DefaultButtonCancel(
                  text: "Cancel",
                  press: (){
                    setState(() {
                      _status = true;
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

  Widget _getActionButtons1() {
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
                  child: DefaultButtonSuccess(
                    text: "Save",
                    press: (){
                      getLoginUpdated();
                    },
                  )
              ),),),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                child: DefaultButtonCancel(
                  text: "Cancel",
                  press: (){
                    setState(() {
                      _status1 = true;
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

  getUpdated() async{

    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();
      var response = await http.post(Uri.parse(ConnectionSales.updateProfile), body: {

        'secretkey': ConnectionSales.secretKey,
        'salesid':id,
        'fname': name.text,
        'lname': lname.text,
        'username' : uname.text,
        'mobile': phone.text,
        'address' : address.text,
        'City' : city.text,
        'State' : state.text,
        'Pincode' : pincode.text,
      });
      var results = json.decode(response.body);
      print('response == $results  ${response.body}');
      pr.hide();
      if (results['status'] == true) {
        _status = true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("sales_name",name.text);
        prefs.setString("sales_lname",lname.text);
        prefs.setString("sales_mobile",phone.text);
        prefs.setString("sales_username",uname.text);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SalesProfilePage()), (Route<dynamic> route) => false);
      } else {
        print('error in updating profile');
        Alerts.showAlertAndBack(context, 'Error', 'Profile not Updated. Please try again later');
      }
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }

  }

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

  getLoginUpdated() async{
      if(passNew.text.isNotEmpty){
        password = md5.convert(utf8.encode(passNew.text)).toString();
      } else{
        password = passwordOld;
      }
      print(password);
      if (_formkey1.currentState.validate()) {
        _formkey1.currentState.save();
        ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
          isDismissible: false,);
        pr.style(message: 'Please wait...',
          progressWidget: Center(child: CircularProgressIndicator()),);
        pr.show();
        var response = await http.post(Uri.parse(ConnectionSales.changePass), body: {

          'secretkey': ConnectionSales.secretKey,
          'salesid':id,
          'email': email.text,
          'password': password,
        });
        var results = json.decode(response.body);
        print('response == $results  ${response.body}');
        pr.hide();
        if (results['status'] == true) {
          _status = true;
          Alerts.showSalesLogOut(context, "Password Successfully Changed", "Login to Access");
        } else {
          print('error in updating profile');
          Alerts.showAlertAndBack(context, 'Error', 'Login details not Updated. Please try again later');
        }
      } else {
        setState(() {
          _autovalidateMode1 = AutovalidateMode.always;
        });
      }
  }

}
