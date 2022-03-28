import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/customer_bloc.dart';
import 'package:desire_production/model/sales_customer_list_model.dart';
import 'package:desire_production/pages/admin/customer/customer_order_details_page.dart';
import 'package:desire_production/pages/admin/products/customer_pricing_page.dart';
import 'package:desire_production/pages/admin/products/product_home_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'customer_detail_page.dart';
import 'customer_edit_page.dart';
import 'customer_kyc_details_page.dart';

class CustomerListPage extends StatefulWidget {
  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
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
          MaterialPageRoute(builder: (builder) => CustomerListPage()),
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
                    searchView.text.length == 0
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
                              return GestureDetector(
                                onTap: () {
                                  //s.data.customer[i].kycStatus == "0" ? Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerKYCDetailsPage(customerId: s.data.customer[i].customerId, salesId: widget.salesId,)))  :  Navigator.of(context).push(MaterialPageRoute(builder: (_) => CustomerListPage(salesId: widget.salesId,)));
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
                                                  "Salesman: ${customerList[i].salesman_name}",
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
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          CustomerDetailsPage(
                                                              customer:
                                                                  customerList[
                                                                      i])));
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 20,
                                              padding: EdgeInsets.zero,
                                              child: Icon(
                                                Icons.preview_outlined,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          CustomerEditPage(
                                                              customer:
                                                                  customerList[
                                                                      i])));
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 20,
                                              padding: EdgeInsets.zero,
                                              child: Icon(Icons.edit_outlined),
                                            ),
                                          ),
                                          customerList[i].isActive == "0"
                                              ? GestureDetector(
                                                  onTap: () {
                                                    updateStatusId(
                                                        "1",
                                                        customerList[i]
                                                            .customerId);
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 20,
                                                    padding: EdgeInsets.zero,
                                                    child: Icon(
                                                      Icons.block,
                                                      color: kPrimaryColor,
                                                    ),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    updateStatusId(
                                                        "0",
                                                        customerList[i]
                                                            .customerId);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.zero,
                                                    height: 30,
                                                    width: 20,
                                                    child: Icon(
                                                      Icons.block,
                                                      color: Colors.blue,
                                                    ),
                                                  ),
                                                ),
                                          customerList[i].kycStatus == "2" &&
                                                      customerList[i]
                                                              .kycApprove ==
                                                          "0" ||
                                                  customerList[i].kycApprove ==
                                                      "2"
                                              ? GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (builder) =>
                                                                CustomerKYCDetailsPage(
                                                                  customerId:
                                                                      customerList[
                                                                              i]
                                                                          .customerId,
                                                                )));
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    width: 20,
                                                    padding: EdgeInsets.zero,
                                                    child: Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          CustomerOrderDetailPage(
                                                            customerId:
                                                                customerList[i]
                                                                    .customerId,
                                                            customerName:
                                                                customerList[i]
                                                                    .customerName,
                                                          )));
                                            },
                                            child: Container(
                                                height: 30,
                                                width: 20,
                                                padding: EdgeInsets.zero,
                                                child: SvgPicture.asset(
                                                    "assets/icons/Bill Icon.svg")),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          CustomerPricingPage(
                                                            customerId:
                                                                customerList[i]
                                                                    .customerId,
                                                            salesId:
                                                                customerList[i]
                                                                    .salesmanID,
                                                          )));
                                            },
                                            child: Container(
                                                height: 30,
                                                width: 20,
                                                padding: EdgeInsets.zero,
                                                child: SvgPicture.asset(
                                                    "assets/icons/sweetbox.svg")),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          ProductHomePage(
                                                            customerId:
                                                                customerList[i]
                                                                    .customerId,
                                                            salesId:
                                                                customerList[i]
                                                                    .salesmanID,
                                                            customerName:
                                                                customerList[i]
                                                                    .customerName,
                                                          )));
                                            },
                                            child: Container(
                                                height: 30,
                                                width: 20,
                                                padding: EdgeInsets.zero,
                                                child: SvgPicture.asset(
                                                    "assets/icons/Shop Icon.svg")),
                                          ),
                                        ],
                                      ))
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
                                      //s.data.customer[i].kycStatus == "0" ? Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerKYCDetailsPage(customerId: s.data.customer[i].customerId, salesId: widget.salesId,)))  :  Navigator.of(context).push(MaterialPageRoute(builder: (_) => CustomerListPage(salesId: widget.salesId,)));
                                    },
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
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    child: Text(
                                                      "Salesman: ${_searchResult[i].salesman_name}",
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
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "Status: ",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      _searchResult[i]
                                                                  .isActive ==
                                                              "0"
                                                          ? Text(
                                                              "Blocked",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .redAccent,
                                                              ),
                                                            )
                                                          : Text(
                                                              "Active",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                _searchResult[i].kycStatus ==
                                                        "0"
                                                    ? Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: Text(
                                                          "KYC Status : Docs not Uploaded",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ))
                                                    : Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10),
                                                        child: Text(
                                                          "KYC Status : Docs Uploaded",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                _searchResult[i].kycStatus ==
                                                        "2"
                                                    ? _searchResult[i]
                                                                .kycApprove ==
                                                            "0"
                                                        ? Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10),
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
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (builder) =>
                                                              CustomerDetailsPage(
                                                                  customer:
                                                                      _searchResult[
                                                                          i])));
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 20,
                                                  padding: EdgeInsets.zero,
                                                  child: Icon(
                                                    Icons.preview_outlined,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (builder) =>
                                                              CustomerEditPage(
                                                                  customer:
                                                                      _searchResult[
                                                                          i])));
                                                },
                                                child: Container(
                                                  height: 30,
                                                  width: 20,
                                                  padding: EdgeInsets.zero,
                                                  child:
                                                      Icon(Icons.edit_outlined),
                                                ),
                                              ),
                                              _searchResult[i].isActive == "0"
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        updateStatusId(
                                                            "1",
                                                            _searchResult[i]
                                                                .customerId);
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 20,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        child: Icon(
                                                          Icons.block,
                                                          color: kPrimaryColor,
                                                        ),
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        updateStatusId(
                                                            "0",
                                                            _searchResult[i]
                                                                .customerId);
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        height: 30,
                                                        width: 20,
                                                        child: Icon(
                                                          Icons.block,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                              _searchResult[i].kycStatus ==
                                                          "2" &&
                                                      _searchResult[i]
                                                              .kycApprove ==
                                                          "0"
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (builder) =>
                                                                        CustomerKYCDetailsPage(
                                                                          customerId:
                                                                              _searchResult[i].customerId,
                                                                        )));
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 20,
                                                        padding:
                                                            EdgeInsets.zero,
                                                        child: Icon(
                                                          Icons
                                                              .check_circle_outline,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (builder) =>
                                                              CustomerOrderDetailPage(
                                                                customerId:
                                                                    _searchResult[
                                                                            i]
                                                                        .customerId,
                                                                customerName:
                                                                    _searchResult[
                                                                            i]
                                                                        .customerName,
                                                              )));
                                                },
                                                child: Container(
                                                    height: 30,
                                                    width: 20,
                                                    padding: EdgeInsets.zero,
                                                    child: SvgPicture.asset(
                                                        "assets/icons/Bill Icon.svg")),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (builder) =>
                                                              CustomerPricingPage(
                                                                customerId:
                                                                    _searchResult[
                                                                            i]
                                                                        .customerId,
                                                                salesId:
                                                                    _searchResult[
                                                                            i]
                                                                        .salesmanID,
                                                              )));
                                                },
                                                child: Container(
                                                    height: 30,
                                                    width: 20,
                                                    padding: EdgeInsets.zero,
                                                    child: SvgPicture.asset(
                                                        "assets/icons/sweetbox.svg")),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (builder) =>
                                                              ProductHomePage(
                                                                customerId:
                                                                    _searchResult[
                                                                            i]
                                                                        .customerId,
                                                                salesId:
                                                                    _searchResult[
                                                                            i]
                                                                        .salesmanID,
                                                                customerName:
                                                                    _searchResult[
                                                                            i]
                                                                        .customerName,
                                                              )));
                                                },
                                                child: Container(
                                                    height: 30,
                                                    width: 20,
                                                    padding: EdgeInsets.zero,
                                                    child: SvgPicture.asset(
                                                        "assets/icons/Shop Icon.svg")),
                                              ),
                                            ],
                                          ))
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
          exp.salesman_name.toLowerCase().contains(text.toLowerCase()) ||
          exp.companyName.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }

  updateStatusId(String status, String customerId) async {
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
    var response = await http.post(Uri.parse(Connection.blockCustomer), body: {
      'secretkey': Connection.secretKey,
      'customer_id': '$customerId',
      "status": status,
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true) {
      final snackBar = SnackBar(
          content: Text(
        "Status Updated",
        textAlign: TextAlign.center,
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CustomerListPage()),
          (Route<dynamic> route) => false);
    } else {
      print('error deleting address');
      Alerts.showAlertAndBack(context, 'Error', 'Address not Deleted.');
    }
  }
}
