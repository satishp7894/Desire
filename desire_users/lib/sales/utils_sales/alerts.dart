import 'dart:convert';
import 'dart:io';
import 'package:desire_users/pages/intro/new_login_page.dart';
import 'package:desire_users/sales/pages/orders/customerOrderHistoryPage.dart';
import 'package:desire_users/sales/pages/products/product_home_page.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/services/connection.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:desire_users/pages/intro/sales_login_page.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/services/connection_sales.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_surfix_icon.dart';


class Alerts{

  static showAlertPdf(BuildContext context, String title, String message, String filePath) {
    showDialog(context: context,
      builder: (BuildContext context) {
        return Container(
          height: 150,
          width: 80,
          alignment: Alignment.center,
          decoration:BoxDecoration(
              color: Colors.white,
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
                      child: Text("Okay", style: TextStyle(color: Colors.red),),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Show", style: TextStyle(color: Colors.red),),
                      onPressed: () {
                        OpenFile.open(filePath);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static showCustomerLogOut(BuildContext context, String title, String message) {
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
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:  (b) => NewLoginPage()), (route) => false);
                          },
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

  static showSalesLogOut(BuildContext context, String title, String message) {
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
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:  (b) => SalesLoginPage()), (route) => false);
                          },
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
                TextButton(
                    onPressed: ()async{
                      Navigator.pop(context);
                    },
                    child: Text("Okay", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.normal), textAlign: TextAlign.center,))
              ],
            ),
          ),
        );
      },
    );
  }

  static showAlertProduction(BuildContext context, String salesId, String customerId, String customerName, String name, String email) {
    showDialog(context: context,
      builder: (BuildContext c)
    {
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
              Text('Send to Production', style: TextStyle(color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('Successful', style: TextStyle(color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal),),
              Divider(thickness: 1, color: Colors.grey,),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text("OK", style: TextStyle(color: Colors.red),),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>CustomerOrderHistoryPage()), (route) => false);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  static showEmailPopup(BuildContext context) {
    TextEditingController email = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    AutovalidateMode _autoValidateMode  = AutovalidateMode.disabled;
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
                Text('Enter Registered Email-Id to receive a mail for new password',style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Form(
                  autovalidateMode: _autoValidateMode,
                  key: _formKey,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value){
                      String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = RegExp(pattern);
                      if(!regExp.hasMatch(value)) {
                        return "Invalid Email";
                      } else {
                        return null;
                      }
                    },
                    controller: email,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                    ),
                  ),
                ),
                Divider(thickness: 1, color: Colors.grey,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text("Cancel", style: TextStyle(color: Colors.red),),
                      onPressed: () {
                        Navigator.of(c).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Send", style: TextStyle(color: Colors.red),),
                      onPressed: () async{
                        Navigator.of(c).pop();
                        if (_formKey.currentState.validate()){
                          _formKey.currentState.save();
                          ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
                            isDismissible: false,);
                          pr.style(message: 'Please wait...',
                            progressWidget: Center(child: CircularProgressIndicator()),);
                          pr.show();
                          var response = await http.post(Uri.parse(ConnectionSales.forgotPass), body: {
                            'emailid':email.text,
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
                      },
                    ),
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
      },
    );
  }

  static showAlertCheckOut(BuildContext context, String amount, String qty, String id, String address, String salesId) {
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
                          checkOut(context, amount, qty, id, address,salesId);                        },
                        child: Text("Okay", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.normal), textAlign: TextAlign.center,)),
                    TextButton(
                        onPressed: () {
                          showAlertLastProduct(context, id);
                        },
                        child: Text("Remove", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.normal), textAlign: TextAlign.center,)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static showAlertLastProduct(BuildContext context, String id) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
                Text('Remove All',style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text('Are you sure to empty cart?',style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),),
                Divider(thickness: 1, color: Colors.grey,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: (){
                          prefs.remove("customer_id");
                          prefs.remove("customer_name");
                          prefs.remove("add");
                          prefs.remove("add_id");
                          Hive.deleteBoxFromDisk(Connection.cartList);
                          emptyCart(context,id);                        },
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

  static checkOut(BuildContext context, String amount, String qty, String id, String address, String salesId) async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();

    var response = await http.post(Uri.parse(ConnectionSales.checkOut), body: {
      'secretkey':Connection.secretKey,
      'customer_id':"$id",
      'total_order_quantity':"$qty",
      'order_amount':"$amount",
      'discounted_total':"234",
      'coupon_code':"12",
      'selectedAddress':"$address",
      'bdOrderNote':"qwert",
      'salesman_id' : "$salesId"
    });

    print("object response ${response.body}");
    var results = json.decode(response.body);

    pr.hide();
    if (results['status'] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("customer_id");
      prefs.remove("customer_name");
      prefs.remove("add");
      prefs.remove("add_id");
      Alerts.showAlertSuccess(context,id);
    } else {
      Alerts.showAlertAndBack(context, 'Checkout Failed', 'Failed to place order. Please try again later.');
    }
  }

  static emptyCart(BuildContext context, String id) async{
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
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ProductHomePage()), (Route<dynamic> route) => false);
    } else {
      print("object error");
    }
  }

  static showExit(BuildContext context, String title, String message) {
    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,style: TextStyle(color:kPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text(message,style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),),
                SizedBox(height: 10,),
                Divider(thickness: 1, color: Colors.grey,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                       style: TextButton.styleFrom(
                         backgroundColor: kPrimaryColor
                       ),
                        onPressed: ()async{
                          exit(0);
                        },
                        child: Text("Exit", style: TextStyle(color: kWhiteColor, fontSize: 18, fontWeight: FontWeight.normal),)),
                    TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: kBlackColor
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal),)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static showAlertEditProduct(BuildContext context, String title, String message, String prodcutId, String productName, String orderId, String orderName, String qty, String price, String salesId, String customerName, String customerId, String name, String email, ) {
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
                        onPressed: ()async{
                          //Navigator.pop(context);
                          editProduct(context, prodcutId, productName, orderId, orderName, qty, price, salesId, customerName, customerId, name, email);
                        },
                        child: Text("Okay", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.normal), textAlign: TextAlign.center,)),
                    TextButton(
                        onPressed: ()async{
                          Navigator.pop(context);
                        },
                        child: Text("Cancel", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.normal), textAlign: TextAlign.center,)),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static editProduct(BuildContext context, String productId, String productName, String orderId, String orderName, String qty, String price, String salesId, String customerName, String customerId, String name, String email) async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    print("object request for edit $orderId $productId $qty $price $productName $orderName $salesId");

    var response = await http.post(Uri.parse(ConnectionSales.editOrderAdding), body: {
      'secretkey':Connection.secretKey,
      "product_id":productId,
      "product_name":productName,
      "order_id":orderId,
      "order_number":orderName,
      "qty":qty,
      "price":price,
      "salesmanID":salesId,
    });

    var results = json.decode(response.body);
    pr.hide();
    if (results['status'] == true) {

    } else {
      Alerts.showAlertAndBack(context, 'Failed', 'Failed to change quantity. Please contact sales person.');
    }
  }

}