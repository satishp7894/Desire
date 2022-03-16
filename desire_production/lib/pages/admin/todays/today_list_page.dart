import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/todays_list_bloc.dart';
import 'package:desire_production/model/todays_list_model.dart';
import 'package:desire_production/pages/admin/todays/todays_order_details_page.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class TodayListPage extends StatefulWidget {
  @override
  _TodayListPageState createState() => _TodayListPageState();
}

class _TodayListPageState extends State<TodayListPage> {
  TodayListBloc todaylistbloc = TodayListBloc();
  AsyncSnapshot<TodaysListModel> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();
    todaylistbloc.fetchTodayList();
  }

  checkConnectivity() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
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
    todaylistbloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Today's",
          style: TextStyle(
              color: kBlackColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder<TodaysListModel>(
        stream: todaylistbloc.todaysStream,
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
          } else if (s.data.todayOrder != null &&
              s.data.todayOrder.length == 0 &&
              s.data.todayDispatchInvoice != null &&
              s.data.todayDispatchInvoice.length == 0) {
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
            return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        height: 200,
                        width: 250,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return TodayOrderDetailsPage(
                                screenType: "oDetail",
                              );
                            }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0,
                                    spreadRadius: 2,
                                  )
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.today,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text("Today's Order",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kWhite,
                                        fontSize: 20)),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text("Order",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kWhite)),
                                          Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                                  asyncSnapshot
                                                              .data
                                                              .todayOrder[0]
                                                              .totalOrder !=
                                                          null
                                                      ? asyncSnapshot
                                                          .data
                                                          .todayOrder[0]
                                                          .totalOrder
                                                      : "",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: kWhite)))
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text("Qty",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kWhite)),
                                          Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                                  asyncSnapshot
                                                              .data
                                                              .todayOrder[0]
                                                              .totalOrderQty !=
                                                          null
                                                      ? asyncSnapshot
                                                          .data
                                                          .todayOrder[0]
                                                          .totalOrderQty
                                                      : "",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: kWhite)))
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text("Amount",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kWhite)),
                                          Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                                  asyncSnapshot
                                                              .data
                                                              .todayOrder[0]
                                                              .totalOrderAmount !=
                                                          null
                                                      ? asyncSnapshot
                                                          .data
                                                          .todayOrder[0]
                                                          .totalOrderAmount
                                                      : "",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: kWhite)))
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        height: 200,
                        width: 250,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return TodayOrderDetailsPage(
                                screenType: "oDispatch",
                              );
                            }));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0,
                                    spreadRadius: 2,
                                  )
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.today,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                SizedBox(height: 10),
                                Text("Today's Dispatch Invoice",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: kWhite,
                                        fontSize: 20)),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Text("Invoice",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kWhite)),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            child: Text(
                                                asyncSnapshot
                                                            .data
                                                            .todayDispatchInvoice[
                                                                0]
                                                            .totalDispatchInvoice !=
                                                        null
                                                    ? asyncSnapshot
                                                        .data
                                                        .todayDispatchInvoice[0]
                                                        .totalDispatchInvoice
                                                    : "",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: kWhite)),
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text("Amount",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kWhite)),
                                          Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                                  asyncSnapshot
                                                              .data
                                                              .todayDispatchInvoice[
                                                                  0]
                                                              .totalDispatchInvoiceAmount !=
                                                          null
                                                      ? asyncSnapshot
                                                          .data
                                                          .todayDispatchInvoice[
                                                              0]
                                                          .totalDispatchInvoiceAmount
                                                      : "0",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: kWhite)))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ]));
          }
        });
  }
}
