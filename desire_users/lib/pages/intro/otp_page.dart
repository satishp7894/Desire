import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/pages/cart/order_history_page.dart';
import 'package:desire_users/pages/home/home_page.dart';
import 'package:desire_users/pages/intro/new_login_page.dart';
import 'package:desire_users/pages/intro/signup_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:desire_users/models/user_model.dart';
import 'package:desire_users/pages/intro/block_page.dart';
import 'package:desire_users/sales/utils_sales/validator.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'kyc_pagen.dart';
import 'renewpass_page.dart';
import 'success_page.dart';

class OtpPage extends StatefulWidget {

  final String page;
  final String mob;
  final bool remember;
  final String mail;
  final String name;


  OtpPage({@required this.page, @required this.mob, @required this.remember, this.mail, this.name});

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with Validator{

  TextEditingController _otpController;
  String otp;
  var count;
  String _id;
  String value = "";
  String _verificationCode;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    _otpController = TextEditingController();
    _verifyPhoneFirebase();
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
    _otpController.dispose();
  }
  _initOneSignal() async {
    // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.setAppId("37cabe91-f449-48f2-86ad-445ae883ad77");

  //  OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    //await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Setting OneSignal External User Id
    if (_id != '') {
      OneSignal.shared.setExternalUserId(_id);
    } else if(prefs.getString("customer_id") != null){
      OneSignal.shared.setExternalUserId(prefs.getString("customer_id"));
    }

    print("object  $_id");
    OneSignal.shared.setNotificationOpenedHandler((openedResult) async {
      print("clicked happen in otp page");
      print("object open result $_id ${openedResult.notification.title} ${prefs.getString("customer_id")}");
      if(openedResult.notification.title == "Account Has Been Blocked"){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => BlockedPage(mob: prefs.getString("Mobile_no"),)), (route) => false);
      } else if(openedResult.notification.title == "Order Update Successfully" || openedResult.notification.title == "Add Order Successfully Details"){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => OrderHistoryPage(status: false, customerId: prefs.getString("customer_id"),orderCount:0)), (route) => false);

      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomePage(status: true)), (route) => false);
      }    });

    OneSignal.shared
        .setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: $event');
      /// Display Notification, send null to not display
      event.complete(null);

      this.setState(() {
        value =
        "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: kPrimaryColor
          ),
          actions: [
            IconButton(onPressed: (){
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => NewLoginPage()));
            }, icon: Icon(Icons.login,size: 30,color: kPrimaryColor,))
          ],
        ),
        body: Container(
          color: Colors.grey.shade200,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("assets/images/password.png",height: 80,width: 80,color: kPrimaryColor,),
                SizedBox(height: 30),
                Text(
                  "OTP Verification",
                  style: headingStyle,
                ),
                SizedBox(height: 20,),
                Text("We sent your code to ${widget.mob.replaceRange(0, 6, "******")}"),
                //.replaceRange(0, 6, "******")
                SizedBox(height: 10,),
                buildTimer(),
                count == 0.0 ? TextButton(
                  child: Text("Resend OTP Code", style: TextStyle(decoration: TextDecoration.underline, color: kPrimaryColor,fontSize: 15),),
                  onPressed: (){
                    _verifyPhoneFirebase();
                  },
                ) : Container(),
                SizedBox(height: 20,),
                Column(
                  children:[
                    PinCodeTextField(
                      controller: _otpController,
                      highlightColor: Colors.white,
                      highlightAnimation: true,
                      highlightAnimationBeginColor: Colors.white,
                      highlightAnimationEndColor: Theme.of(context).primaryColor,
                      pinTextAnimatedSwitcherDuration: Duration(milliseconds: 500),
                      wrapAlignment: WrapAlignment.center,
                      hasTextBorderColor: kPrimaryColor,
                      highlightPinBoxColor: Colors.white,
                      autofocus: true,
                      pinBoxHeight: 40,
                      pinBoxWidth: 40,
                      pinBoxRadius: 5,
                      defaultBorderColor: Colors.transparent,
                      pinBoxColor: Color.fromRGBO(255, 255, 255, 0.8),
                      maxLength: 6,
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            primary: kPrimaryColor,
                            backgroundColor: kPrimaryColor
                        ),
                        onPressed: () async{
                          setState(() {
                            otp = _otpController.text.trim();
                          });

                          if(otp == null || otp.length<6){
                            final snackBar = SnackBar(content: Text('Please Enter OTP sent on your registered number'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          } else{
                            try {
                              await FirebaseAuth.instance
                                  .signInWithCredential(PhoneAuthProvider.credential(
                                  verificationId: _verificationCode, smsCode: _otpController.text))
                                  .then((value) async {
                                if (value.user != null) {
                                  _initOneSignal();
                                  widget.page == "login" ? getLoginDetails() : widget.page == "signup"  ?getSignUpPage(): getDetails() ;
                                }
                              });
                            } catch (e) {
                              FocusScope.of(context).unfocus();
                              final snackBar = SnackBar(content: Text('Invalid OTP'));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          }

                        },
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expire in "),
        TweenAnimationBuilder(
            tween: Tween(begin: 60, end: 0.0),
            duration: Duration(seconds: 60),
            builder: (_, value, child) {
              print("object value for count $value");
              count = value;
              return Text(
                "0:${value.toInt()}",
                style: TextStyle(color: kPrimaryColor),
              );
            }
        ),
      ],
    );
  }

  _verifyPhoneFirebase() async {
    print("object mobile number ${widget.mob}");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.mob}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              _initOneSignal();
              getDetails();
              widget.page == "login" ? getLoginDetails() : getDetails();
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationID, int resendToken) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            if (mounted) {
              setState(() {
                _verificationCode = verificationID;
              });
            }
          });
        },
        timeout: Duration(seconds: 120));
  }



  getLoginDetails() async{
    print("remember value ${widget.remember}");
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();
      var response = await http.post(Uri.parse(Connection.mobileCheck), body: {
        'secretkey':Connection.secretKey,
        'mobile' : widget.mob
      });
      var results = json.decode(response.body);
      pr.hide();
      if (results['status'] == true) {
        print("user details ${results['data'][0]}");

        UserModel userModel = UserModel.fromJson(results['data'][0]);
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
        preferences.setString('Pincode', userModel.pincode);
        preferences.setBool('remember', widget.remember);
        preferences.setString("kyc", userModel.kycApprove);
        preferences.setString('login', 'user');

        setState(() {
          _id = userModel.customerId;
          _initOneSignal();
        });

        userModel.kycStatus == "0" ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => KYCPageN(userId: userModel.customerId,)), (Route<dynamic> route) => false) :
        userModel.kycApprove == "1" ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(status: true,customerEmail: userModel.email,mobileNo: userModel.mobileNo,customerName: userModel.customerName,customerId: userModel.customerId,)), (Route<dynamic> route) => false) : Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SuccessPage(userId: userModel.customerId)), (Route<dynamic> route) => false) ;
      } else if (results['status'] == false && results['message'] == "Customer Not active, Please Contact to Admin Department.") {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BlockedPage(mob: widget.mob, )), (route) => false);
      } else {
        Alerts.showAlertAndBack(context, 'Login Failed', 'Failed to login through mobile. Please try again later.');
      }
  }

  getDetails() async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator(
        color: kPrimaryColor,
      )),);
    pr.show();
    var response = await http.post(Uri.parse(Connection.mobileCheck), body: {
      'secretkey':Connection.secretKey,
      'mobile' : widget.mob
    });
    var results = json.decode(response.body);
    pr.hide();
    if (results['status'] == true) {
      print("user details ${results['data'][0]}");

      UserModel userModel = UserModel.fromJson(results['data'][0]);
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
      preferences.setString('Pincode', userModel.pincode);
      preferences.setBool('remember', widget.remember);
      preferences.setString("kyc", userModel.kycApprove);
      preferences.setString("kycStats", userModel.kycStatus);
      preferences.setString('login', 'user');

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => RenewPasswordPage()), (route) => false);
    }
    else if (results['status'] == false && results['message'] == "Mobile Number not register") {
      getSignUpPage();
    }

    else{
      Alerts.showAlertAndBack(context, 'Login Failed', 'Failed to login through mobile. Please try again later.');
    }
  }

  getSignUpPage() {
    widget.name == null ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SignUpPage(mobile: widget.mob,)), (route) => false) :
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SignUpPage(mail: widget.mail, name: widget.name, mobile: widget.mob,)), (route) => false);
  }

}
