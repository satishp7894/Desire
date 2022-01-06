import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/models/user_model.dart';
import 'package:desire_users/pages/intro/select_card_type.dart';
import 'package:desire_users/pages/intro/verify_kyc_screen_old.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/progress_dialog.dart';
import 'package:desire_users/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/custom_surfix_icon.dart';
import '../../components/default_button.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;


class SignUpPage extends StatefulWidget {

  final String mail;
  final String name;
  final String mobile;

  const SignUpPage({this.mail, this.name, this.mobile});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with Validator{

  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  bool remember = false;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  TextEditingController name, user, mail, mob, pass, pin, state, city,address, areaN, company;
  
  String value = "";

  bool checkBoxValue = false;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    company = TextEditingController();
    name = TextEditingController();
    user = TextEditingController();
    mail = TextEditingController();
    mob = TextEditingController();
    pass = TextEditingController();
    pin = TextEditingController();
    state = TextEditingController();
    city = TextEditingController();
    address = TextEditingController();
    areaN = TextEditingController();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
    });
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
    company.dispose();
    name.dispose();
    user.dispose();
    mail.dispose();
    mob.dispose();
    pass.dispose();
    pin.dispose();
    state.dispose();
    city.dispose();
    address.dispose();
    areaN.dispose();
    _focusNode.dispose();
  }

   bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0.0,
        actions: [
          Container(
            height: 30,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton.extended(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0.0,
                onPressed: (){
                  signUp();

              },
              icon: Icon(Icons.how_to_reg,color: kWhiteColor,),
                label: Text("Register",style: TextStyle(fontSize: 14,color: kWhiteColor),),
              ),
            ),
          ),
          SizedBox(width: 10,)
        ],
      ),
      body: _body(),
      bottomNavigationBar: bottomView(),
    );
  }


  Widget _body() {
    return SingleChildScrollView(
      child: SafeArea(
        child: _signUpForm(),
      ),
    );
  }

  Widget _signUpForm(){
    if(widget.mail != null && widget.name != null){
      setState(() {
        name.text = widget.name;
        mail.text = widget.mail;
      });
    }
    if(widget.mobile != null){
      setState(() {
        mob.text = widget.mobile;
      });
    }
    return Form(
      autovalidateMode: _autoValidateMode,
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 10,bottom: 10),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0,bottom: 10),
              child: Image.asset(
                "assets/images/logo.png",
                height: 80,
                width: 80,
              ),
            ),

            Text(
              "Welcome to Desire Moulding",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              cursorColor: kBlackColor,
              textInputAction: TextInputAction.next,
              controller: company,
              validator: validateName,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.name,
              scrollPadding: EdgeInsets.zero,
              decoration: InputDecoration(
                labelText: "Company Name",
                hintText: "Enter your Company Name",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(
                  Icons.apartment,
                  color: kPrimaryColor,
                ),
                border:  OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                labelStyle: TextStyle(color: kPrimaryColor),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              cursorColor: kBlackColor,
              textInputAction: TextInputAction.next,
              controller: name,
              readOnly: widget.name == null ? false : true,
              validator: validateRequired,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.name,
              scrollPadding: EdgeInsets.zero,
              decoration: InputDecoration(
                labelText: "Name",
                hintText: "Enter your Full Name",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(
                  Icons.person
                  ,
                  color: kPrimaryColor,
                ),
                border:  OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                labelStyle: TextStyle(color: kPrimaryColor),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              cursorColor: kBlackColor,
              textInputAction: TextInputAction.next,
              controller: user,
              validator: validateName,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.name,
              scrollPadding: EdgeInsets.zero,
              decoration: InputDecoration(
                labelText: "Username",
                hintText: "Enter your Username",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(
                  Icons.person
                  ,
                  color: kPrimaryColor,
                ),
                border:  OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                labelStyle: TextStyle(color: kPrimaryColor),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              cursorColor: kBlackColor,
              textInputAction: TextInputAction.next,
              controller: mail,
              readOnly: widget.mail == null ? false : true,
              validator: validateEmail,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.emailAddress,
              scrollPadding: EdgeInsets.zero,
              decoration: InputDecoration(
                labelText: "Email Id",
                hintText: "Enter your Email-Id",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(
                  Icons.email
                  ,
                  color: kPrimaryColor,
                ),
                border:  OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                labelStyle: TextStyle(color: kPrimaryColor),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              cursorColor: kBlackColor,
              textInputAction: TextInputAction.next,
              controller: mob,
              readOnly: widget.mobile ==null ? false : true,
              validator: validateMobile,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.phone,
              scrollPadding: EdgeInsets.zero,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                hintText: "Enter your Mobile",
                labelText: "Mobile",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(
                  Icons.phone_android
                  ,
                  color: kPrimaryColor,
                ),
                border:  OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                labelStyle: TextStyle(color: kPrimaryColor),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              cursorColor: kBlackColor,
              textInputAction: TextInputAction.next,
              controller: pass,
              validator: validateRequired,
              textAlign: TextAlign.left,
              obscureText: obscure,
              keyboardType: TextInputType.visiblePassword,
              scrollPadding: EdgeInsets.zero,
              decoration: InputDecoration(
                hintText: "Enter Password",
                labelText: "Password",
                suffixIcon: GestureDetector(
                  onTap: (){
                    setState(() {
                      obscure = false;
                    });
                  },
                  child: obscure ==  true ? Icon(Icons.visibility_off,size: 25,color: kPrimaryColor,)
                      : GestureDetector(child: Icon(Icons.visibility,size: 25,color: kPrimaryColor,),
                    onTap: (){
                      setState(() {
                        obscure = true;
                      });
                    },
                  ),

                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(
                  Icons.password
                  ,
                  color: kPrimaryColor,
                ),
                border:  OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                labelStyle: TextStyle(color: kPrimaryColor),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              cursorColor: kBlackColor,
              textInputAction: TextInputAction.next,
              controller: address,
              validator: validateRequired,
              textAlign: TextAlign.left,
              keyboardType: TextInputType.streetAddress,
              scrollPadding: EdgeInsets.zero,
              decoration: InputDecoration(
                hintText: "Flat/House/Shop No.",
                labelText: "Address",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(
                  Icons.location_on
                  ,
                  color: kPrimaryColor,
                ),
                border:  OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                labelStyle: TextStyle(color: kPrimaryColor),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              cursorColor: kBlackColor,
              textInputAction: TextInputAction.next,
              controller: areaN,
              validator: validateRequired,
              textAlign: TextAlign.left,
              scrollPadding: EdgeInsets.zero,
              //readOnly: true,
              decoration: InputDecoration(
                labelText: "Area",
                hintText: "Enter Area",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(
                  Icons.location_on
                  ,
                  color: kPrimaryColor,
                ),
                border:  OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                labelStyle: TextStyle(color: kPrimaryColor),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              cursorColor: kBlackColor,
              textInputAction: TextInputAction.next,
              controller: city,
              validator: validateRequired,
              textAlign: TextAlign.left,
              scrollPadding: EdgeInsets.zero,
              //readOnly: true,
              decoration: InputDecoration(
                labelText: "City",
                hintText: "Enter City",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(
                  Icons.location_on
                  ,
                  color: kPrimaryColor,
                ),
                border:  OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                labelStyle: TextStyle(color: kPrimaryColor),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
              ),
            ),
            SizedBox(height: 10.0),
            Focus(
              onFocusChange: (v){
                print("object focus changed response $v");
                if(v == false){
                  if (pin.text.length == 6) {
                    getOtherAttributes(pin.text);
                  } else {
                    Alerts.showAlertAndBack(context, "Incorrect Pin-code", "Enter a valid Pin-code");
                  }
                }
              },
              child: TextFormField(
                cursorColor: kBlackColor,
                focusNode: _focusNode,
                textInputAction: TextInputAction.done,
                controller: pin,
                validator: validatePinCode,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                decoration: InputDecoration(
                  labelText: "PinCode",
                  hintText: "Enter PinCode",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Icon(
                    Icons.location_on
                    ,
                    color: kPrimaryColor,
                  ),
                  border:  OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                  focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                  labelStyle: TextStyle(color: kPrimaryColor),
                  hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              textInputAction: TextInputAction.done,
              controller: state,
              readOnly: true,
              validator: validateRequired,
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                labelText: "State",
                hintText: "Enter State",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(
                  Icons.location_on
                  ,
                  color: kPrimaryColor,
                ),
                border:  OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                labelStyle: TextStyle(color: kPrimaryColor),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  Widget bottomView() {
    return SafeArea(
      bottom: true,
      child: Container(
        height: 60.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Privacy Policy | Terms of Service",
                style: TextStyle(color: kPrimaryColor,fontSize: 12)),
            SizedBox(
              height: 5,
            ),
            Text("Copyright © 2021 Desire Moulding. All Rights Reserved",
                style: TextStyle(color: kPrimaryColor,fontSize: 12)),
          ],
        ),
      ),
    );
  }
  getOtherAttributes(String pin) async{
    print("object pin $pin");
    if(pin.isEmpty || pin.length > 6){
      Alerts.showAlertAndBack(context, "Invalid Value", "Please Enter 6 digit Pin code");
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

        setState(() {
          //city = TextEditingController(text: cityN);
          state = TextEditingController(text: stateN);
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
  signUp() async{
    print("value from form ${name.text} ${mail.text} ${mob.text}"
        "${user.text} ${pass.text} ${address.text} ${pin.text}"
        "${state.text} ${city.text} ${areaN.text}");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: true,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();

    var response = await http.post(Uri.parse(Connection.signUp), body: {
      "companyname":"${company.text}",
      "customername":"${name.text}",
      "email":"${mail.text}",
      "mobile":"${mob.text}",
      "username":"${user.text}",
      "password":"${pass.text}",
      "address":"${address.text}",
      "state":"${state.text}",
      "city":"${city.text}",
      "area":"${areaN.text}",
      "pincode":"${pin.text}",
      "secretkey":"12!@34#\$5%"
    });
      print('results: $response');

    var result = json.decode(response.body);

    print('results: $result');

    pr.hide();

    if(result['status'] == true){
      UserModel userModel = UserModel.fromJson(result['data'][0]);
      print("model value ${userModel.customerId}");
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('company_name', userModel.companyName);
      preferences.setString('customer_id', userModel.customerId);
      preferences.setString('Customer_name', userModel.customerName);
      preferences.setString('Email', userModel.email);
      preferences.setString('Mobile_no', userModel.mobileNo);
      preferences.setString('User_name', userModel.userName);
      preferences.setString('show_password', userModel.showPassword);
      preferences.setString('address', userModel.address);
      preferences.setString('area', userModel.area);
      preferences.setString('City', userModel.city);
      preferences.setString('State', userModel.state);
      preferences.setString("kycStats", userModel.kycStatus);
      preferences.setString('Pincode', userModel.pincode);

      // setState(() {
      //   _id = userModel.customerId;
      //   _initOneSignal();
      // });

      //Alerts.showAlertAndBack(context, "Success", "SignUp");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SelectCardType(userId: userModel.customerId)));
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => OtpPage(page: "login", mob: userModel.mobileNo, remember:  false,)));
      return true;
    }
    if(result['message'] == "Email,Mobile and Username allready exists"){
      Alerts.showAlertAndBack(context, 'Error SignUp', 'Username,Email or Mobile Number already exist.');
    }
    else {
      Alerts.showAlertAndBack(context, 'Error SignUP', 'Try again later');
      return false;
    }
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }

  }
// List<String> areaWise = ['Please Select your Area'];
//
// getOtherAttributes(String pin) async{
//   print("object pin $pin");
//   if(pin.isEmpty || pin.length > 6){
//     Alerts.showAlertAndBack(context, "Invalid Value", "Please Enter 6 digit Pincode");
//   } else {
//     ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
//       isDismissible: false,);
//     pr.style(message: 'Please wait...',
//       progressWidget: Center(child: CircularProgressIndicator()),);
//     pr.show();
//     var response = await http.get(Uri.parse(Connection.getAttributes+"$pin"));
//     var result = json.decode(response.body);
//
//     if(result[0]["Message"] == "No records found"){
//       pr.hide();
//       Alerts.showAlertAndBack(context, "Incorrect PinCode", "Enter a valid Pincode");
//     } else{
//
//       //String cityN = result[0]["PostOffice"][0]["Division"];
//       String stateN = result[0]["PostOffice"][0]["State"];
//
//       setState(() {
//         //city = TextEditingController(text: cityN);
//         state = TextEditingController(text: stateN);
//         for(int i=0; i<result[0]["PostOffice"].length; i++){
//           print("value for areas ${result[0]["PostOffice"][i]["Name"]}");
//           areaWise.add("${result[0]["PostOffice"][i]["Name"]}");
//         }
//       });
//       pr.hide();
//
//     }
//
//
//     print("object value for the region ${result[0]["Message"]} ${result[0]["PostOffice"][0]["Region"]}");
//     //pr.hide();
//   }
// }

// _initOneSignal() async {
//   // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
//   await OneSignal.shared.init("37cabe91-f449-48f2-86ad-445ae883ad77");
//
//   OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
//   //await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   // Setting OneSignal External User Id
//   if (_id != '') {
//     OneSignal.shared.setExternalUserId(_id);
//   } else if(prefs.getString("customer_id") != null){
//     OneSignal.shared.setExternalUserId(prefs.getString("customer_id"));
//   }
//
//
//
//
//   OneSignal.shared.setNotificationOpenedHandler((openedResult) async {
//     print("clicked happen in login page");
//
//     print("object openresult $_id ${openedResult.notification.payload.title} ${prefs.getString("customer_id")}");
//     if(openedResult.notification.payload.title == "Account Has Been Blocked"){
//       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => BlockedPage(mob: prefs.getString("Mobile_no"),)), (route) => false);
//     } else if(openedResult.notification.payload.title == "Order Update Successfully" || openedResult.notification.payload.title == "Add Order Successfully Details"){
//       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => OrderHistoryPage(status: false, id: prefs.getString("customer_id"),orderCount:0)), (route) => false);
//
//     } else {
//       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomePage(status: false)), (route) => false);
//     }
//   });
//
//   OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
//     this.setState(() {
//       value = "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
//     });
//   });
//
// }
}