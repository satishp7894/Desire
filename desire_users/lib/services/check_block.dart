import 'dart:convert';
import 'package:desire_users/models/product_model.dart';
import 'package:desire_users/pages/home/home_page.dart';
import 'package:desire_users/pages/intro/block_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'connection.dart';

class CheckBlocked{

  String mob;

  CheckBlocked(this.mob);

  getDetails(BuildContext context) async{

    // ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
    //   isDismissible: false,);
    // pr.style(message: 'Please wait for check...',
    //   progressWidget: Center(child: CircularProgressIndicator()),);
    // pr.show();

    print("object mobile $mob");

    var response = await http.post(Uri.parse(Connection.mobileCheck), body: {
      'secretkey': '${Connection.secretKey}',
      'mobile': '$mob',
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    //pr.hide();
    if (results['status'] == false) {
      final snackBar = SnackBar(content: Text('You are Blocked'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BlockedPage(mob: mob, )), (route) => false);
    } else{
      //pr.hide();
      // Navigator.pop(context);
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomePage(status: false,)), (route) => false);
    }
  }

  getDetailsBlock(BuildContext context) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
   String id = preferences.getString("customer_id");
    String name = preferences.getString("Customer_name");
    String  email = preferences.getString("Email");
    String mobileNo = preferences.getString("Mobile_no");
    print("object mobile $mob");

