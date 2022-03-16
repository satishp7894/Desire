import 'dart:ui';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/product_orderId_bloc.dart';
import 'package:desire_production/model/product_list_order_model.dart';
import 'package:desire_production/pages/admin/customer/customer_order_details_page.dart';
import 'package:desire_production/pages/admin/customer/tracking_page_new.dart';
import 'package:desire_production/pages/admin/products/product_details_click_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {

  final String id;
  final String name;
  final String orderId;
  final String orderName;
  final bool status;
  final String totalAmount;
  final String totalQty;
  final int orderCount;
  const OrderDetailPage({@required this.id, @required this.orderId, @required this.orderName, @required this.status, @required this.totalAmount, @required this.totalQty, @required this.orderCount, @required this.name});

  @override
  _CustomerOrderDetailPageState createState() => _CustomerOrderDetailPageState();
}

class _CustomerOrderDetailPageState extends State<OrderDetailPage> {

  final bloc = ProductOrderIDBloc();

  @override
  void initState() {
    super.initState();
    checkConnectivity();
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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerOrderDetailPage(customerName: widget.name, customerId: widget.id,)), (route) => false);
      },
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Order Detail Page"),
              centerTitle: true,
              elevation: 0,
              backgroundColor:kSecondaryColor.withOpacity(0),
              titleTextStyle: headingStyle,
              textTheme: Theme.of(context).textTheme,
              leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerOrderDetailPage(customerName: widget.name, customerId: widget.id,)), (route) => false);
              },),
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

          return SingleChildScrollView(
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
                ListView.separated(
                    padding: EdgeInsets.all(10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: s.data.products.length,
                    itemBuilder: (c, i) {
                      return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (builder) => ProductDetailsClickPage(productId: s.data.products[i].productId)));
                          },
                          child: _cartCard(s.data.products[i],i));
                    },
                    separatorBuilder: (c, i) {
                      return Divider(indent: 20, color: Colors.grey.withOpacity(.8),);
                    }),
                //_checkoutCard(),
              ],
            ),
          );
        }
    );
  }

  Widget _cartCard(Product product, int i){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Product Name: ${product.productName}", style: TextStyle(color: Colors.black, fontSize: 14), textAlign: TextAlign.start,),
                  SizedBox(height: 5,),
                  Text("Product Price: ${product.customerprice}", style: TextStyle(color: Colors.black, fontSize: 14), textAlign: TextAlign.start,),
                  SizedBox(height: 5,),
                  Text("Product Quantity: ${product.productQuantity}", style: TextStyle(color: Colors.black, fontSize: 14), textAlign: TextAlign.start,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Deliver Status:",  textAlign: TextAlign.left , style: TextStyle(color: Colors.black, fontSize: 14)),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (builder) => TrackingPageNew(id: widget.id, orderId: widget.orderId, orderName: widget.orderName, status: true, totalQty: widget.totalAmount, totalAmount: widget.totalQty, trackId: product.orderDetailKey, product: product,)));
                          },
                          child: product.orderTrackingDetails.length > 15 ? Text("${product.orderTrackingDetails.replaceRange(18, 19, "\n")}", textAlign: TextAlign.left , style: TextStyle(color: kPrimaryColor, fontSize: 12),) :
                          Text("${product.orderTrackingDetails}", textAlign: TextAlign.left , style: TextStyle(color: kPrimaryColor, fontSize: 12),)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

}