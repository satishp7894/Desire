import 'dart:convert';

import 'package:confetti/confetti.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/models/user_model.dart';
import 'package:desire_users/pages/intro/kyc_view_page.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../home/home_page.dart';


class SuccessPage extends StatefulWidget {

  final String userId;

  SuccessPage({@required this.userId});

  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {

  UserModel userModel;


  @override
  void initState() {
    super.initState();
    checkConnectivity();
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body(),
      ),
    );
  }

  Widget _body(){
    return RefreshIndicator(
      onRefresh: () {
        return getDetails();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/success.png",
            height: 350, //40%
          ),
          Text(
            "KYC Upload Successful",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "Once KYC is approve you will be redirected to HomePage",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: DefaultButton(
                    text: "Check Kyc Status",
                    press: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => KycViewPage(userId: widget.userId,)), (route) => true);
                    },
                  ),
                ),
                TextButton(child: Text("Go Home", style: TextStyle(color: kPrimaryColor,fontSize: 20),), onPressed: (){
                  getDetails();
                })
              ],
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
  
  Future<void> getDetails() async{
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
   String id = preferences.getString("customer_id");
    String name = preferences.getString("Customer_name");
    String  email = preferences.getString("Email");
    String  mobileNo = preferences.getString("Mobile_no");
    
    print("object details ${preferences.getString("show_password")} ${preferences.getString("User_name")} ");

    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    var response = await http.post(Uri.parse(Connection.login), body: {
      'email':preferences.getString("User_name"),
      'password':preferences.getString("show_password"),
      'secretkey':Connection.secretKey
    });
    var results = json.decode(response.body);
    pr.hide();
    if (results['status'] == true) {
      print("user details ${results['data'][0]}");

      userModel = UserModel.fromJson(results['data'][0]);
      print("model value ${userModel.customerId}");
      userModel.kycApprove == "1" ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(status: true,customerId: id,customerName: name,mobileNo: mobileNo,customerEmail: email,)), (Route<dynamic> route) => false) : Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SuccessPage(userId: userModel.customerId)), (Route<dynamic> route) => false) ;
    }
    else if(results['status'] == false){
      final snackBar =
      SnackBar(content: Text("Kyc details is not yet Approved"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    else {
      Alerts.showAlertAndBack(context, 'Connection Error', 'Something went wrong try again');
    }
    
  }

}
