import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/models/sales_customer_list_model.dart';
import 'package:desire_users/pages/cart/order_history_page.dart';
import 'package:desire_users/pages/chatting/chatting_page.dart';
import 'package:desire_users/pages/home/home_page.dart';
import 'package:desire_users/pages/intro/block_page.dart';
import 'package:desire_users/pages/intro/forgetpass_page.dart';
import 'package:desire_users/pages/intro/kyc_pagen.dart';
import 'package:desire_users/pages/intro/mobile_veriy_page.dart';
import 'package:desire_users/pages/intro/otp_page.dart';
import 'package:desire_users/pages/intro/sales_login_page.dart';
import 'package:desire_users/pages/intro/select_card_type.dart';
import 'package:desire_users/pages/intro/signup_page.dart';
import 'package:desire_users/pages/intro/success_page.dart';
import 'package:desire_users/pages/intro/verifyMobileNumberPage.dart';
import 'package:desire_users/pages/intro/verify_kyc_screen.dart';
import 'package:desire_users/pages/intro/verify_kyc_screen_old.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/sales/utils_sales/validator.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class NewLoginPage extends StatefulWidget with Validator{
  const NewLoginPage({Key key}) : super(key: key);

  @override
  _NewLoginPageState createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {
  //Controllers
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode1 = AutovalidateMode.disabled;

  //Variables
  bool validate = false;

  bool obscure = true;

  String smsCode;
  String _id;
  String value = "";

  @override
  void initState() {
    super.initState();
    googleSignIn.signOut();   
    checkConnectivity();
    _reqPer(Permission.storage);
    getPreferences();
  }

  Future<bool> _reqPer(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var res = await permission.request();

      // ignore: unrelated_type_equality_checks
      if (res == permission.isGranted) {
        return true;
      } else {
        return false;
      }
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
    userNameController.dispose();
    passwordController.dispose();
  }

  getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("customer_id") != null) {
      if (prefs.getBool('remember')) {
        setState(() {
          userNameController =
              TextEditingController(text: prefs.getString("Email"));
          passwordController =
              TextEditingController(text: prefs.getString("show_password"));
          // name.text = prefs.getString("User_name");
          // pass.text = prefs.getString("show_password");
          remember = true;
        });
      }
    }
  }

  String validateUsername(String value) {
    if (value.isEmpty) {
      return "Username is Required";
    }
    return null;
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return "Password is Required";
    }
    return null;
  }

  String validateMobile(String value) {
    String pattern = r'^(?:[+0]9)?[0-9]{10}$';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return "Mobile Number Required";
    }else if (!regExp.hasMatch(value)) {
      return "Invalid Mobile Number";
    } else {
      return null;
    }
  }

  String validateOtp(String value) {
    String pattern = r'^(?:[+0]9)?[0-9]{10}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return "Invalid Otp Number";
    } else {
      return null;
    }
  }

  _initOneSignal() async {
    // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
      await OneSignal.shared.setAppId("37cabe91-f449-48f2-86ad-445ae883ad77");
   // await OneSignal.shared.setAppId("37cabe91-f449-48f2-86ad-445ae883ad77");

   // OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    //await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Setting OneSignal External User Id
    if (_id != '') {
      OneSignal.shared.setExternalUserId(_id);
    } else if (prefs.getString("customer_id") != null) {
      OneSignal.shared.setExternalUserId(prefs.getString("customer_id"));
    }

    OneSignal.shared.setNotificationOpenedHandler((openedResult) async {
      print("clicked happen in login page");

      print(
          "object open Result $_id ${openedResult.notification.title} ${prefs.getString("customer_id")}");
      if (openedResult.notification.title ==
          "Account Has Been Blocked") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (c) => BlockedPage(mob: prefs.getString("Mobile_no"))),
            (route) => false);
      } else if (openedResult.notification.title ==
              "Order Update Successfully" ||
          openedResult.notification.title ==
              "Add Order Successfully Details") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (c) => OrderHistoryPage(
                    status: false,
                    customerId: prefs.getString("customer_id"),
                    orderCount: 0)),
            (route) => false);
      } else if (openedResult.notification.title ==
          "New Message - Admin") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (c) => ChattingPage(
                    customerId: prefs.getString("customer_id"),
                chatPersonName: prefs.getString("chatPersonName"),
                receiverId: prefs.getString("receiverId"),
                )),
                (route) => false);
      }
      
      else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => HomePage(status: true)),
            (route) => false);
      }
    });

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
    return WillPopScope(
      onWillPop: () {
        return Alerts.showExit(
            context, "Logout", "Are you sure you want to logout?");
      },
      child: SafeArea(
        child: Scaffold(
          body: Center(child: SizedBox(
              width: double.infinity,
              child: userLoginView())),
          bottomNavigationBar: bottomView(),
        ),
      ),
    );
  }

  bool remember = false;

  Widget bottomView() {
    return SafeArea(
      bottom: true,
      child: Container(
        height: 60,
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

  showMobileLogin() {
    return showModalBottomSheet<void>(
      backgroundColor: kWhiteColor,
      context: context,
      builder: (BuildContext context) {
        final PageController controller = PageController(initialPage: 0);
        return Container(
          child: Form(
            autovalidateMode: _autoValidateMode1,
            key: _formKey1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    autofocus: true,
                    cursorColor: kBlackColor,
                    textInputAction: TextInputAction.done,
                    controller: mobileController,
                    validator: validateMobile,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      labelText: "Registered Mobile No.",
                        hintText: "Enter your Registered Mobile No.",
                        prefixText: "+91- ",
                        prefixStyle: TextStyle(color: kBlackColor),
                        hintStyle: TextStyle(color: Colors.grey),
                        labelStyle: TextStyle(color: kPrimaryColor),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColor
                            )
                        )
                    ),
                  ),
                  SizedBox(height: 20.0),
                  CupertinoButton(
                    color: kPrimaryColor,
                    child: Text("Generate OTP"),
                    onPressed: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      if(_formKey1.currentState.validate()){
                        _formKey1.currentState.save();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => OtpPage(
                                  page: "login",
                                  mob: mobileController.text,
                                  remember: remember,
                                )));
                      }


                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget userLoginView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              Image.asset(
                "assets/images/logo_new.png",
                height: 80,
                width: 80,
              ),
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
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: TextFormField(
                  cursorColor: kBlackColor,
                  controller: userNameController,
                  keyboardType: TextInputType.name,
                  validator: validateUsername,
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone_android,
                        color: kPrimaryColor,
                      ),
                      hintText: "Enter your email",
                      hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
                      labelText: "Email",
                      labelStyle: TextStyle(color: kPrimaryColor),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child:  TextFormField(
                  obscureText: obscure,
                  cursorColor: kBlackColor,
                  controller: passwordController,
                  validator: validatePassword,
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0,bottom: 10),
                child: Row(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ForgetPassPage()));
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 14,
                              decoration: TextDecoration.none,
                              decorationColor: kPrimaryColor),
                        ))
                  ],
                ),
              ),
              CupertinoButton(
                child: Text("Login"),
                onPressed: () {
                  usernameLogin();
                },
                color: kPrimaryColor,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Don't have an account ? ",
                        style: TextStyle(color: kSecondaryColor, fontSize: 12)),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => SignUpPage()));
                        },
                        child: Text(
                          "Register here",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    Flexible(
                        child: Container(
                            width: 150,
                            height: 5,
                            child: Divider(
                              color: kSecondaryColor,
                              height: 0.0,
                              thickness: 1,
                            ))),
                    Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          "OR",
                          style: TextStyle( color: kSecondaryColor,
                              fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                    Flexible(
                        child: Container(
                            width: 150,
                            height: 5,
                            child: Divider(
                              color: kSecondaryColor,
                              height: 0.0,
                              thickness: 1,
                            ))),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        _googleAuth();
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kPrimaryColor)),
                          child: Center(
                              child: Image.asset(
                            "assets/images/google_logo.png",
                            height: 30,
                            width: 30,
                          )))),
                  SizedBox(
                    width: 40,
                  ),
                  GestureDetector(
                      onTap: showMobileLogin,
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kPrimaryColor)),
                          child: Center(
                              child: Image.asset(
                            "assets/images/mobile_logo.png",
                            height: 30,
                            width: 30,
                          )))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Not a customer ? ",
                        style: TextStyle(color: kSecondaryColor, fontSize: 12)),
                    GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => SalesLoginPage()));
                        },
                        child: Text(
                          "Sales Login",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 14,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  usernameLogin() async {
    print("remember value $remember");
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: false,
      );
      pr.style(
        message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),
      );
      pr.show();
      var response = await http.post(Uri.parse(Connection.login), body: {
        'email': userNameController.text,
        'password': passwordController.text,
        'secretkey': Connection.secretKey
      });
      var results = json.decode(response.body);
      pr.hide();
      if (results['status'] == true) {
        print("user details ${results['data'][0]}");

        UserModel userModel = UserModel.fromJson(results['data'][0]);
        print("model value ${userModel.customerId}");
        print("Salesman ID value ${userModel.salesmanId}");
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('company_name', userModel.companyName);
        preferences.setString('salesmanId', userModel.salesmanId);
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
        preferences.setBool('remember', remember);
        preferences.setString("kyc", userModel.kycApprove);
        preferences.setString("kycStats", userModel.kycStatus);
        preferences.setString('login', 'user');

        setState(() {
          _id = userModel.customerId;
          _initOneSignal();
        });

        userModel.kycStatus == "0"
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectCardType(
                          userId: userModel.customerId,
                        )),
                (Route<dynamic> route) => false)
            : userModel.kycApprove == "1"
                ? Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(status: true,customerId: userModel.customerId,customerName: userModel.customerName,
                        customerEmail: userModel.email,mobileNo: userModel.mobileNo,salesmanId: userModel.salesmanId,
                        )
                    ),
                    (Route<dynamic> route) => false)
                : Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SuccessPage(userId: userModel.customerId)),
                    (Route<dynamic> route) => false);
      } else if (results['status'] == false &&
          results['message'] ==
              "Customer Not active, Please Contact to Admin Department.") {
        Alerts.showAlertAndBack(context, 'Login Failed',
            'You are blocked please contact sales executive');
      } else {
        Alerts.showAlertAndBack(context, 'Login Failed',
            'Failed to login through username password. Please try again later.');
      }
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  String kycStatus;
  UserModel userModel;
  String gmail;
  String gName;

  _googleAuth() async {
    try {
      await googleSignIn.signIn().then((value) {
        print(
            "value of google sign in ${value.email} ${value.authentication.asStream()} ${value.displayName}");
        gmail = value.email;
        gName = value.displayName;
        _googleLogin(value.email, value.displayName);
      });
    } catch (error) {
      print('google sign-in error $error');
      Alerts.showAlertAndBack(context, 'Login Failed',
          'Failed to login through mail google sign in error. Please try again later.');
    }
  }

  _googleLogin(String email, String name) async {
    print("object google login");
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator(
        color: kPrimaryColor,
      )),
    );
    pr.show();
    var response = await http.post(Uri.parse(Connection.emailCheck), body: {
      'secretkey': '${Connection.secretKey}',
      'email': '$email',
    });
    print("object $response");
    var decodedData = json.decode(response.body);
    print('user exists $decodedData email $email');
    if (decodedData['status'] == true) {
      UserModel userModel = UserModel.fromJson(decodedData['data'][0]);
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
      preferences.setBool('remember', true);
      preferences.setString("kyc", userModel.kycApprove);
      preferences.setString("kycStats", userModel.kycStatus);
      preferences.setString('login', 'user');

      kycStatus = userModel.kycStatus;

      setState(() {
        _id = userModel.customerId;
        _initOneSignal();
      });
      pr.hide();
      userModel.kycStatus == "0"
          ? Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => KYCPageN(
                        userId: userModel.customerId,
                      )),
              (Route<dynamic> route) => false)
          : userModel.kycApprove == "1"
              ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(status: true)),
                  (Route<dynamic> route) => false)
              : Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SuccessPage(userId: userModel.customerId)),
                  (Route<dynamic> route) => false);
    } else if (decodedData['status'] == false &&
        decodedData['message'] ==
            "Customer Not active, Please Contact to Admin Department.") {
      pr.hide();
      googleSignIn.signOut();
      Alerts.showAlertAndBack(context, 'Login Failed',
          'You are blocked please contact sales executive');
    } else {
      pr.hide();
      final snackBar =
          SnackBar(content: Text("G-mail Not Registered. Please SignUp"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => MobileVerifyPage(
                    mail: gmail,
                    name: gName,
                  )));
      googleSignIn.signOut();
    }
  }
}
