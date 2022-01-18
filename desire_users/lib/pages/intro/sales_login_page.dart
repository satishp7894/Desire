import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/pages/intro/new_login_page.dart';
import 'package:desire_users/sales/pages/profile/sales_forgot_password_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:desire_users/models/sales_model.dart';
import 'package:desire_users/sales/pages/sales_home_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/sales/utils_sales/custom_surfix_icon.dart';
import 'package:desire_users/sales/utils_sales/default_button.dart';
import 'package:desire_users/sales/utils_sales/keyboard_util.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/sales/utils_sales/validator.dart';

import 'package:desire_users/services/connection_sales.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SalesLoginPage extends StatefulWidget {
  @override
  _SalesLoginPageState createState() => _SalesLoginPageState();
}

class _SalesLoginPageState extends State<SalesLoginPage> with Validator{

  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode  = AutovalidateMode.disabled;
  TextEditingController email, pass;
  bool remember = false;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    getPreferences();
    email = TextEditingController();
    pass = TextEditingController();
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
    email.dispose();
    pass.dispose();
  }


  getPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString("sales_id") != null){
      if(prefs.getBool('sales_remember')){
        setState(() {
          email = TextEditingController(text: prefs.getString("sales_email"));
          pass = TextEditingController(text: prefs.getString("sales_show_password"));
          // name.text = prefs.getString("User_name");
          // pass.text = prefs.getString("show_password");
          remember = true;
        });
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Alerts.showExit(
            context, "Exit", "Are you sure you want to exit from app?");
      },
      child: SafeArea(
        child: Scaffold(
          body: _body(),
        ),
      ),
    );
  }

  Widget _body(){
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset("assets/images/logo_new.png",height: 80,),
                SizedBox(height: 10),
                Text(
                  "Welcome to Desire Moulding",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  "Sign in with your Sales Email-Id and Password.",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _signInForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInForm(){
    return Form(
      autovalidateMode: _autoValidateMode,
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          buildEmailFormField(),
          SizedBox(height: 15),
          buildPasswordFormField(),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                      ),
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      value: remember ? true : false,
                      onChanged: (v) {
                        setState(() {
                          remember = v;
                        });
                      },
                      activeColor: kPrimaryColor,
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    "Remember me",
                    textAlign: TextAlign.left,

                    style: TextStyle(color: kSecondaryColor,fontSize: 14),
                  ),
                ],
              ),
              GestureDetector(
                  onTap: () {
                  // Alerts.showEmailPopup(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesForgotPasswordPage()));
                  },
                  child: Text(
                    "Forgot Password ?",
                    style: TextStyle(
                        color: kPrimaryColor,
                        decoration: TextDecoration.underline,
                        decorationColor: kPrimaryColor),
                  ))
            ],
          ),
          SizedBox(height: 20),
          CupertinoButton(
            child: Text( "Login",),
            color: kPrimaryColor,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // if all are valid then go to success screen
                KeyboardUtil.hideKeyboard(context);
                login();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Are you a customer ? ",
                    style: TextStyle(color: kSecondaryColor, fontSize: 14)),
                GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => NewLoginPage()));
                    },
                    child: Text(
                      "Login here",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }


  bool obscure = true;

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: obscure,
      cursorColor: kBlackColor,
      controller: pass,
      validator: validateRequired,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
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
          hintText: "Enter Password",
          labelText: "Password",
          labelStyle: TextStyle(color: kPrimaryColor),
          hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor))),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      cursorColor: kBlackColor,
      controller: email,
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: kPrimaryColor,
          ),
          hintText: "Enter Email Address",
          hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
          labelText: "Email",
          labelStyle: TextStyle(color: kPrimaryColor),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: kPrimaryColor))),
    );
  }

  login() async{
    print("remember value $remember");
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait we are logging in',
        progressWidget: CircularProgressIndicator(
          color: kPrimaryColor,
        ),);
      pr.show();
      var response = await http.post(Uri.parse(ConnectionSales.login), body: {
        'emailid':email.text,
        'password':pass.text,
        'secretkey':ConnectionSales.secretKey
      });
      print("object ${response.body}");

      var results = json.decode(response.body);
      print("object $results");
      pr.hide();
      if (results['status'] == true) {
        print("user details ${results['data']}");
        print("user id ${results['data'][0]['user_id']}");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SalesHomePage(
          salesManId: results['data'][0]['user_id'],
        )), (route) => false);

        SalesModel salesModel = SalesModel.fromJson(results);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('sales_id', salesModel.sales[0].userId);
        preferences.setString('role_id', salesModel.sales[0].roleId);
        preferences.setString('dept_id', salesModel.sales[0].departmentId);
        preferences.setString('sales_name', salesModel.sales[0].firstname);
        preferences.setString('sales_lname', salesModel.sales[0].lastname);
        preferences.setString('sales_email', salesModel.sales[0].email);
        preferences.setString('sales_mobile', salesModel.sales[0].userMobile);
        preferences.setString('sales_username', salesModel.sales[0].username);
        preferences.setString('sales_password', salesModel.sales[0].password);
        preferences.setString('sales_gender', salesModel.sales[0].gender);
        preferences.setString('sales_address', salesModel.sales[0].address);
        preferences.setString('sales_city', salesModel.sales[0].city);
        preferences.setString('sales_State', salesModel.sales[0].state);
        preferences.setString('sales_pincode', salesModel.sales[0].pincode);
        preferences.setString('sales_active', salesModel.sales[0].isActive);
        preferences.setBool('sales_remember', remember);
        preferences.setString('sales_show_password', pass.text);
        preferences.setString('login', 'sales');

      } else {
        Alerts.showAlertAndBack(context, "Login Failed", "Incorrect EmailId or Password");
      }
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }

}
