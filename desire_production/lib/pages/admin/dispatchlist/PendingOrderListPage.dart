import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/pending_orders_sales_bloc.dart';
import 'package:desire_production/model/pending_order_list_model.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

import 'orderDetailsByIdPage.dart';

class PendingOrderListPage extends StatefulWidget {

  const PendingOrderListPage({Key key}) : super(key: key);

  @override
  _PendingOrderListPageState createState() => _PendingOrderListPageState();
}

class _PendingOrderListPageState extends State<PendingOrderListPage> {
  PendingOrderSalesBloc pendinOrderlistBloc = PendingOrderSalesBloc();
  AsyncSnapshot<PendingOrderListModel> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();

    pendinOrderlistBloc.fetchPendingOrder();
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
    pendinOrderlistBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhite,
          iconTheme: IconThemeData(color: kBlackColor),
          title: Text("Pending Orders"),
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
                        PendingOrderListPage()));
          },
          child: _body(),
        ));
  }

  Widget _body() {
    return StreamBuilder<PendingOrderListModel>(
        stream: pendinOrderlistBloc.pendingOrderStream,
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
          }
          else if (s.data.pendingOrder.length == 0) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          }else {
            asyncSnapshot = s;
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ...List.generate(
                      asyncSnapshot.data.pendingOrder.length,
                      (index) => ModelListTile(
                            pendingOrder:
                                asyncSnapshot.data.pendingOrder[index],
                          ))
                ],
              ),
            );
          }
        });
  }
}

class ModelListTile extends StatelessWidget {
  final PendingOrder pendingOrder;

  const ModelListTile({Key key, this.pendingOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        color: kWhite,
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
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${pendingOrder.orderNumber}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackColor,
                                  fontSize: 14)),
                          Text("₹.${pendingOrder.orderAmount} /-",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackColor,
                                  fontSize: 14)),
                          Text("${pendingOrder.totalOrderQuantity}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackColor,
                                  fontSize: 14)),
                          Text("${pendingOrder.customerName}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: kBlackColor,
                                  fontSize: 14)),
                        ],
                      ),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetailsByIdPage(
                                        customerId: pendingOrder.customerId,
                                        orderId: pendingOrder.orderId,
                                        orderName: pendingOrder.orderNumber,
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