    var response = await http.post(Uri.parse(Connection.mobileCheck), body: {
      'secretkey': '${Connection.secretKey}',
      'mobile': '$mob',
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');

    if (results['status'] == false) {
      final snackBar = SnackBar(content: Text('You are Blocked'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BlockedPage(mob: mob, )), (route) => false);
    } else{
      //pr.hide();
     // Navigator.pop(context);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomePage(status: true,customerId: id,customerEmail:email,mobileNo: mobileNo,customerName: name,)), (route) => false);
    }
  }

  getDetailsCart(BuildContext context, String id, String page) async{

    // ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
    //   isDismissible: false,);
    // pr.style(message: 'Please wait...',
    //   progressWidget: Center(child: CircularProgressIndicator()),);
    // pr.show();

    print("object mobile $mob");

    var response = await http.post(Uri.parse(Connection.mobileCheck), body: {
      'secretkey': '${Connection.secretKey}',
      'mobile': '$mob',
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
   // pr.hide();
    if (results['status'] == false) {
      final snackBar = SnackBar(content: Text('You are Blocked'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BlockedPage(mob: mob,)), (route) => false);
    } else{
     // pr.hide();
      // page == "Cart" ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CartPage(status: false, id: id,)), (route) => false) :
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => OrderHistoryPage(status: false, id: id,)), (route) => false);
    }
  }

  getDetailsAccessory(BuildContext context, String comeP, String page, List<Product> acc, Product product) async{

    // ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
    //   isDismissible: false,);
    // pr.style(message: 'Please wait...',
    //   progressWidget: Center(child: CircularProgressIndicator()),);
    // pr.show();

    print("object mobile $mob");

    var response = await http.post(Uri.parse(Connection.mobileCheck), body: {
      'secretkey': '${Connection.secretKey}',
      'mobile': '$mob',
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    //pr.hide();
    if (results['status'] == false) {
      final snackBar = SnackBar(content: Text('You are Blocked'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BlockedPage(mob: mob,)), (route) => false);
    } else{
      //pr.hide();
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => AccessoryDetailPage(status: false, product: product,page: comeP,snapshot:acc,)), (route) => false);
    }
  }

  getDetailsAccessoryL(BuildContext context, List<Product> acc, String title, bool refresh) async{

    // ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
    //   isDismissible: false,);
    // pr.style(message: 'Please wait...',
    //   progressWidget: Center(child: CircularProgressIndicator()),);
    // pr.show();

    print("object mobile $mob");

    var response = await http.post(Uri.parse(Connection.mobileCheck), body: {
      'secretkey': '${Connection.secretKey}',
      'mobile': '$mob',
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    //pr.hide();
    if (results['status'] == false) {
      final snackBar = SnackBar(content: Text('You are Blocked'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BlockedPage(mob: mob)), (route) => false);
    } else{
     // pr.hide();
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => AccessoryListPage(status: false, snapshot:acc,title: title, refresh: refresh,)), (route) => false);
    }
  }

  getDetailsProduct(BuildContext context, String comeP, String page, List<Product> acc, Product product) async{

    // ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
    //   isDismissible: false,);
    // pr.style(message: 'Please wait...',
    //   progressWidget: Center(child: CircularProgressIndicator()),);
    // pr.show();

    print("object mobile $mob");

    var response = await http.post(Uri.parse(Connection.mobileCheck), body: {
      'secretkey': '${Connection.secretKey}',
      'mobile': '$mob',
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    //pr.hide();
    if (results['status'] == false) {
      final snackBar = SnackBar(content: Text('You are Blocked'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BlockedPage(mob: mob,)), (route) => false);
    } else{
     // pr.hide();
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => ProductDetailPage(status: false, product: product,page: comeP,snapshot:acc,)), (route) => false);
    }
  }

  getDetailsProductL(BuildContext context, List<Product> product, String title, bool refresh) async{

    // ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
    //   isDismissible: false,);
    // pr.style(message: 'Please wait...',
    //   progressWidget: Center(child: CircularProgressIndicator()),);
    // pr.show();

    print("object mobile $mob");

    var response = await http.post(Uri.parse(Connection.mobileCheck), body: {
      'secretkey': '${Connection.secretKey}',
      'mobile': '$mob',
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    //pr.hide();
    if (results['status'] == false) {
      final snackBar = SnackBar(content: Text('You are Blocked'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BlockedPage(mob: mob,)), (route) => false);
    } else{
      //pr.hide();
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => ProductListPage(status: false,snapshot:product, title: title,refresh: refresh,)), (route) => false);
    }
  }

  getDetailsCategory(BuildContext context, String id, String name) async{

    // ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
    //   isDismissible: false,);
    // pr.style(message: 'Please wait...',
    //   progressWidget: Center(child: CircularProgressIndicator()),);
    // pr.show();

    print("object mobile $mob");

    var response = await http.post(Uri.parse(Connection.mobileCheck), body: {
      'secretkey': '${Connection.secretKey}',
      'mobile': '$mob',
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    //pr.hide();
    if (results['status'] == false) {
      final snackBar = SnackBar(content: Text('You are Blocked'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BlockedPage(mob: mob,)), (route) => false);
    } else{
     // pr.hide();
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => ProductCategoryPage(status: false,id: id,name: name,)), (route) => false);
    }
  }

  getDetailsProfile(BuildContext context) async{

    // ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
    //   isDismissible: false,);
    // pr.style(message: 'Please wait...',
    //   progressWidget: Center(child: CircularProgressIndicator()),);
    // pr.show();

    print("object mobile $mob");

    var response = await http.post(Uri.parse(Connection.mobileCheck), body: {
      'secretkey': '${Connection.secretKey}',
      'mobile': '$mob',
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    //pr.hide();
    if (results['status'] == false) {
      final snackBar = SnackBar(content: Text('You are Blocked'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BlockedPage(mob: mob,)), (route) => false);
    } else{
      //pr.hide();
     // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => ProfilePage(status: false)), (route) => false);
    }
  }

  getDetailsUserD(BuildContext context) async{

    // ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
    //   isDismissible: false,);
    // pr.style(message: 'Please wait...',
    //   progressWidget: Center(child: CircularProgressIndicator()),);
    // pr.show();

    print("object mobile $mob");

    var response = await http.post(Uri.parse(Connection.mobileCheck), body: {
      'secretkey': '${Connection.secretKey}',
      'mobile': '$mob',
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    //pr.hide();
    if (results['status'] == false) {
      final snackBar = SnackBar(content: Text('You are Blocked'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BlockedPage(mob: mob,)), (route) => false);
    } else{
      //pr.hide();
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => UserDetailPage(status: false)), (route) => false);
    }
  }

  getDetailsAddress(BuildContext context, String userId, String page) async{

    // ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
    //   isDismissible: false,);
    // pr.style(message: 'Please wait...',
    //   progressWidget: Center(child: CircularProgressIndicator()),);
    // pr.show();

    print("object mobile $mob");

    var response = await http.post(Uri.parse(Connection.mobileCheck), body: {
      'secretkey': '${Connection.secretKey}',
      'mobile': '$mob',
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    //pr.hide();
    if (results['status'] == false) {
      final snackBar = SnackBar(content: Text('You are Blocked'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BlockedPage(mob: mob,)), (route) => false);
    } else{
      //pr.hide();
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => AddressViewPage(status: false, userId: userId, page: page,)), (route) => false);
    }
  }

}