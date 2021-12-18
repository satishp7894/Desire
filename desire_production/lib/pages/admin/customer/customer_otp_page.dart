import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'add_customer_kyc_page.dart';


class CustomerOtpPage extends StatefulWidget {
  final String mob;
  final String customerId;

  const CustomerOtpPage({@required this.mob, @required this.customerId,});
  @override
  _CustomerOtpPageState createState() => _CustomerOtpPageState();
}

class _CustomerOtpPageState extends State<CustomerOtpPage>  with Validator{

  TextEditingController _otpController;
  String otp;
  var count;
  String value = "";
  String _verificationCode;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    _otpController = TextEditingController();
    _verifyPhone();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Text(
                "OTP Verification",
                style: headingStyle,
              ),
              SizedBox(height: 20,),
              Text("We sent your code to ${widget.mob.replaceRange(0, 6, "******")}"),
              buildTimer(),
              count == 0.0 ? TextButton(
                child: Text("Resend OTP Code", style: TextStyle(decoration: TextDecoration.underline, color: Colors.indigoAccent),),
                onPressed: (){
                  _verifyPhone();
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
                    hasTextBorderColor: Colors.transparent,
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
                                //_initOneSignal();
                                //widget.page == "login" ? getLoginDetails() : getDetails();
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => AddCustomerKycPage(customerId: widget.customerId, )), (route) => false);
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
    );
  }

  Row buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("This code will expired in "),
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

  _verifyPhone() async {
    print("object mobile number ${widget.mob}");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.mob}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              // _initOneSignal();
              // widget.page == "login" ? getLoginDetails() : getDetails();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => AddCustomerKycPage(customerId: widget.customerId, )), (route) => false);
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
}
