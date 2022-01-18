import 'dart:convert';
import 'package:desire_production/pages/dashboards/admin_dashboard_page.dart';
import 'package:desire_production/pages/dashboards/dashboard_page_admin.dart';
import 'package:desire_production/utils/default_button.dart';
import 'package:desire_production/utils/keyboard_util.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:http/http.dart' as http;
import 'package:desire_production/model/user_model.dart';
import 'package:desire_production/pages/dashboards/production_dashboard_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboards/dashboard_page_warhouse.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with Validator{

  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode  = AutovalidateMode.disabled;
  TextEditingController email, pass;
  bool remember = false;
  bool obscure = true;

  String adminRoleId = "1";
  String productionRoleId = "4";
  String wareHouseRoleId = "5";

  @override
  void initState() {
    super.initState();
    getPreferences();
    email = TextEditingController();
    pass = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    pass.dispose();
  }

  String smsCode;

  String _id;
  String value = "";

  //ef14217d-0c53-4a1d-a33e-3cdbcf4e02fe
  _initOneSignal() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.setAppId("ef14217d-0c53-4a1d-a33e-3cdbcf4e02fe");
// The promptForPushNotificationsWithUserResponse function will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
    //OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    //await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Setting OneSignal External User Id
    if (_id != '') {
      OneSignal.shared.setExternalUserId(_id);
    } else if(prefs.getString("id") != null){
      OneSignal.shared.setExternalUserId(prefs.getString("id"));
    }

    OneSignal.shared.setNotificationOpenedHandler((openedResult) async {
      print("clicked happen in login page");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => LoginPage()), (route) => false);

    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
      this.setState(() {
            value = "Received notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
          });
    });

    // OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
    //   this.setState(() {
    //     value = "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    //   });
    // });
  }


  getPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(prefs.getString("id") != null){
      if(prefs.getBool('remember')){
        setState(() {
          email = TextEditingController(text: prefs.getString("email"));
          pass = TextEditingController(text: prefs.getString("show_password"));
          remember = true;
        });
      }
    }

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Alerts.showExit(context, "Exit", "Are you sure?");
      },
      child: Scaffold(
        body: _body(),
      ),
    );
  }

  Widget _body(){
    return Center(
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding:
            EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset("assets/images/logo_new.png",height: 120,width: 120,),
                  SizedBox(height: 10),
                  Text(
                    "Welcome to Desire Moulding",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:kPrimaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Sign in with your email Id and password.",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  _signInForm(),
                  SizedBox(height: 20),
                ],
              ),
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
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: 20),
          buildPasswordFormField(),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 10.0,right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      child: Checkbox(
                        value: remember,
                        activeColor: kPrimaryColor,
                        onChanged: (value) {
                          setState(() {
                            remember = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text("Remember me",style: TextStyle(fontSize: 14),),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Alerts.showEmailPopup(context);
                  },
                  child: Text(
                    "Forgot Password ?",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          DefaultButton(
            text: "Login",
            press: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                KeyboardUtil.hideKeyboard(context);
                login();
              }
            },
          ),
        ],
      ),
    );
  }


  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: obscure,
      controller: pass,
      validator: validateRequired,
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.password,color: kPrimaryColor,),
          suffixIcon: obscure == true ? GestureDetector(
            child: Icon(Icons.visibility,color: kPrimaryColor,),
            onTap: (){
              setState(() {
                obscure = false;
              });
            },
          ): GestureDetector(
            child: Icon(Icons.visibility_off,color: kPrimaryColor,),
            onTap: (){
              setState(() {
                obscure = true;
              });
            },
          ),
          hintStyle: TextStyle(fontSize: 12),
          labelStyle: TextStyle(fontSize: 14,color: kPrimaryColor),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                  color: kSecondaryColor
              )
          ), focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
              color: kPrimaryColor
          )
      )
      ),
    );
  }
  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      controller: email,
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(Icons.email,color: kPrimaryColor,),
        hintStyle: TextStyle(fontSize: 12),
        labelStyle: TextStyle(fontSize: 14,color: kPrimaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: kSecondaryColor
          )
        ), focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: kPrimaryColor
          )
        )

      ),
    );
  }

  login() async{
    print("remember value $remember");
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator(
          color: kPrimaryColor,
        )),);
      pr.show();
      var response = await http.post(Uri.parse(Connection.login), body: {
        'emailid':email.text,
        'password':pass.text,
        'secretkey':Connection.secretKey
      });
      print("object ${response.body}");

      var results = json.decode(response.body);
      print("object $results");
      pr.hide();
      if (results['status'] == true) {
        print("user details ${results['data']}");

        UserModel userModel = UserModel.fromJson(results);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('id', userModel.user[0].userId);
        preferences.setString('role_id', userModel.user[0].roleId);
        preferences.setString('dept_id', userModel.user[0].departmentId);
        preferences.setString('fname', userModel.user[0].firstname);
        preferences.setString('lname', userModel.user[0].lastname);
        preferences.setString('email', userModel.user[0].email);
        preferences.setString('mobile', userModel.user[0].userMobile);
        preferences.setString('username', userModel.user[0].username);
        preferences.setString('password', userModel.user[0].password);
        preferences.setString('show_password', pass.text);
        preferences.setString('gender', userModel.user[0].gender);
        preferences.setString('address', userModel.user[0].address);
        preferences.setString('city', userModel.user[0].city);
        preferences.setString('State', userModel.user[0].state);
        preferences.setString('pincode', userModel.user[0].pincode);
        preferences.setString('active', userModel.user[0].isActive);
        preferences.setBool('remember', remember);

        _id = userModel.user[0].userId;

        _initOneSignal();
        if(userModel.user[0].roleId == adminRoleId){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => AdminDashboardPage()), (route) => false);
        }
        else if(userModel.user[0].roleId == productionRoleId){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => DashboardPageProduction(page: 'production',)), (route) => false);
        }
        else if(userModel.user[0].roleId == wareHouseRoleId){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => DashboardPageWarehouse(page: "warHouse",)), (route) => false);
        }


      } else if(results['message'] == "Email and Password Wrong Enter"){
        Alerts.showAlertAndBack(context, "Login Failed", "Incorrect UserName or Password");
      }
      else  {
        Alerts.showAlertAndBack(context, "Login Failed", "Incorrect UserName or Password");
      }
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }



}
