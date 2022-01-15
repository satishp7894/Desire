import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/hold_order_bloc.dart';
import 'package:desire_users/bloc/pending_order_list_bloc.dart';
import 'package:desire_users/models/hold_orders_model.dart';
import 'package:desire_users/models/pending_order_list_model.dart';
import 'package:desire_users/pages/home/customer_price_list.dart';
import 'package:desire_users/sales/bloc/hold_order_list_bloc.dart';
import 'package:desire_users/sales/bloc/pending_orders_sales_bloc.dart';
import 'package:desire_users/sales/pages/orders/orderDetailsByIdPage.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HoldOrderListPage extends StatefulWidget {
  final salesId;

  const HoldOrderListPage({Key key, this.salesId}) : super(key: key);

  @override
  _HoldOrderListPageState createState() => _HoldOrderListPageState();
}

class _HoldOrderListPageState extends State<HoldOrderListPage> {
  HoldOrderListBloc holdorderbloc = HoldOrderListBloc();
  AsyncSnapshot<HoldOrderModel> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();

    holdorderbloc.fetchHoldOrder(widget.salesId);
  }

  checkConnectivity() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(
          context, "No Internet Connection", "Please check your internet");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    holdorderbloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          iconTheme: IconThemeData(color: kBlackColor),
          title: Text("Hold Orders"),
          titleTextStyle: TextStyle(
              color: kBlackColor, fontSize: 18, fontWeight: FontWeight.bold),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: () {
            return Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (builder) =>
                        HoldOrderListPage(salesId: widget.salesId)));
          },
          child: _body(),
        ));
  }

  Widget _body() {
    return StreamBuilder<HoldOrderModel>(
        stream: holdorderbloc.holdOrderStream,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(
                height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50,
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ));
          } else if (s.hasError) {
            print("as3 error");
            print(s.error);
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: SelectableText(
                "Error Loading Data ${s.error}",
              ),
            );
          } else if (s.data.toString().isEmpty) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          } else {
            asyncSnapshot = s;
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ...List.generate(
                      asyncSnapshot.data.holdOrder.length,
                      (index) => ModelListTile(
                            holdOrder: asyncSnapshot.data.holdOrder[index],
                        salesId:widget.salesId, bloc:holdorderbloc
                          ))
                ],
              ),
            );
          }
        });
  }
}

class ModelListTile extends StatelessWidget {
  final HoldOrder holdOrder;
  final salesId;
  final HoldOrderListBloc bloc;

  const ModelListTile({Key key, this.holdOrder,this.salesId, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        color: kWhiteColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order Number",
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text("Total Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kSecondaryColor,
                                fontSize: 14)),
                        Text("Total Quantity",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kSecondaryColor,
                                fontSize: 14)),
                        Text("Customer Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kSecondaryColor,
                                fontSize: 14)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(" : ",
                            style: TextStyle(
                                color: kBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text(" : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackColor,
                                fontSize: 14)),
                        Text(" : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackColor,
                                fontSize: 14)),
                        Text(" : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackColor,
                                fontSize: 14)),
                      ],
                    ),
                    Flexible(child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${holdOrder.orderNumber}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackColor,
                                fontSize: 14)),
                        Text("₹.${holdOrder.orderAmount} /-",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackColor,
                                fontSize: 14)),
                        Text("${holdOrder.totalOrderQuantity}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackColor,
                                fontSize: 14)),
                        Text("${holdOrder.customerName}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackColor,
                                fontSize: 14)),
                      ],
                    ),)
                  ],
                ),
                SizedBox(
                  height: 20,
                  child: Divider(
                    color: Colors.grey,
                    height: 0.0,
                    thickness: 0.5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          unholdOrder(holdOrder.orderId, context,bloc,salesId );
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: kPrimaryColor)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Unhold Order",
                                  style: TextStyle(
                                      color: kBlackColor, fontSize: 14, fontWeight: FontWeight.bold)),
                            ))),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetailsByIdPage(
                                    customerId: holdOrder.customerId,
                                    orderId: holdOrder.orderId,
                                    orderName: holdOrder.orderNumber,
                                  )));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: kPrimaryColor)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Order Details",
                                  style: TextStyle(
                                      color: kBlackColor, fontSize: 14, fontWeight: FontWeight.bold)),
                            )))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void unholdOrder(String orderId, BuildContext context, HoldOrderListBloc bloc, salesid) async {
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
    var response = await http.post(
        Uri.parse(
            "http://loccon.in/desiremoulding/api/SalesApiController/unHoldCustomersOrder"),
        body: {
          'secretkey': Connection.secretKey,
          'order_id': orderId,
        });
    var results = json.decode(response.body);
    pr.hide();
    if (results['status'] == true) {
      final snackBar =
      SnackBar(content: Text(results['message']));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      bloc.fetchHoldOrder(salesId);
    } else {
      Alerts.showAlertAndBack(
          context, 'Failed', 'Failed to place order. Please try again later.');
    }
  }
}
