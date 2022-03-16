import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/cart_bloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/cart_model.dart';
import 'package:desire_production/pages/admin/products/product_home_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/custom_stepper.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;

import 'customer_address_view_page.dart';

class CustomerCartPage extends StatefulWidget {

  final String customerId;
  final String customerName;
  final String salesId;

  CustomerCartPage({@required this.customerId, @required this.customerName, @required this.salesId,});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CustomerCartPage> {

  final bloc = CartBloc();
  List<bool> _status = [];

  List<TextEditingController> price;
  List<TextEditingController> qty;

  List<double> amount = [];
  List<int> quantity = [];
  String address = "";
  String addressId = "";
  String salesId = "";
  String customerName = "";
  double totalAmount = 0;
  int totalQty = 0;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    price = [];
    qty = [];
    getSelectedAddress();
    bloc.fetchCartDetails(widget.customerId);
  }

  checkConnectivity() async{
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }

  getSelectedAddress() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString("add");
      addressId = prefs.getString("add_id");
      salesId = prefs.getString("sales_id");
      customerName = prefs.getString("customer_name");

    });
    print("address shares $address $addressId");
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
    for(int i=0 ; i<price.length; i++){
      price[i].dispose();
      qty[i].dispose();
    }
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: (){
              Navigator.of(context).pop();
            },),
            title: Text(
              "Your Basket",
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: _body(),
          //bottomNavigationBar: _checkoutCard(),
        ));
  }


  Widget _body(){
    return StreamBuilder<CartModel>(
        stream: bloc.newCartStream,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50, child: CircularProgressIndicator(),));
          }
          if (s.hasError) {
            print("as3 error");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("Error Loading Data",),);
          }
          if (s.data.data == null) {
            print("as3 empty");
            return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("No Products Found",),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: DefaultButton(text: "Start Shopping",press: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => ProductHomePage(customerId: widget.customerId, customerName: widget.customerName, salesId: widget.salesId,)), (route) => false);
                    },),
                  )
                ],
              ),);
          }
          print("object length ${s.data.data.length}");
          for(int i=0; i< s.data.data.length; i++){
            price.add(TextEditingController());
            qty.add(TextEditingController());
            _status.add(true);
          }

          return RefreshIndicator(
            onRefresh: (){
              return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerCartPage(customerId: widget.customerId, customerName: widget.customerName, salesId: widget.salesId,)), (route) => false);
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  for(int i=0; i<s.data.data.length;i++)
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Dismissible(
                            key: Key(s.data.data[i].productId),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) {
                              print("object cart length ${s.data.data.length}");
                              removeCart(s.data.data[i].productId);
                            },
                            background: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFE6E6),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Spacer(),
                                  SvgPicture.asset("assets/icons/Trash.svg"),
                                ],
                              ),
                            ),
                            child: _cartCard(s.data.data[i],i))
                    ),
                  Align(alignment: FractionalOffset.bottomCenter,child: _checkoutCard()),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget _cartCard(Cart product, int i){
    price[i].text = product.customerprice;
    qty[i].text = product.quantity;

    amount.add(double.parse(product.customerprice));
    quantity.add(int.parse(product.quantity));

    totalAmount = totalAmount + (double.parse(product.customerprice)*int.parse(product.quantity));
    totalQty = totalQty +int.parse(product.quantity);
    print("object ${price[i].text} ${qty[i].text} samt $totalAmount qty $totalQty");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: SizedBox(
            width: 80,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Hero(
                tag: product.image,
                child: Image.network("${Connection.image}${product.image}",),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${product.productName}", style: TextStyle(color: Colors.black, fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Text("Price:",style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black))),
                  Flexible(
                    child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 2.0),
                        child: TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none
                          ),
                          controller: price[i],

                        )
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Text("Qty:",style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black))),
                  Flexible(
                    child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 2.0),
                        child: TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: InputBorder.none
                          ),
                          controller: qty[i],

                        )
                    ),
                  ),
                  SizedBox(width: 20,),
                  CustomStepper(
                      initialValue: int.parse(product.quantity), maxValue: 100, onChanged: (val){
                    setState(() {
                      changeQty(product.productId, val.toString());
                    });
                  }),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  changeQty(String id, String qty) async{
    var response = await http.post(Uri.parse(Connection.changeQty), body: {
      'secretkey':Connection.secretKey,
      'customer_id':"${widget.customerId}",
      'product_id' :"$id",
      'newQty':"$qty"
    });

    var results = json.decode(response.body);
    // pr.hide();
    if (results['status'] == true) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerCartPage(customerId: widget.customerId, customerName: widget.customerName, salesId: widget.salesId,)), (route) => false);
    } else {
      Alerts.showAlertAndBack(context, 'Failed', 'Failed to change quantity. Please contact sales person.');
    }
  }

  removeCart(String productId) async{
    await Hive.openBox(Connection.cartList);
    Box box = Hive.box(Connection.cartList);
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    var response = await http.post(Uri.parse(Connection.removeCart), body: {
      'secretkey':Connection.secretKey,
      'customer_id':widget.customerId,
      "product_id":productId,
    });
    var results = json.decode(response.body);
    pr.hide();
    if (results['status'] == true) {
      box.delete(productId);
      final snackBar = SnackBar(content: Text('Removed from Basket Successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerCartPage(customerId: widget.customerId, customerName: widget.customerName, salesId: widget.salesId,)), (route) => false);
    } else {
      Alerts.showAlertAndBack(context, 'Failed', 'Failed to place order. Please try again later.');
    }
  }

  Widget _checkoutCard(){
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 2, top: 10, bottom: 10, left: 10),
              child: Text("Customer Name: ${widget.customerName}"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 10,),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  //height: 40,
                  alignment: Alignment.centerLeft,
                  child: address == null ? Text("Address:\nNo address selected", textAlign: TextAlign.start,) : Text("Address: $address", textAlign: TextAlign.start, style: TextStyle(fontSize: 12),),
                ),
                address == null ? DefaultButtonSmall(
                  text: "Select Address",
                  press: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerAddressViewPage(customerId: widget.customerId,customerName: widget.customerName,page: "cart", )));
                  },
                ) :
                DefaultButtonSmall(
                  text: "Change Address",
                  press: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerAddressViewPage(customerId: widget.customerId,customerName: widget.customerName,page: "cart", )));
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 2, top: 10, bottom: 10, left: 10),
              child: Text("Total Quantity: $totalQty",style: TextStyle(fontSize: 13),),
            ),
            Padding(
              padding: EdgeInsets.only(right: 2, top: 10, bottom: 10,left: 10),
              child: Text("Total Amount: $totalAmount",style: TextStyle(fontSize: 13),),
            ),
            DefaultButton(
              text: "Place Order Now",
              press: () {
                if(address == null){
                  final snackBar = SnackBar(content: Text('Please Select Delivery Address'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  Alerts.showAlertCheckOut(context, totalAmount.toString(), totalQty.toString(), widget.customerId, addressId, widget.customerName, widget.salesId);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
