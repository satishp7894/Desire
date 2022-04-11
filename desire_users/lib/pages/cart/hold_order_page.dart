import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/hold_order_bloc.dart';
import 'package:desire_users/bloc/pending_order_list_bloc.dart';
import 'package:desire_users/models/hold_orders_model.dart';
import 'package:desire_users/models/pending_order_list_model.dart';
import 'package:desire_users/pages/home/customer_price_list.dart';
import 'package:desire_users/sales/pages/orders/orderDetailsByIdPage.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';

class HoldOrderPage extends StatefulWidget {
  final customerId;

  const HoldOrderPage({Key key, this.customerId}) : super(key: key);

  @override
  _HoldOrderPageState createState() => _HoldOrderPageState();
}

class _HoldOrderPageState extends State<HoldOrderPage> {
  HoldOrderBloc holdOrderBloc = HoldOrderBloc();
  AsyncSnapshot<HoldOrderModel> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();
    holdOrderBloc.fetchHoldOrder(widget.customerId);
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
    holdOrderBloc.dispose();
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
                    builder: (builder) => HoldOrderPage(
                        customerId: widget.customerId)));
          },
          child: _body(),
        ));
  }

  Widget _body() {
    return StreamBuilder<HoldOrderModel>(
        stream: holdOrderBloc.holdOrderStream,
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
                            holdOrder:
                        asyncSnapshot.data.holdOrder[index],
                        customerId: widget.customerId,
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
  final customerId;

  const ModelListTile({Key key, this.holdOrder, this.customerId})
      : super(key: key);

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
                      ],
                    ),
                    Column(
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
                      ],
                    ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          var widget;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetailsByIdPage(
                                    customerId: customerId,
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
                              child: Text("View Order Details",
                                  style: TextStyle(
                                      color: kBlackColor, fontSize: 14)),
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
}
