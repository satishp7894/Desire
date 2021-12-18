import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/product_bloc.dart';
import 'package:desire_users/models/cart_model.dart';
import 'package:desire_users/models/product_model.dart';
import 'package:desire_users/pages/cart/cart_page.dart';
import 'package:desire_users/pages/home/home_page.dart';
import 'package:desire_users/pages/product/product_detail_page.dart';
import 'package:desire_users/services/check_block.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/coustom_bottom_nav_bar.dart';
import 'package:desire_users/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class ProductCategoryPage extends StatefulWidget {

  final String id;
  final String customerId;
  final String name;
  final bool status;


  ProductCategoryPage({@required this.id, @required this.name, @required this.status,this.customerId});

  @override
  _ProductCategoryPageState createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {

  final bloc = ProductBloc();

  bool refresh = false;

  SharedPreferences prefs;


  @override
  void initState() {
    super.initState();
    checkConnectivity();
    if(widget.status)
    {
      getDetailsB();
    }
    print("object product id ${widget.id}");
    bloc.fetchCategoryWiseProduct(widget.id,widget.customerId);
    getCarCount();
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
    bloc.dispose();
  }

  getDetailsB() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mob = prefs.getString("Mobile_no");
    print("object $mob");
    final checkBloc = CheckBlocked(mob);
    checkBloc.getDetailsCategory(context,widget.id,widget.name);
  }

  int orderCount = 0;
  String customerId;
  getCarCount() async{
    // ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
    //   isDismissible: false,);
    // pr.style(message: 'Please wait for count...',
    //   progressWidget: Center(child: CircularProgressIndicator()),);
    // pr.show();

    prefs =await SharedPreferences.getInstance();
    customerId = prefs.getString("customer_id");
    print("object $customerId");

    var response = await http.post(Uri.parse(Connection.cartDetails ), body: {
      "secretkey" : Connection.secretKey,
      "customer_id" : customerId
    });

    var result = json.decode(response.body);
    //pr.hide();
    print("object value of order count $result");
    CartModel cartModel;
    cartModel = CartModel.fromJson(result);
    print("order model length $result ${cartModel.data}");

    setState(() {
      cartModel.data == null ? orderCount = 0 : orderCount = cartModel.data.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () {
        refresh = true;
        return Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => ProductCategoryPage(id:  widget.id, name: widget.name,status: true,)));
      },
      child: WillPopScope(
        onWillPop: () {
          if(refresh){
            return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomePage(status: true,)), (route) => false);
        } else {
            Navigator.of(context).pop();
           return null;
          }
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("${widget.name}"),
              centerTitle: true,
              elevation: 0,
              leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: (){
                refresh ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomePage(status: true,)), (route) => false) : Navigator.of(context).pop();
                },),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 8),
                  child: iconBtnWithCounter(
                      "assets/icons/Cart Icon.svg",
                      orderCount,
                          ()async{

                        Navigator.push(context, MaterialPageRoute(builder: (builder) => CartPage(id: customerId, status: true,orderCount: orderCount)));
                      }),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 10, bottom: 5, right: 20),
                //   child: iconBtnWithCounter("assets/icons/Bell.svg",3,() {},),
                // ),
              ],
              backgroundColor:kSecondaryColor.withOpacity(0),
              titleTextStyle: headingStyle,
              textTheme: Theme.of(context).textTheme,
            ),
            body: _body(),
          ),
        ),
      ),
    );
  }

  Widget iconBtnWithCounter(String svgSrc, int numOfItem, Function() press,){
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: press,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(svgSrc),
          ),
          if (numOfItem != 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: Color(0xFFFF4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    "$numOfItem",
                    style: TextStyle(
                      fontSize: 10,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }


  Widget _body(){
    return StreamBuilder<ProductModel>(
        stream: bloc.categoryWiseProductStream,
        builder: (c,s){

          if (s.connectionState != ConnectionState.active) {
            print("all connection ${s.connectionState}");
            return Container(height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50, child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),));
          }
          print("object of s ${s.connectionState}");
          if (s.hasError) {
            print("as3 error");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("Error Loading Data",),);
          }
          if (s.data.product == null) {
            print("as3 empty");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("No Data Found",),);
          }
          print("object of s ${s.data.message}");

          return StaggeredGridView.countBuilder(
            padding: EdgeInsets.all(15),
            crossAxisCount:4,
            itemCount: s.data.product.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (c) => ProductDetailPage(product: s.data.product[index], page: "home", snapshot: s.data.product,status: true, orderCount: orderCount,)));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Hero(
                      tag: s.data.product[index].image[0]+"$index",
                      child: Image.network("http://loccon.in/desiremoulding/upload/Image/Product/${s.data.product[index].image[0]}",),
                    ),
                  ),
                  Text(
                    s.data.product[index].productName.toUpperCase(),
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MRP: " "₹${s.data.product[index].customerprice}",
                        style: TextStyle(
                          decoration:   s.data.product[index].customernewprice == "" ?TextDecoration.none: TextDecoration.lineThrough,
                          fontSize: s.data.product[index].customernewprice == "" ? 14:12,
                          fontWeight: FontWeight.w600,
                          color: s.data.product[index].customernewprice == "" ? kPrimaryColor :kSecondaryColor,
                        ),
                      ),
                      Text(
                        s.data.product[index].customernewprice =="" ? "": "Your Price "+"₹${s.data.product[index].customernewprice}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:kPrimaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            staggeredTileBuilder: (int index) =>
                StaggeredTile.fit(2),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          );
        });
  }

}
