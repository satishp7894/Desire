import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/customer_bloc.dart';
import 'package:desire_production/model/sales_customer_list_model.dart';
import 'package:desire_production/pages/admin/ledgerandprice/CustomerLedgerPage.dart';
import 'package:desire_production/pages/admin/products/customer_pricing_page.dart';
import 'package:desire_production/pages/warehouse/ready_stock_page.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class CommonLedgerPricePage extends StatefulWidget {
  final type;

  const CommonLedgerPricePage({Key key, this.type}) : super(key: key);

  @override
  _CommonLedgerPricePageState createState() => _CommonLedgerPricePageState();
}

class _CommonLedgerPricePageState extends State<CommonLedgerPricePage> {
  final customerBloc = CustomerListBloc();
  List<bool> status = [];
  TextEditingController searchView;
  bool search = false;
  List<CustomerModel> _searchResult = [];
  List<CustomerModel> customerList = [];

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    searchView = TextEditingController();
    customerBloc.fetchCustomerList();
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Customer List",
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
          MaterialPageRoute(builder: (builder) => CommonLedgerPricePage()),
        );
      },
      child: StreamBuilder<SalesCustomerModel>(
          stream: customerBloc.newCustomerStream,
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

            customerList = s.data.customer;

            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                child: Column(
                  children: [
                    _searchResult.length == 0
                        ? ListView.separated(
                            //padding: EdgeInsets.all(10),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            //reverse: true,
                            itemCount: customerList.length,
                            itemBuilder: (c, i) {
                              customerList[i].isActive == "0"
                                  ? status.add(false)
                                  : status.add(true);
                              return InkWell(
                                onTap: () {
                                  widget.type == ""
                                      ? {}
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  CustomerPricingPage(
                                                    customerId: customerList[i]
                                                        .customerId,
                                                    salesId: customerList[i]
                                                        .salesmanID,
                                                  )));
                                },
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
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: AspectRatio(
                                          aspectRatio: 0.88,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF5F6F9),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Icon(
                                              Icons.person_outline,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
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
                                                  "Company Name: ${customerList[i].companyName}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  "Name: ${customerList[i].customerName}",
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
                                                  "Salesman: ${customerList[i].salesmanID}",
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Status: ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  customerList[i].isActive ==
                                                          "0"
                                                      ? Text(
                                                          "Blocked",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                        )
                                                      : Text(
                                                          "Active",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            customerList[i].kycStatus == "0"
                                                ? Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      "KYC Status : Docs not Uploaded",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ))
                                                : Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      "KYC Status : Docs Uploaded",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                            customerList[i].kycStatus == "2"
                                                ? customerList[i].kycApprove ==
                                                        "0"
                                                    ? Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Text(
                                                          "KYC Pending",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .yellow
                                                                  .shade700),
                                                        ),
                                                      )
                                                    : customerList[i]
                                                                .kycApprove ==
                                                            "1"
                                                        ? Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                            child: Text(
                                                              "KYC Done",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .greenAccent),
                                                            ),
                                                          )
                                                        : Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                            child: Text(
                                                              "KYC Rejected",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .redAccent),
                                                            ),
                                                          )
                                                : Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 10),
                                                    child: Text(
                                                      "KYC Pending",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellow.shade700),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
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
                        : ListView.separated(
                            padding: EdgeInsets.all(10),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            //reverse: true,
                            itemCount: _searchResult.length,
                            itemBuilder: (c, i) {
                              _searchResult[i].isActive == "0"
                                  ? status.add(false)
                                  : status.add(true);
                              return GestureDetector(
                                onTap: () {
                                  widget.type == ""
                                      ? {}
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  CustomerPricingPage(
                                                    customerId: customerList[i]
                                                        .customerId,
                                                    salesId: customerList[i]
                                                        .salesmanID,
                                                  )));
                                },
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
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: AspectRatio(
                                          aspectRatio: 0.88,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF5F6F9),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Icon(
                                              Icons.person_outline,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
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
                                                  "Company Name: ${_searchResult[i].companyName}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  "Name: ${_searchResult[i].customerName}",
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
                                                  "Salesman: ${_searchResult[i].salesmanID}",
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Status: ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  _searchResult[i].isActive ==
                                                          "0"
                                                      ? Text(
                                                          "Blocked",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                        )
                                                      : Text(
                                                          "Active",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            _searchResult[i].kycStatus == "0"
                                                ? Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      "KYC Status : Docs not Uploaded",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ))
                                                : Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      "KYC Status : Docs Uploaded",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                            _searchResult[i].kycStatus == "2"
                                                ? _searchResult[i].kycApprove ==
                                                        "0"
                                                    ? Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        child: Text(
                                                          "KYC Pending",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .yellow
                                                                  .shade700),
                                                        ),
                                                      )
                                                    : _searchResult[i]
                                                                .kycApprove ==
                                                            "1"
                                                        ? Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                            child: Text(
                                                              "KYC Done",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .greenAccent),
                                                            ),
                                                          )
                                                        : Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
                                                            child: Text(
                                                              "KYC Rejected",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .redAccent),
                                                            ),
                                                          )
                                                : Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 10),
                                                    child: Text(
                                                      "KYC Pending",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .yellow.shade700),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
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
          exp.salesmanID.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }
}
