import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/pages/intro/sales_login_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/custom_surfix_icon.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/sales/utils_sales/validator.dart';
import 'package:desire_users/services/connection_sales.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class SalesForgotPasswordPage extends StatefulWidget {
  const SalesForgotPasswordPage({Key key}) : super(key: key);

  @override
  _SalesForgotPasswordPageState createState() => _SalesForgotPasswordPageState();
}

class _SalesForgotPasswordPageState extends State<SalesForgotPasswordPage> with Validator {

  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode  = AutovalidateMode.disabled;
  @override
  void initState() {
    super.initState();
    checkConnectivity();
    emailController = TextEditingController();
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
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: Text("Forgot Password",),
        elevation: 0.0,
        titleTextStyle: appbarStyle,
        centerTitle: false,),
      body: forgotPasswordView(),
    );
  }
  Widget forgotPasswordView(){
    return Form(
      autovalidateMode: _autoValidateMode,
      key: _formKey,
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
            child: Center(child: Expanded(child: Text("Just enter the registered email id.",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: kBlackColor),))),
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
                    autofocus: true,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        prefixStyle: TextStyle(
                            color: kBlackColor
                        ),
                        border: InputBorder.none,
                        hintText: "Enter registered email id",
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
              child: Text("Send",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),),
              onPressed: () {
               _forgotPasswordApi();
              },
            ),
          ),


        ],
      ),
    );
  }



  _forgotPasswordApi()async{

    if (_formKey.currentState.validate()){
      _formKey.currentState.save();
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();
      var response = await http.post(Uri.parse(ConnectionSales.forgotPass), body: {
        'emailid':emailController.text,
        'secretkey':ConnectionSales.secretKey
      });
      var results = json.decode(response.body);
      pr.hide();
      if (results['status'] == true) {
        print("user details ${results['status']}");

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SalesLoginPage()), (route) => false);
      } else {
        Alerts.showAlertAndBack(context, "Password Reset Failed", "Incorrect EmailId");
      }
    } else {
      _autoValidateMode = AutovalidateMode.always;
    }
  }

}
