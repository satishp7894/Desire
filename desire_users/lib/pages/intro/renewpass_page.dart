import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/pages/intro/new_login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:desire_users/components/custom_surfix_icon.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/progress_dialog.dart';
import 'package:desire_users/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RenewPasswordPage extends StatefulWidget {
  @override
  _RenewPasswordPageState createState() => _RenewPasswordPageState();
}

class _RenewPasswordPageState extends State<RenewPasswordPage> with Validator{

  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  static TextEditingController pass,conpass;
  bool error = false;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    pass = TextEditingController();
    conpass = TextEditingController();
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
    pass.dispose();
    conpass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Align(
              alignment: Alignment.center,
              child: _body())
      ),
    );
  }

  Widget _body() {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/renew.png",height: 100,width: 100,),
            SizedBox(height: 10), // 4%
            Text("Reset Password", style: headingStyle),
            SizedBox(height: 10,),
            Text(
              "Reset your password and sign in",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: _passRenew(),
            ),
          ],
        ),
      ),
    );
  }

  bool obscure = true;

  Widget _passRenew(){
    return Form(
      autovalidateMode: _autovalidateMode,
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          TextFormField(
            obscureText: true,
            cursorColor: kBlackColor,
            controller: pass,
            validator: validateRequired,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.lock,
                  color: kPrimaryColor,
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
          ),
          SizedBox(height: 20.0),
          TextFormField(
            obscureText: obscure,
            cursorColor: kBlackColor,
            controller: conpass,
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
                hintText: "Re-Enter  your Password",
                labelText: "Confirm Password",
                labelStyle: TextStyle(color: kPrimaryColor),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor)),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor))),
          ),
          SizedBox(height: 20.0),
          CupertinoButton(
            color: kPrimaryColor,
              child: Text("Submit"),
              onPressed: () {
                changePass();
              }
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  changePass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("object submit pressed give user_id new password ${pass.text} ${prefs.getString("customer_id")}");
    if (_formKey.currentState.validate()&& pass.text == conpass.text) {
      _formKey.currentState.save();
      ProgressDialog pr = ProgressDialog(
        context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator(
          color: kPrimaryColor,
        )),);
      pr.show();
      pr.hide();
      var response = await http.post(Uri.parse(Connection.forgetPassword), body: {
        'user_id': prefs.getString("customer_id"),
        'newpassword': pass.text,
        'secretkey': Connection.secretKey
      });
      var results = json.decode(response.body);
      pr.hide();
      if (results['status'] == true) {
        print("pass details ${results['data']}");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => NewLoginPage()), (Route<dynamic> route) => false);
      } else {
        Alerts.showAlertAndBack(
            context, "Password Renew Failed", "Something went wrong please try later.");
      }
     }
    else if(pass.text != conpass.text){
      final snackBar =
      SnackBar(content: Text("Password does not match"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

}
