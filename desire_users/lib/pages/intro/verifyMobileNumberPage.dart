import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/pages/intro/new_login_page.dart';
import 'package:desire_users/pages/intro/signup_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/validator.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class VerifyMobileNumberPage extends StatefulWidget {
  const VerifyMobileNumberPage({Key key}) : super(key: key);

  @override
  _VerifyMobileNumberPageState createState() => _VerifyMobileNumberPageState();
}

class _VerifyMobileNumberPageState extends State<VerifyMobileNumberPage> with Validator{
  TextEditingController mobileNumberController;
  AutovalidateMode _autoValidateMode1 = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  bool validate = false;

  String smsCode;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    mobileNumberController = TextEditingController();

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
    mobileNumberController.dispose();
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
            child: Text("Just enter your mobile number \nand we will verify your mobile number.",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: kBlackColor),),
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
                    controller: mobileNumberController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        prefix:Text("+91 - "),
                        border: InputBorder.none,
                        hintText: "Enter your mobile number",
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
              child: Text("Verify Mobile Number",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),),
              onPressed: () {
                   verifyMobileNumberApi();
              },
            ),
          ),


        ],
      ),
    );
  }


  verifyMobileNumberApi()async{
    if(_formKey1.currentState.validate()){
      _formKey1.currentState.save();
    }
    var response = await http.post(Uri.parse(Connection.verifyMobileNumber), body: {
      'secretkey': Connection.secretKey,
      'mobile': mobileNumberController.text
    });
    var results = json.decode(response.body);
    print("Verify Mobile Result $results");
      if(results['status'] == true){
        final snackBar =
        SnackBar(content: Text("Mobile Number Already Registered."),action: SnackBarAction(
          label: "Login Here",
          onPressed: (){
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NewLoginPage()),);
          },
        ),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      else if(results['status'] == false){
        final snackBar =
        SnackBar(content: Text("Mobile Number Not Registered."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SignUpPage(
                    mobile: mobileNumberController.text,
                  )),);
      }
      else {

      }

  }

}
