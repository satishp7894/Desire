import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:http/http.dart' as http;
import 'package:desire_users/bloc/product_bloc.dart';
import 'package:desire_users/models/cart_model.dart';
import 'package:desire_users/models/product_model.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'product_detail_page.dart';

class ProductSearchPage extends StatefulWidget {

  final String search;
  final String customerId;

  ProductSearchPage({@required this.search,this.customerId});

  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {

  final searchBloc = ProductBloc();
  final accBloc = ProductBloc();

  bool fav = true;
  SharedPreferences prefs;
  TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    searchBloc.fetchSearchProduct(widget.search,widget.customerId);
    accBloc.fetchSearchAccessories(widget.search,widget.customerId);
    searchController = TextEditingController(text: widget.search);
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
    searchBloc.dispose();
  }

  int orderCount = 0;
  String id;
  getCarCount() async{
    // ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
    //   isDismissible: false,);
    // pr.style(message: 'Please wait for count...',
    //   progressWidget: Center(child: CircularProgressIndicator()),);
    // pr.show();

    prefs =await SharedPreferences.getInstance();
    id = prefs.getString("customer_id");
    print("object $id");

    var response = await http.post(Uri.parse(Connection.cartDetails ), body: {
      "secretkey" : Connection.secretKey,
      "customer_id" : id
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
      onRefresh: () {
        return Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => ProductSearchPage(search: widget.search,customerId: widget.customerId)));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Image.asset("assets/images/logo.png",height: 30,),
            centerTitle: true,
            elevation: 0,
            backgroundColor:kSecondaryColor.withOpacity(0),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Container(
                child: _searchField(),
              ),
            ),
          ),
          body: _body(),
        ),
      ),
    );
  }

  Widget _body(){
    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        SizedBox(height: 10),
        _searches(),
      ],
    );
  }



  Widget _searchField(){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: searchController,
        textInputAction: TextInputAction.search,
        onEditingComplete: (){
          print(searchController.text);
          Navigator.push(context, MaterialPageRoute(builder: (c) => ProductSearchPage(search: searchController.text,)));
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Search product",
            prefixIcon: Icon(Icons.search,color: kPrimaryColor,)),
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
                height: 22,
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

  Widget _searches(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Products",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        StreamBuilder<ProductModel>(
            stream: searchBloc.searchProductStream,
            builder: (c, s) {
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
                  child: Text("No Products Found",),);
              }
              print("object of s ${s.data.message}");
              return StaggeredGridView.countBuilder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(15),
                crossAxisCount:4,
                itemCount: s.data.product.length,
                itemBuilder: (BuildContext context, int index) => GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => ProductDetailPage(product: s.data.product[index], page: "search", snapshot: s.data.product,status: true, orderCount: orderCount,)));
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
                          child: Image.network("${s.data.imagepath}${s.data.product[index].image[0]}",),
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
            }
        ),
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Accessories",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 10),
        StreamBuilder<ProductModel>(
            stream: accBloc.searchAccessoriesStream,
            builder: (c, s) {
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
              } else
              if (s.data.product == null) {
                print("as3 empty");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("No Accessory Found",),);
              }
              if(s.data.status == false){
                print("as3 empty");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("No Accessory Found",),);
              }
              print("object of s ${s.data.message}");
              return StaggeredGridView.countBuilder(
                shrinkWrap: true,
                padding: EdgeInsets.all(15),
                crossAxisCount:4,
                itemCount: s.data.product.length,
                itemBuilder: (BuildContext context, int index) => GestureDetector(
                  onTap: (){
                    //Navigator.push(context, MaterialPageRoute(builder: (c) => ProductDetailPage(product: s.data.product[index], page: "search", snapshot: s.data.product,)));
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
                          tag: s.data.product[index].image.length,
                          child: Image.network("${s.data.imagepath}${s.data.product[index].image}",),
                        ),
                      ),
                      Text(
                        s.data.product[index].productName,
                        style: TextStyle(color: Colors.black),
                        maxLines: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹${s.data.product[index].customerprice}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                staggeredTileBuilder: (int index) =>
                    StaggeredTile.fit(2),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              );
            }
        ),
      ],
    );
  }

}
