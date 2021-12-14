import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/components/custom_surfix_icon.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'otp_page.dart';

class MobileVerifyPage extends StatefulWidget {

  final String mail;
  final String name;

  const MobileVerifyPage({Key key, this.mail, this.name});

  @override
  _MobileVerifyPageState createState() => _MobileVerifyPageState();
}

class _MobileVerifyPageState extends State<MobileVerifyPage> with Validator{

  TextEditingController phone;
  AutovalidateMode _autoValidateMode1 = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  bool validate = false;

  String smsCode;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    phone = TextEditingController();
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
    phone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("Mobile Number Verification", style: TextStyle(color: Colors.black,fontSize: 18),),
          centerTitle: false,),
        body: mobileVerifyView(),
      ),
    );
  }


  Widget mobileVerifyView(){
    return Form(
      autovalidateMode: _autoValidateMode1,
      key: _formKey1,
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0,bottom: 20),
            child: Image.asset("assets/images/smartphone.png",height: 100,width: 100,color: kPrimaryColor,),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text("Verify Your Phone Number ?",textAlign: TextAlign.center,style: TextStyle(fontSize: 24,color: kPrimaryColor),),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text("Just enter your mobile number \nand we will send you an otp.",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: kBlackColor),),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 20,left: 20,right: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                  ),],
                  color: kWhiteColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0,bottom: 4.0,left: 10),
                  child: TextFormField(
                    cursorColor: kBlackColor,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.left,
                    validator: validateMobile,
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        prefix:Text("+91 - "),
                        border: InputBorder.none,
                        hintText: "Enter registered mobile number",
                        hintStyle: TextStyle(color: kTextColor)
                    ),
                  ),
                ),
              )
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                primary: kPrimaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text("Send OTP",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),),
              onPressed: () {
                if(_formKey1.currentState.validate()){
                  _formKey1.currentState.save();
                  widget.mail == null ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => OtpPage(page: "signup", mob: phone.text, remember:  true,)), (route) => false) :
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => OtpPage(page: "signup", mob: phone.text, remember:  true, mail: widget.mail, name: widget.name,)), (route) => false);
                }
              },
            ),
          ),


        ],
      ),
    );
  }

}
