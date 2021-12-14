import 'dart:convert';
import 'dart:io';
import 'package:desire_users/pages/intro/new_login_page.dart';
import 'package:desire_users/sales/pages/sales_home_page.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:desire_users/pages/home/home_page.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alerts {

  static showExit(BuildContext context, String title, String message) {
    showDialog(context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          width: 80,
          alignment: Alignment.center,
          decoration:BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30)
          ),
          child: CupertinoAlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text(message,style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),),
                Divider(thickness: 1, color: Colors.grey,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: ()async{
                          exit(0);
                        },
                        child: Text("Exit", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.normal),)),
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static showExitHome(BuildContext context, String title, String message) {
    showDialog(context: context,
      builder: (BuildContext context) {
        return Platform.isIOS ? CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            CupertinoButton(
              child: Text("Okay", style: TextStyle(color: Colors.red),),
              onPressed: () async{
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SalesHomePage()), (route) => false);
              },
            ),
            CupertinoButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ) : AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("Okay", style: TextStyle(color: Colors.red),),
              onPressed: () async{
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SalesHomePage()), (route) => false);
              },
            ),
            TextButton(
              child: Text("Cancel", style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static showLogOut(BuildContext context, String title, String message) {
    showDialog(context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          width: 80,
          alignment: Alignment.center,
          decoration:BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30)
          ),
          child: CupertinoAlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text(message,style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),),
                Divider(thickness: 1, color: Colors.grey,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: ()async{
                          SharedPreferences _prefs = await SharedPreferences.getInstance();
                          await _prefs.clear();
                          Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => NewLoginPage()));},
                        child: Text("Logout", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.normal),)),
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static showAlertAndBack(BuildContext context, String title, String message) {
    showDialog(context: context,
      builder: (BuildContext c) {
        return Container(
          height: 150,
          width: 80,
          alignment: Alignment.center,
          decoration:BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30)
          ),
          child: CupertinoAlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text(message,style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),),
                Divider(thickness: 1, color: Colors.grey,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: (){
                         // Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NewLoginPage()));
                        },
                        child: Text("Okay", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.normal), textAlign: TextAlign.center,)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static showAlertSuccess(BuildContext context, String id) {
    showDialog(context: context,
      builder: (BuildContext c) {
        return Container(
          height: 150,
          width: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30)
          ),
          child: CupertinoAlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Success', style: TextStyle(color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text('Order Placed Successfully', style: TextStyle(color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.normal),),
                Divider(thickness: 1, color: Colors.grey,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () async {
                          emptyCart(context,id);
                          Hive.deleteBoxFromDisk(Connection.cartList);
                        },
                        child: Text("Okay",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,)),
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }

  static showAlertCheckOut(BuildContext context, String amount, String qty, String id, String address) {
    print("value of data to be parsed $amount $qty $id $address");
    showDialog(context: context,
      builder: (BuildContext c) {
        return Container(
          height: 150,
          width: 80,
          alignment: Alignment.center,
          decoration:BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30)
          ),
          child: CupertinoAlertDialog(
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Place Order',style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text('Total Quantity: $qty\nTotal Amount: $amount',style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),),
                Divider(thickness: 1, color: Colors.grey,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: (){
                          checkOut(context, amount, qty, id, address);
                        },
                        child: Text("Okay", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.normal), textAlign: TextAlign.center,)),
                    TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Cancel", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static checkOut(BuildContext context, String amount, String qty, String id, String address) async{


    var response = await http.post(Uri.parse(Connection.checkOut), body: {
      'secretkey':Connection.secretKey,
      'customer_id':"$id",
      'total_order_quantity':"$qty",
      'order_amount':"$amount",
      'discounted_total':"234",
      'coupon_code':"12",
      'selectedAddress':"$address",
      'bdOrderNote':"qwert"
    });

    print("object response ${response.body}");
    var results = json.decode(response.body);
    if (results['status'] == true) {
      final snackBar =
      SnackBar(content: Text("Your Orders Placed Successfully"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }
    else {
      final snackBar =
      SnackBar(content: Text("Failed to Place Order"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  static emptyCart(BuildContext context, String id) async{
    String customerName , customerEmail, customerMobileNo, customerId;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    customerId = preferences.getString("customer_id");
    customerEmail = preferences.getString("Email");
    customerMobileNo = preferences.getString("Mobile_no");
    customerName = preferences.getString("Customer_name");
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();

    var response = await http.post(Uri.parse(Connection.emptyCart), body: {
      'secretkey':Connection.secretKey,
      'customer_id':"$id",
    });

    print("object response ${response.body}");
    var results = json.decode(response.body);

    pr.hide();
    if (results['status'] == true) {
      Navigator.of(context).pop();
      showAlertSuccess(context, id);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(status: true,customerName:customerName ,customerEmail: customerEmail,mobileNo: customerMobileNo,customerId: customerId,)));
    } else {
      print("object error");
    }
  }

}