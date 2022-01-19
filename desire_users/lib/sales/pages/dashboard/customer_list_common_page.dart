import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/models/sales_customer_list_model.dart';
import 'package:desire_users/pages/ledger/customerLedgerPage.dart';
import 'package:desire_users/sales/bloc/customer_bloc.dart';
import 'package:desire_users/sales/pages/products/customer_pricing_page_copy.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';

import '../sales_home_page.dart';

class CustomerListCommonPage extends StatefulWidget {
  final String salesId;
  final String customerId;
  final String name;
  final String email;
  final int type;

  const CustomerListCommonPage(
      {@required this.customerId,
      @required this.salesId,
      @required this.name,
      @required this.email,
      @required this.type});

  @override
  _CustomerListCommonPageState createState() => _CustomerListCommonPageState();
}

class _CustomerListCommonPageState extends State<CustomerListCommonPage> {
  final customerBloc = CustomerListBloc();
  List<UserModel> customerList = [];
  List<bool> status = [];
  TextEditingController searchView;
  bool search = false;
  List<UserModel> _searchResult = [];

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    searchView = TextEditingController();
    print("object sales id ${widget.salesId}");
    customerBloc.fetchCustomerList(widget.salesId);
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
    super.dispose();
    searchView.dispose();
    customerBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (builder) => SalesHomePage(
                      salesManId: widget.salesId.toString(),
                    )),
            (route) => false);
      },
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          iconTheme: IconThemeData(color: kBlackColor),
          elevation: 0.0,
          title: Text(
            "All Customers",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              child: _searchView(),
            ),
          ),
        ),
        body: allCustomersListView(),
      )),
    );
  }

  Widget allCustomersListView() {
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (builder) => CustomerListCommonPage(
                    salesId: widget.salesId,
                    name: widget.name,
                    email: widget.email,
                    customerId: widget.customerId,
                  )),
        );
      },
      child: StreamBuilder<SalesCustomerModel>(
        stream: customerBloc.newCustomerStream,
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
          customerList = s.data.customer;
          return ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              _searchResult.length != 0
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResult.length,
                      itemBuilder: (c, i) {
                        _searchResult[i].isActive == "0"
                            ? status.add(false)
                            : status.add(true);
                        return InkWell(
                            onTap: () {
                              callLedgerScreen(i, widget.type);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: kWhiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 5)
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      top: 10,
                                      bottom: 10,
                                      right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(right: 13.0),
                                              child: Text(
                                                "${_searchResult[i].customerName}",
                                                textAlign: TextAlign.left,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: kPrimaryColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, bottom: 10),
                                        child: Divider(
                                          color: Colors.grey,
                                          height: 0.0,
                                          thickness: 1,
                                        ),
                                      ),
                                      widget.type == 0
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (builder) =>
                                                            CustomerLedgerPage(
                                                              customerId:
                                                                  _searchResult[
                                                                          i]
                                                                      .customerId,
                                                            )));
                                              },
                                              child: Image.asset(
                                                "assets/images/ledger.png",
                                                height: 30,
                                                width: 30,
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                callLedgerScreen(
                                                    i, widget.type);
                                              },
                                              child: Image.asset(
                                                "assets/images/rupees.png",
                                                height: 25,
                                                width: 25,
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      })
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: customerList.length,
                      itemBuilder: (c, i) {
                        customerList[i].isActive == "0"
                            ? status.add(false)
                            : status.add(true);
                        return InkWell(
                            onTap: () {
                              callLedgerScreen(i, widget.type);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: kWhiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 5)
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      top: 10,
                                      bottom: 10,
                                      right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding: EdgeInsets.only(right: 13.0),
                                          child: Text(
                                            "${customerList[i].customerName}"
                                            "\n"
                                            "${customerList[i].address}",
                                            textAlign: TextAlign.left,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      widget.type == 0
                                          ? GestureDetector(
                                              onTap: () {
                                                callLedgerScreen(
                                                    i, widget.type);
                                              },
                                              child: Image.asset(
                                                "assets/images/ledger.png",
                                                height: 30,
                                                width: 30,
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                callLedgerScreen(
                                                    i, widget.type);
                                              },
                                              child: Image.asset(
                                                "assets/images/rupees.png",
                                                height: 25,
                                                width: 25,
                                              ),
                                            )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      })
            ],
          );
        },
      ),
    );
  }

  Widget _searchView() {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.black,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              cursorColor: kBlackColor,
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
                hintText: "Search",
              ),
            ),
          ),
        ],
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
      if (exp.customerName.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }

  void callLedgerScreen(int i, int type) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (builder) => type == 0
                ? CustomerLedgerPage(
                    customerId: customerList[i].customerId,
                  )
                : CustomerPricingPage(
                    customerId: "${customerList[i].customerId}",
                    customerName: "${customerList[i].customerName}",
                    salesId: widget.salesId,
                  )));
  }
}
