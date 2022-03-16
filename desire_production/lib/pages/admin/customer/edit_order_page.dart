
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/product_orderId_bloc.dart';
import 'package:desire_production/model/product_list_order_model.dart';
import 'package:desire_production/pages/admin/products/product_details_click_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';

import 'customer_order_details_page.dart';

class EditOrderPage extends StatefulWidget {

  final String customerId;
  final String customerName;
  final String orderId;
  final String orderName;
  EditOrderPage({@required this.customerId, @required this.customerName,  @required this.orderId, @required this.orderName,});

  @override
  _EditOrderPageState createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderPage> with Validator{

  final bloc = ProductOrderIDBloc();
  List<bool> _status = [];
  List<TextEditingController> price;
  List<TextEditingController> qty;
  List<double> amount = [];
  List<double> salesPrice = [];
  List<int> quantity = [];
  double totalAmount = 0;
  int totalQty = 0;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    price = [];
    qty = [];
    bloc.fetchProductByOrderId(widget.orderId);
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

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
    for(int i=0 ; i<price.length; i++){
      price[i].dispose();
      qty[i].dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
       return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerOrderDetailPage(customerName: widget.customerName,customerId: widget.customerId)), (route) => false);
      },
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
                Navigator.of(context).pop();
                },),
              title: Text("Edit Customer Orders", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
              centerTitle: true,
            ),
            body: _body(),
            //bottomNavigationBar: _checkoutCard(),
          )),
    );
  }

  Widget _body(){
    return StreamBuilder<ProductListOrderModel>(
        stream: bloc.productOrderIdStream,
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
          if (s.data.products == null) {
            print("as3 empty");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("No Products Found",),);
          }
          print("object length ${s.data.products.length}");
          for(int i=0; i< s.data.products.length; i++){
            price.add(TextEditingController());
            qty.add(TextEditingController());
            _status.add(true);
            salesPrice.add(double.parse(s.data.products[i].salesmanprice));
          }

          return RefreshIndicator(
            onRefresh: (){
              return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => EditOrderPage(customerId: widget.customerId, customerName: widget.customerName,orderName: widget.orderName,orderId: widget.orderId,)), (route) => false);
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Text("Order Number: ${widget.orderName}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),),
                  ),
                  for(int i=0; i<s.data.products.length;i++)
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (builder) => ProductDetailsClickPage(productId: s.data.products[i].productId,)));
                          },
                            child: _cartCard(s.data.products[i],i))
                    ),
                  _checkoutCard(),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget _cartCard(Product product, int i){

    price[i].text = product.customerprice;
    qty[i].text = product.productQuantity;

    amount.add(double.parse(product.customerprice));
    quantity.add(int.parse(product.productQuantity));

    totalAmount = totalAmount + (double.parse(product.customerprice)*int.parse(product.productQuantity));
    totalQty = totalQty +int.parse(product.productQuantity);
    print("object ${price[i].text} ${qty[i].text} samt $totalAmount qty $totalQty");

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: SizedBox(
            width: 80,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Hero(
                  tag: product.image,
                  child: Image.network("${Connection.image}${product.image}",),
                ),
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
              Text("Product Name: ${product.productName}",style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Text("Price:",style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black))),
                  Flexible(
                    child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5,),
                        child: TextFormField(
                          enableInteractiveSelection: false,
                          keyboardType: TextInputType.number,
                          validator: validateEmail,
                          decoration: InputDecoration(
                            border: InputBorder.none
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: price[i],
                          enabled: true,
                          autofocus: true,
                        )
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Text("Quantity:",style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black))),
                  Flexible(
                    child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: TextFormField(
                          enableInteractiveSelection: false,
                          keyboardType: TextInputType.number,
                          validator: validateEmail,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: InputDecoration(
                              border: InputBorder.none
                          ),
                          controller: qty[i],
                          enabled: true,
                          autofocus: true,

                        )
                    ),
                  ),
                ],
              ),
             // !_status[i] ? _getActionButtons(i, product.productId) : new Container(),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _getEditIcon(i, product.productId, product.productName),
            SizedBox(height: 20,),
            _getEditIcon1(i, product.productId, product.salesmanprice, product.productQuantity),
          ],
        ),
      ],
    );
  }

  Widget _getEditIcon(int i,String productId, String proName) {
    return GestureDetector(
      child: new CircleAvatar(
        backgroundColor: kPrimaryColor,
        radius: 14.0,
        child: new Icon(
          Icons.check,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        // setState(() {
        //   totalAmount = 0;
        //   totalQty = 0;
        //   _status[i] = false;
        // });
        if(price[i].text == "0" || qty[i].text == "0"){
          Alerts.showAlertAndBack(context, "Invalid value", "Value cannot be 0");
        } else if(double.parse(price[i].text) < salesPrice[i]){
          Alerts.showAlertEditProduct(context, "Invalid Amount", "Amount cannot be less than ${salesPrice[i]}",productId,proName,widget.orderId,widget.orderName,qty[i].text,price[i].text,widget.customerName,widget.customerId);
        } else{
          print("object before edit $totalAmount $totalQty ${price[i].text} ${qty[i].text} ${quantity[i]} ${amount[i]}");
          totalQty = totalQty - quantity[i] + int.parse(qty[i].text);
          totalAmount = totalAmount - (amount[i]*quantity[i]) + (double.parse(price[i].text)*int.parse(qty[i].text));
          print("object new edited amount qty: $totalQty amt: $totalAmount $proName");
          orderUpdated(widget.orderId,productId,int.parse(qty[i].text),double.parse(price[i].text));
        }

      },
    );
  }

  Widget _getEditIcon1(int i,String productId, String amt, String pQty) {
    return GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.close,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        price[i].text = amt;
        qty[i].text = pQty;
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
  }

  // Widget _getActionButtons(int i, String productId) {
  //
  //   return Padding(
  //     padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 20.0),
  //     child: new Row(
  //       mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: <Widget>[
  //         Expanded(
  //           child: Padding(
  //             padding: EdgeInsets.only(right: 10.0),
  //             child: Container(
  //                 child: DefaultButtonSuccess(
  //                   text: "Save",
  //                   press: (){
  //                     if(price[i].text == "0" || qty[i].text == "0"){
  //                       Alerts.showAlertAndBack(context, "Invalid value", "Value cannot be 0");
  //                     } else if(double.parse(price[i].text) < salesPrice[i]){
  //                       Alerts.showAlertAndBack(context, "Invalid Amount", "Amount cannot be less than ${salesPrice[i]}");
  //                     } else{
  //                       print("object before edit $totalAmount $totalQty ${price[i].text} ${qty[i].text} ${quantity[i]} ${amount[i]}");
  //                       totalQty = totalQty - quantity[i] + int.parse(qty[i].text);
  //                       totalAmount = totalAmount - (amount[i]*quantity[i]) + (double.parse(price[i].text)*int.parse(qty[i].text));
  //                       print("object new edited amount qty: $totalQty amt: $totalAmount");
  //                       orderUpdated(widget.orderId,productId,int.parse(qty[i].text),double.parse(price[i].text));
  //                     }
  //
  //                   },
  //                 )
  //             ),),),
  //         Expanded(
  //           child: Padding(
  //             padding: EdgeInsets.only(left: 10.0),
  //             child: Container(
  //               child: DefaultButtonCancel(
  //                 text: "Cancel",
  //                 press: (){
  //                   setState(() {
  //                     _status[i] = true;
  //                     FocusScope.of(context).requestFocus(new FocusNode());
  //                   });
  //                 },
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _checkoutCard(){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        //height: 100,
        alignment: Alignment.center,
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
                padding: EdgeInsets.only(right: 2, top: 10, bottom: 10),
                child: Text("Total Quantity $totalQty"),
              ),
              Padding(
                padding: EdgeInsets.only(right: 2, top: 10, bottom: 10),
                child: Text("Total Amount $totalAmount"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  orderUpdated(String orderId, String productId, int productQty, double productAmount) async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    print("object request for edit $orderId $productId $productQty $productAmount $totalQty $totalAmount");

    var response = await http.post(Uri.parse(Connection.editProduct), body: {
      'secretkey':Connection.secretKey,
      'order_id':"$orderId",
      'productid' :"$productId",
      'product_quantity':"$productQty",
      'product_amount':"$productAmount",
      'total_quantity':"$totalQty",
      'total_amount':"$totalAmount"
    });

    var results = json.decode(response.body);
    pr.hide();
    if (results['status'] == true) {
      amount = [];
      quantity = [];

      totalAmount = 0;
      totalQty = 0;
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => EditOrderPage(customerName: widget.customerName,customerId: widget.customerId,orderId: widget.orderId,orderName: widget.orderName,)), (route) => false);
    } else {
      Alerts.showAlertAndBack(context, 'Failed', 'Failed to change quantity. Please contact sales person.');
    }
  }

}
