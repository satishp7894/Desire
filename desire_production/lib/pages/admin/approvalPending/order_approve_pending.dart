import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/credit_pending_bloc.dart';
import 'package:desire_production/bloc/order_approve_pending_bloc.dart';
import 'package:desire_production/model/kyc_pending_list_model.dart';
import 'package:desire_production/model/order_approve_pending_model.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderApprovePending extends StatefulWidget {
  @override
  _OrderApprovePendingState createState() => _OrderApprovePendingState();
}

class _OrderApprovePendingState extends State<OrderApprovePending> {
  final orderBloc = OrderApprovePendingBloc();
  List<bool> status = [];
  TextEditingController searchView;
  bool search = false;
  List<CustomerOrderList> _searchResult = [];
  List<CustomerOrderList> customerList = [];

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    searchView = TextEditingController();
    orderBloc.fetchorderPendingList();
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
    super.dispose();
    searchView.dispose();
    orderBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Credit Pending List",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: _searchView(),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (builder) => OrderApprovePending()),
        );
      },
      child: StreamBuilder<OrderApprovePendingModel>(
          stream: orderBloc.ordeStream,
          builder: (context, s) {
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
            }
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
            }

            customerList = s.data.customerOrderList;
            print(searchView.text);

            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                child: Column(
                  children: [
                    searchView.text.length == 0
                        ? ListView.separated(
                            //padding: EdgeInsets.all(10),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            //reverse: true,
                            itemCount: customerList.length,
                            itemBuilder: (c, i) {
                              return GestureDetector(
                                onTap: () {},
                                child: Container(
                                  //padding: EdgeInsets.only(top: 10, bottom: 10),
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  alignment: Alignment.centerLeft,
                                  // decoration: BoxDecoration(
                                  //   //color: Color(0xFFF5F6F9),
                                  //   borderRadius: BorderRadius.circular(15),
                                  // ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  "Customer Name: ${customerList[i].customerName}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  "Order Number: ${customerList[i].orderNumber}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  "Order Date: ${customerList[i].orderDate}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  "Delivery Status: ${customerList[i].deliveryStatus}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          margin: EdgeInsets.only(right: 10),
                                          child: TextButton(
                                              onPressed: () {
                                                approveCredits(customerList[i].orderId, customerList[i].customerId);
                                              },
                                              child: Text(
                                                "Approve",
                                                style: TextStyle(color: kWhite),
                                              ))),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                indent: 20,
                                color: Colors.grey.withOpacity(.8),
                              );
                            },
                          )
                        : _searchResult.length == 0
                            ? Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "No Data Found",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800),
                                ))
                            : ListView.separated(
                                // padding: EdgeInsets.all(10),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                //reverse: true,
                                itemCount: _searchResult.length,
                                itemBuilder: (c, i) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      //padding: EdgeInsets.only(top: 10, bottom: 10),
                                      margin:
                                          EdgeInsets.only(left: 5, right: 5),
                                      alignment: Alignment.centerLeft,
                                      // decoration: BoxDecoration(
                                      //   //color: Color(0xFFF5F6F9),
                                      //   borderRadius: BorderRadius.circular(15),
                                      // ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      "Customer Name: ${_searchResult[i].customerName}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      "Order Number: ${_searchResult[i].orderNumber}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      "Order Date: ${_searchResult[i].orderDate}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      "Delivery Status: ${_searchResult[i].deliveryStatus}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: TextButton(
                                                  onPressed: () {
                                                    approveCredits(_searchResult[i].orderId, _searchResult[i].customerId);
                                                  },
                                                  child: Text(
                                                    "Approve",
                                                    style: TextStyle(
                                                        color: kWhite),
                                                  ))),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return Divider(
                                    indent: 20,
                                    color: Colors.grey.withOpacity(.8),
                                  );
                                },
                              ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _searchView() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(border: Border.all(color: kSecondaryColor)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: TextFormField(
            controller: searchView,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.left,
            onChanged: (value) {
              setState(() {
                search = true;
                onSearchTextChangedICD(value);
              });
            },
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: "Search Customers",
            ),
          ),
        ),
      ),
    );
  }

  onSearchTextChangedICD(String text) async {
    _searchResult.clear();
    print("$text value from search");
    if (text.isEmpty) {
      setState(() {
        search = false;
      });
      return;
    }

    customerList.forEach((exp) {
      if (exp.customerName.toLowerCase().contains(text.toLowerCase()) ||
          exp.orderNumber.toLowerCase().contains(text.toLowerCase()) ||
          exp.deliveryStatus.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    setState(() {});
  }


  approveCredits(String orderId, String customerId) async {
    // String value;
    // status ? value = "1" : value = "0";
    print("object request value $status $customerId");
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
    var response = await http.post(Uri.parse(Connection.approveOrder), body: {
      'secretkey': Connection.secretKey,
      'customer_id': '$customerId',
      "order_id": orderId,
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true) {
      final snackBar = SnackBar(
          content: Text(
        results["message"],
        textAlign: TextAlign.center,
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (builder) => OrderApprovePending()));
    } else {
      Alerts.showAlertAndBack(context, 'Error', results["message"]);
    }
  }
}
