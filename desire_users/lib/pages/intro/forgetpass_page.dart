import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/components/custom_surfix_icon.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'otp_page.dart';


class ForgetPassPage extends StatefulWidget {
  @override
  _ForgetPassPageState createState() => _ForgetPassPageState();
}

class _ForgetPassPageState extends State<ForgetPassPage> with Validator{

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
    return Scaffold(

      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: Text("Forgot Password",style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 18),),
      iconTheme: IconThemeData(
        color: kBlackColor
      ),
      elevation: 0.0,
      centerTitle: true,),
      body: forgotPasswordView(),
    );
  }
  Widget forgotPasswordView(){
    return Form(
      autovalidateMode: _autoValidateMode1,
      key: _formKey1,
      child: ListView(
       children: [
         Padding(
           padding: const EdgeInsets.only(top: 50.0,bottom: 20),
           child: Image.asset("assets/images/forgot.png",height: 100,width: 100,),
         ),
         Padding(
           padding: const EdgeInsets.only(bottom: 20),
           child: Center(child: Expanded(child: Text("Forgot Your \nPassword ?",textAlign: TextAlign.center,style: TextStyle(fontSize: 32,color: kPrimaryColor),))),
         ),
         Padding(
           padding: const EdgeInsets.only(bottom: 20),
           child: Center(child: Expanded(child: Text("Just enter the registered mobile number \nand we will send you an otp.",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: kBlackColor),))),
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
                 textInputAction: TextInputAction.done,
                 cursorColor: kBlackColor,
                 textAlign: TextAlign.left,
                 validator: validateMobile,
                 autofocus: true,
                 controller: phone,
                 keyboardType: TextInputType.phone,
                 inputFormatters: [
                   FilteringTextInputFormatter.digitsOnly,
                   LengthLimitingTextInputFormatter(10),
                 ],
                 decoration: InputDecoration(
                   contentPadding: EdgeInsets.zero,
                   prefix:Text("+91 - "),
                   prefixStyle: TextStyle(
                     color: kBlackColor
                   ),
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
                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => OtpPage(page: "password", mob: phone.text, remember:  true,)), (route) => false);
               }
             },
           ),
         ),


       ],
      ),
    );
  }

  Widget _body(){
    return Container(
      color: Colors.black12,
      height: double.infinity,
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child:  Form(
          autovalidateMode: _autoValidateMode1,
          key: _formKey1,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  "Please enter your REGISTER PHONE No. We will send you a OTP to reset your Password",
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16.0),
                  children: <Widget>[
                    const SizedBox(height: 10.0),
                    TextFormField(
                      textInputAction: TextInputAction.done,
                      textAlign: TextAlign.center,
                      validator: validateMobile,
                      controller: phone,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      scrollPadding: EdgeInsets.zero,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        hintText: "Enter your Mobile No.",
                        hintStyle: TextStyle(color: Colors.black45),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Lock.svg"),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(30)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(30)),
                        focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        primary: kPrimaryColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text("Get OTP",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),),
                      onPressed: () {
                        if(_formKey1.currentState.validate()){
                          _formKey1.currentState.save();
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => OtpPage(page: "password", mob: phone.text, remember:  true,)), (route) => false);
                        }

                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
