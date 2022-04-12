import 'dart:convert';

import 'package:desire_users/bloc/product_detail_bloc.dart';
import 'package:desire_users/models/product_details_model.dart';
import 'package:desire_users/sales/pages/customerCart/customer_cart_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/custom_stepper.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SalesProductFromModelDetailPage extends StatefulWidget {
  final productId;
  final customerId;
  final customerName;

  const SalesProductFromModelDetailPage(
      {Key key, this.customerId, this.productId, this.customerName})
      : super(key: key);

  @override
  _SalesProductFromModelDetailPageState createState() =>
      _SalesProductFromModelDetailPageState();
}

class _SalesProductFromModelDetailPageState
    extends State<SalesProductFromModelDetailPage> {
  final ProductDetailBloc productDetailBloc = ProductDetailBloc();
  int totQty = 1;
  int orderCount = 0;
  SharedPreferences prefs;

  String salesId;

  String salesEmail, salesName;

  getDetails() async {
    prefs = await SharedPreferences.getInstance();
    salesId = prefs.getString("sales_id");
    salesEmail = prefs.getString("sales_email");
    salesName = prefs.getString("sales_name");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productDetailBloc.fetchDetailProduct(widget.productId, widget.customerId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    productDetailBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: kWhiteColor,
        elevation: 0,
      ),
      body: body(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        icon: Icon(
          Icons.shopping_cart,
          color: kWhiteColor,
        ),
        label: Text("Add To Cart"),
        onPressed: () {
          addToCartApi();
        },
      ),
      // bottomNavigationBar: bottomNavigation(),
    );
  }

  Widget body() {
    return StreamBuilder<ProductDetailModel>(
        stream: productDetailBloc.newProductDetailStream,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.active) {
            print("all connection ${s.connectionState}");
            return Center(
              heightFactor: 500,
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            );
          }
          print("object of s ${s.connectionState}");
          if (s.hasError) {
            print("as3 error");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "Error Loading Data",
              ),
            );
          }
          if (s.data.toString().isEmpty) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          } else
            return ListView.builder(
                shrinkWrap: true,
                itemCount: s.data.data.length,
                itemBuilder: (c, i) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10),
                          child: Text(
                            s.data.data[i].productName,
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                              EdgeInsets.only(left: 10, right: 20, top: 10),
                          child: Text(
                            "MRP: ₹${s.data.data[i].customerprice}/stick",
                            maxLines: 3,
                            style: TextStyle(
                              color: s.data.data[i].customernewprice == ""
                                  ? kPrimaryColor
                                  : kSecondaryColor,
                              decoration: s.data.data[i].customernewprice == ""
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                              fontSize: s.data.data[i].customernewprice == ""
                                  ? 20
                                  : 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      s.data.data[i].customernewprice == ""
                          ? Container()
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 20, bottom: 10),
                                child: Text(
                                  "Your Price: ₹${s.data.data[i].customernewprice}/stick",
                                  maxLines: 3,
                                  style: appbarStyle,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                      Container(
                        height: 250,
                        child: Swiper(
                          scrollDirection: Axis.horizontal,
                          autoplay: true,
                          duration: 2000,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(
                              "${s.data.data[i].imagepath}" +
                                  "${s.data.data[i].image[index]}",
                              fit: BoxFit.contain,
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                            );
                          },
                          itemCount: s.data.data[i].image.length,
                        ),
                      ),
                      Divider(
                        thickness: 2,
                        color: kPrimaryColor,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 10),
                          alignment: Alignment.center,
                          child: Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 10),
                              child: detailWidget(
                                  "Stick Per Box", s.data.data[i].perBoxStick)),
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, top: 10),
                              child: detailWidget("Total Box Price",
                                  s.data.data[i].boxPrice.toString())),
                          Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                top: 10,
                              ),
                              child: detailWidget(
                                  "Category", s.data.data[i].category)),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: detailWidget(
                                    "Model No", s.data.data[i].modelNo)),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 10, bottom: 10),
                                child: detailWidget(
                                    "Dimension", s.data.data[i].dimensionSize)),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: kPrimaryColor)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  "${s.data.data[i].dimensionImagePath}" +
                                      "${s.data.data[i].dimensionImage}",
                                  height: 80,
                                  width: 80,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: CustomStepper(
                                  initialValue: 1,
                                  maxValue: 100,
                                  onChanged: (val) {
                                    setState(() {
                                      totQty = val;
                                    });
                                  }),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                });
        });
  }

  Widget detailWidget(String title, String data) {
    return Container(
      width: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: kSecondaryColor,
            ),
          ),
          Text(
            data,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget bottomNavigation() {
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        addToCartApi();
      },
      child: Container(
        color: kPrimaryColor,
        height: 50,
        child: Center(
          child: Text(
            "Add To Basket",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: kWhiteColor),
          ),
        ),
      ),
    ));
  }

  addToCartApi() async {
    print("cart object qty to be passed $totQty");
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),
    );
    pr.show();
    var response;
    response = await http.post(Uri.parse(Connection.addCart), body: {
      'secretkey': Connection.secretKey,
      'customer_id': widget.customerId,
      'product_id': widget.productId,
      'quantity': totQty.toString(),
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true) {
      final snackBar = SnackBar(
          content: Row(
        children: [
          Text('Added to Basket Successfully'),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (builder) => CustomerCartPage(
                              customerId: widget.customerId,
                              customerName: widget.customerName,
                            )));
              },
              child: Text(
                "View Cart",
                style: TextStyle(color: kPrimaryColor),
              ))
        ],
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>ProductDetailPage(product: widget.product, page: widget.page, snapshot: widget.snapshot,status: false, orderCount: widget.orderCount,)), (route) => false);
    } else {
      Alerts.showAlertAndBack(context, "User Not Found",
          "Please enter registered mobile no or email id");
    }
  }
}
