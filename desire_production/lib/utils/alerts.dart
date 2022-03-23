import 'dart:convert';
import 'dart:io';
import 'package:desire_production/pages/admin/customer/customer_order_details_page.dart';
import 'package:desire_production/pages/admin/customer/edit_order_page.dart';
import 'package:desire_production/pages/admin/products/product_home_page.dart';
import 'package:desire_production/pages/admin/sales/customer_credit_page.dart';
import 'package:desire_production/pages/production/pendingOrdersPage.dart';
import 'package:desire_production/pages/production/production_planning_page.dart';
import 'package:desire_production/pages/warehouse/warehouse_list_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:http/http.dart' as http;
import 'package:desire_production/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'custom_surfix_icon.dart';
import 'progress_dialog.dart';

class Alerts{

  static showAlertEditProduct(BuildContext context, String title, String message, String prodcutId, String productName, String orderId, String orderName, String qty, String price, String customerName, String customerId,) {
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
                          editProduct(context, prodcutId, productName, orderId, orderName, qty, price, customerName, customerId,);
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

  static editProduct(BuildContext context, String productId, String productName, String orderId, String orderName, String qty, String price,String customerName, String customerId,) async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    print("object request for edit $orderId $productId $qty $price $productName $orderName");

    var response = await http.post(Uri.parse(Connection.editOrderAdding), body: {
      'secretkey':Connection.secretKey,
      "product_id":productId,
      "product_name":productName,
      "order_id":orderId,
      "order_number":orderName,
      "qty":qty,
      "price":price,
    });

    var results = json.decode(response.body);
    pr.hide();
    if (results['status'] == true) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => EditOrderPage(customerName: customerName,customerId: customerId,orderId: orderId,orderName: orderName,)), (route) => false);
    } else {
      Alerts.showAlertAndBack(context, 'Failed', 'Failed to change quantity. Please contact sales person.');
    }
  }



  static showAlertProduction(BuildContext context, String customerId, String customerName,) {
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
                  Text('Successfull', style: TextStyle(color: Colors.black,
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
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>CustomerOrderDetailPage(customerName: customerName, customerId: customerId,)), (route) => false);
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

  static showLogOut(BuildContext context, String title, String message) {
    showDialog(context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title,style: TextStyle(color:kPrimaryColor, fontSize: 20, fontWeight: FontWeight.bold,),),
              Text(message,style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),),
              Divider(thickness: 1, color: Colors.grey),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor
                    ),
                    child: Text("Logout", style: TextStyle(color: Colors.white),),
                    onPressed: () async{
                      SharedPreferences _prefs = await SharedPreferences.getInstance();
                      await _prefs.clear();
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => LoginPage()));
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: kSecondaryColor
                    ),
                    child: Text("Cancel", style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  static showAlertAndBack(BuildContext context, String title, String message)  {
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

  static showAlertAndBackPro(BuildContext context, String title, String message, String page) {
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
                      Navigator.of(c).pop();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => PendingOrdersPage(page: page,)), (route) => false);                    },
                    child: Text("Okay", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.normal), textAlign: TextAlign.center,))
              ],
            ),
          ),
        );
      },
    );
  }
  static showAlertAndBackWare(BuildContext context, String title, String message, String page) {
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
                      Navigator.of(c).pop();
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => WarehouseListPage(page: page,)), (route) => false);                    },
                    child: Text("Okay", style: TextStyle(color: kPrimaryColor, fontSize: 18, fontWeight: FontWeight.normal), textAlign: TextAlign.center,))
              ],
            ),
          ),
        );
      },
    );
  }

  static showAlertAndBackPlan(BuildContext context, String title, String message, String page) {
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
                  child: Text("Okay", style: TextStyle(color: Colors.red),),
                  onPressed: () {
                    Navigator.of(c).pop();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => ProductionPlanningPage(page: page,)), (route) => false);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static showAlertExit(BuildContext context, String title, String message) {
    showDialog(context: context,
      builder: (BuildContext c) {
        return CupertinoAlertDialog(
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title,style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
              SizedBox(height: 5 ,),
              Text(message,style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),),
              Divider(thickness: 1, color: Colors.grey,),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor
                    ),
                    child: Text("Okay", style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.of(c).pop();
                      exit(0);
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: kSecondaryColor
                    ),
                    child: Text("Cancel", style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.of(c).pop();
                    },
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  static showAlertPdf(BuildContext context, String title, String message, String filePath) {
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

  static showEmailPopup(BuildContext context) {
    TextEditingController email = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    AutovalidateMode _autoValidateMode  = AutovalidateMode.disabled;
    showDialog(context: context,
      builder: (BuildContext c) {
        return AlertDialog(
          content: Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Enter Registered Email-Id to receive a mail for new password',textAlign: TextAlign.center,style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
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
                      prefixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
                      labelStyle: TextStyle(color: kPrimaryColor),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kPrimaryColor
                        )
                      )
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(

                      child: Text("Cancel", style: TextStyle(color: Colors.black,fontSize: 16),),
                      onPressed: () {
                        Navigator.of(c).pop();
                      },
                    ),
                    TextButton(
                      child: Text("Send", style: TextStyle(color: kPrimaryColor,fontSize: 16),),
                      onPressed: () async{
                        Navigator.of(c).pop();
                        if (_formKey.currentState.validate()){
                          _formKey.currentState.save();
                          ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
                            isDismissible: false,);
                          pr.style(message: 'Please wait...',
                            progressWidget: Center(child: CircularProgressIndicator()),);
                          pr.show();
                          var response = await http.post(Uri.parse(Connection.forgotPass), body: {
                            'emailid':email.text,
                            'secretkey':Connection.secretKey
                          });
                          var results = json.decode(response.body);
                          pr.hide();
                          if (results['status'] == true) {
                            print("user details ${results['status']}");

                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => LoginPage()), (route) => false);
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

  static showAlertCheckOut(BuildContext context, String amount, String qty, String id, String address, String name, String salesId) {
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
                          checkOut(context, amount, qty, id, address, name, salesId);
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

  static showAlertSuccess(BuildContext context, String id, String name, String salesId) {
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
                            emptyCart(context,id,name,salesId);
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

  static checkOut(BuildContext context, String amount, String qty, String id, String address,String name,String salesId) async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();

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

    pr.hide();
    if (results['status'] == true) {
      Alerts.showAlertSuccess(context,id,name,salesId);
    } else {
      Alerts.showAlertAndBack(context, 'Checkout Failed', 'Failed to place order. Please try again later.');
    }
  }

  static emptyCart(BuildContext context, String id, String name, String salesId) async{
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
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ProductHomePage(customerId: id,customerName: name, salesId: salesId,)), (Route<dynamic> route) => false);
    } else {
      print("object error");
    }
  }


  static showCreditApprove(BuildContext context, String custId) {
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
                Text("Credit Approval",style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text("Aprove Credit for Customer",style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal),),
                Divider(thickness: 1, color: Colors.grey,),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text("Approve", style: TextStyle(color: Colors.red),),
                      onPressed: () async{
                        approveCredit(context, custId);
                      },
                    ),
                    TextButton(
                      child: Text("Cancel", style: TextStyle(color: Colors.red),),
                      onPressed: () {
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

  static approveCredit(BuildContext context, String custId) async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    var response = await http.post(Uri.parse(Connection.creditApprove), body: {
      'secretkey':Connection.secretKey,
      'user_id':"$custId",
      'status':"1",
    });

    print("object ${response.body}");
    var results = json.decode(response.body);

    pr.hide();
    if (results['status'] == true) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerCreditPage()), (route) => false);
    } else {
      Alerts.showAlertAndBack(context, "Error","Cannot approve");
    }
  }

}