import 'package:desire_users/bloc/invoice_detail_bloc.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/models/invoice_detail_model.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';

import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class InvoiceDetailPage extends StatefulWidget {
  final id;

  const InvoiceDetailPage({Key key, this.id}) : super(key: key);

  @override
  _InvoiceDetailPageState createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  InvoiceDetailBloc invoiceDetailBloc = InvoiceDetailBloc();
  List<bool> check = [];
  bool checkAll = false;

  List<String> send = [];
  InvoiceDetailModel as;
  TextEditingController searchView;
  bool search = false;
  List<InvoiceProducts> _searchResult = [];
  List<InvoiceProducts> _order = [];
  TextEditingController searchViewController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoiceDetailBloc.fetchInvoiceDetails(widget.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    invoiceDetailBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        iconTheme: IconThemeData(color: kBlackColor),
        title: Text("Invoice Detail"),
        titleTextStyle: TextStyle(
            color: kBlackColor, fontSize: 18, fontWeight: FontWeight.bold),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: _searchView(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          generatePdf();
          savePdf();
        },
        label: Text(
          "Download Invoice",
          style: TextStyle(color: kWhiteColor),
        ),
        icon: Icon(
          Icons.arrow_circle_down_sharp,
          color: kWhiteColor,
        ),
      ),
      body: _body(),
    );
  }

  Widget _searchView() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
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
              controller: searchViewController,
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

  Future<bool> _reqPer(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var res = await permission.request();

      // ignore: unrelated_type_equality_checks
      if (res == permission.isGranted) {
        return true;
      } else {
        return false;
      }
    }
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

    _order.forEach((exp) {
      if (exp.modelNoId.contains(text)) _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }

  Widget _body() {
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () {
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (builder) => InvoiceDetailPage(
                      id: widget.id,
                    )),
            (route) => false);
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: StreamBuilder<InvoiceDetailModel>(
            stream: invoiceDetailBloc.invoiceDetailStream,
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
              if (s.data.invoiceProducts == null) {
                print("as3 empty");
                return Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: Text(
                    "No Orders Found",
                  ),
                );
              }

              var data = s.data.invoiceProducts;
              as = s.data;
              _order = data;

              _order == null
                  ? print("0")
                  : print("Length" + _order.length.toString());
              for (int i = 0; i < _order.length; i++) {
                check.add(false);
              }

              print("object length ${_order.length} ${check.length}");
              return _order == null
                  ? Center(
                      child: Text("No Items are ready to dispatch"),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _searchResult.length == 0
                            ? Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      height: 40,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              border: Border(
                                                  top: BorderSide(
                                                      color: Colors.black),
                                                  right: BorderSide(
                                                      color: Colors.black),
                                                  bottom: BorderSide(
                                                      color: Colors.black)),
                                            ),
                                            child: Checkbox(
                                              value: checkAll,
                                              checkColor: kPrimaryColor,
                                              activeColor: Colors.white,
                                              onChanged: (value) {
                                                setState(() {
                                                  checkAll = value;
                                                });
                                                print(
                                                    "object remember $checkAll");
                                                if (checkAll == true) {
                                                  for (int i = 0;
                                                      i < data.length;
                                                      i++) {
                                                    check[i] = true;
                                                    data[i].isSelected = true;
                                                    send.add(data[i].orderId);
                                                  }
                                                } else {
                                                  for (int i = 0;
                                                      i < data.length;
                                                      i++) {
                                                    check[i] = false;
                                                    data[i].isSelected = false;
                                                    send = [];
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                          // Expanded(
                                          //   flex: 2,
                                          //   child: Container(
                                          //     alignment:
                                          //     Alignment.center,
                                          //     decoration:
                                          //     BoxDecoration(
                                          //       color: kPrimaryColor,
                                          //       border: Border(
                                          //           left: BorderSide(
                                          //               color: Colors
                                          //                   .black),
                                          //           right: BorderSide(
                                          //               color: Colors
                                          //                   .black),
                                          //           bottom: BorderSide(
                                          //               color: Colors
                                          //                   .black),
                                          //           top: BorderSide(
                                          //               color: Colors
                                          //                   .black)),
                                          //     ),
                                          //     child: Text(
                                          //         'Customer Name',
                                          //         //style: content1,
                                          //         textAlign: TextAlign
                                          //             .center,
                                          //         style: TextStyle(
                                          //             color: Colors
                                          //                 .white)),
                                          //     //alignment: Alignment.center,
                                          //   ),
                                          // ),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Colors.black),
                                                      bottom: BorderSide(
                                                          color: Colors.black),
                                                      top: BorderSide(
                                                          color: Colors.black)),
                                                ),
                                                child: Text('Product Name',
                                                    //style: content1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                alignment: Alignment.center,
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Colors.black),
                                                      bottom: BorderSide(
                                                          color: Colors.black),
                                                      top: BorderSide(
                                                          color: Colors.black)),
                                                ),
                                                child: Text('Order Id',
                                                    //style: content1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                alignment: Alignment.center,
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Colors.black),
                                                      bottom: BorderSide(
                                                          color: Colors.black),
                                                      top: BorderSide(
                                                          color: Colors.black)),
                                                ),
                                                child: Text(
                                                    'Model No', //style: content1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                alignment: Alignment.center,
                                              )),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              width: 50,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                border: Border(
                                                    right: BorderSide(
                                                        color: Colors.black),
                                                    bottom: BorderSide(
                                                        color: Colors.black),
                                                    top: BorderSide(
                                                        color: Colors.black)),
                                              ),
                                              child: Text(
                                                'Qty', //style: content1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              //alignment: Alignment.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    for (int i = 0; i < data.length; i++)
                                      AnimationConfiguration.staggeredList(
                                        position: i,
                                        duration:
                                            const Duration(milliseconds: 375),
                                        child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child: Container(
                                              height: 50,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      //color: bg,
                                                      border: Border(
                                                          right: BorderSide(
                                                              color:
                                                                  Colors.black),
                                                          bottom: BorderSide(
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                    child: Checkbox(
                                                      value: check[i],
                                                      activeColor:
                                                          kPrimaryColor,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          check[i] = value;
                                                          data[i].isSelected =
                                                              value;
                                                        });
                                                        print(
                                                            "object remember ${check[i]}");
                                                        if (check[i] == true) {
                                                          send.add(
                                                              data[i].orderId);
                                                        } else {
                                                          send.remove(
                                                              data[i].orderId);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  // Expanded(
                                                  //   flex: 2,
                                                  //   child: Container(
                                                  //     alignment:
                                                  //     Alignment
                                                  //         .center,
                                                  //     decoration:
                                                  //     BoxDecoration(
                                                  //       //color: bg,
                                                  //       border: Border(
                                                  //           left: BorderSide(
                                                  //               color: Colors
                                                  //                   .black),
                                                  //           right: BorderSide(
                                                  //               color: Colors
                                                  //                   .black),
                                                  //           bottom: BorderSide(
                                                  //               color:
                                                  //               Colors.black)),
                                                  //     ),
                                                  //     child: Text(
                                                  //       data[i]
                                                  //           .productName,
                                                  //       //style: content1,
                                                  //       textAlign:
                                                  //       TextAlign
                                                  //           .center,
                                                  //     ),
                                                  //     //alignment: Alignment.center,
                                                  //   ),
                                                  // ),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        child: Text(
                                                          '${data[i].productName}',
                                                          //style: content1,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      )),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        child: Text(
                                                          '${data[i].orderId}',
                                                          //style: content1,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        child: Text(
                                                          '${data[i].modelNoId}',
                                                          //style: content1,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        child: TextFormField(
                                                            onChanged:
                                                                (text) {},
                                                            initialValue: data[
                                                                    i]
                                                                .productQuantity,
                                                            maxLines: 1,
                                                            enabled: false,
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLength: 4,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              counter:
                                                                  Offstage(),
                                                            )),
                                                        // child: Text(
                                                        //   '${data.orderDetails[i].invoiceQty}', //style: content1,
                                                        //   textAlign:
                                                        //   TextAlign
                                                        //       .center,
                                                        // ),
                                                        alignment:
                                                            Alignment.center,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            : Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 40,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              border: Border(
                                                  top: BorderSide(
                                                      color: Colors.black),
                                                  right: BorderSide(
                                                      color: Colors.black),
                                                  bottom: BorderSide(
                                                      color: Colors.black)),
                                            ),
                                            child: Checkbox(
                                              value: checkAll,
                                              checkColor: kPrimaryColor,
                                              activeColor: Colors.white,
                                              onChanged: (value) {
                                                setState(() {
                                                  checkAll = value;
                                                });
                                                print(
                                                    "object remember $checkAll");
                                                if (checkAll == true) {
                                                  for (int i = 0;
                                                      i < data.length;
                                                      i++) {
                                                    check[i] = true;
                                                    send.add(data[i].orderId);
                                                  }
                                                } else {
                                                  for (int i = 0;
                                                      i < data.length;
                                                      i++) {
                                                    check[i] = false;
                                                    send = [];
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                          // Expanded(
                                          //   flex: 2,
                                          //   child: Container(
                                          //     alignment:
                                          //     Alignment.center,
                                          //     decoration:
                                          //     BoxDecoration(
                                          //       color: kPrimaryColor,
                                          //       border: Border(
                                          //           left: BorderSide(
                                          //               color: Colors
                                          //                   .black),
                                          //           right: BorderSide(
                                          //               color: Colors
                                          //                   .black),
                                          //           bottom: BorderSide(
                                          //               color: Colors
                                          //                   .black),
                                          //           top: BorderSide(
                                          //               color: Colors
                                          //                   .black)),
                                          //     ),
                                          //     child: Text(
                                          //         'Customer Name',
                                          //         //style: content1,
                                          //         textAlign: TextAlign
                                          //             .center,
                                          //         style: TextStyle(
                                          //             color: Colors
                                          //                 .white)),
                                          //     //alignment: Alignment.center,
                                          //   ),
                                          // ),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Colors.black),
                                                      bottom: BorderSide(
                                                          color: Colors.black),
                                                      top: BorderSide(
                                                          color: Colors.black)),
                                                ),
                                                child: Text('Product Name',
                                                    //style: content1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                alignment: Alignment.center,
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Colors.black),
                                                      bottom: BorderSide(
                                                          color: Colors.black),
                                                      top: BorderSide(
                                                          color: Colors.black)),
                                                ),
                                                child: Text('Order Id',
                                                    //style: content1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                alignment: Alignment.center,
                                              )),
                                          Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Colors.black),
                                                      bottom: BorderSide(
                                                          color: Colors.black),
                                                      top: BorderSide(
                                                          color: Colors.black)),
                                                ),
                                                child: Text(
                                                    'Model No', //style: content1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                alignment: Alignment.center,
                                              )),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              width: 50,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                border: Border(
                                                    right: BorderSide(
                                                        color: Colors.black),
                                                    bottom: BorderSide(
                                                        color: Colors.black),
                                                    top: BorderSide(
                                                        color: Colors.black)),
                                              ),
                                              child: Text(
                                                'Qty', //style: content1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              //alignment: Alignment.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    for (int i = 0;
                                        i < _searchResult.length;
                                        i++)
                                      AnimationConfiguration.staggeredList(
                                        position: i,
                                        duration:
                                            const Duration(milliseconds: 375),
                                        child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child: Container(
                                              height: 50,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      //color: bg,
                                                      border: Border(
                                                          right: BorderSide(
                                                              color:
                                                                  Colors.black),
                                                          bottom: BorderSide(
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                    child: Checkbox(
                                                      value: check[i],
                                                      activeColor:
                                                          kPrimaryColor,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          check[i] = value;
                                                        });
                                                        print(
                                                            "object remember ${check[i]}");
                                                        if (check[i] == true) {
                                                          send.add(
                                                              _searchResult[i]
                                                                  .orderId);
                                                        } else {
                                                          send.remove(
                                                              _searchResult[i]
                                                                  .orderId);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  // Expanded(
                                                  //   flex: 2,
                                                  //   child: Container(
                                                  //     alignment:
                                                  //     Alignment
                                                  //         .center,
                                                  //     decoration:
                                                  //     BoxDecoration(
                                                  //       //color: bg,
                                                  //       border: Border(
                                                  //           left: BorderSide(
                                                  //               color: Colors
                                                  //                   .black),
                                                  //           right: BorderSide(
                                                  //               color: Colors
                                                  //                   .black),
                                                  //           bottom: BorderSide(
                                                  //               color:
                                                  //               Colors.black)),
                                                  //     ),
                                                  //     child: Text(
                                                  //       _searchResult[
                                                  //       i]
                                                  //           .productName,
                                                  //       //style: content1,
                                                  //       textAlign:
                                                  //       TextAlign
                                                  //           .center,
                                                  //     ),
                                                  //     //alignment: Alignment.center,
                                                  //   ),
                                                  // ),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        child: Text(
                                                          '${_searchResult[i].productName}',
                                                          //style: content1,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      )),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        child: Text(
                                                          '${_searchResult[i].productId}',
                                                          //style: content1,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        child: Text(
                                                          '${_searchResult[i].modelNoId}',
                                                          //style: content1,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      )),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        child: TextFormField(
                                                            onChanged:
                                                                (text) {},
                                                            initialValue:
                                                                _searchResult[i]
                                                                    .productQuantity,
                                                            maxLines: 1,
                                                            textAlign: TextAlign
                                                                .center,
                                                            maxLength: 4,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  InputBorder
                                                                      .none,
                                                              counter:
                                                                  Offstage(),
                                                            )),
                                                        alignment:
                                                            Alignment.center,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                      ],
                    );
            }),
      ),
    );
  }

  String path;

  Future savePdf() async {
    if (await _reqPer(Permission.storage)) {
      var dir = await DownloadsPathProvider.downloadsDirectory;
      print("object directory path ${dir.path}");
      File file = File(dir.path + "/InvoiceList.pdf");
      path = dir.path + "/InvoiceList.pdf";

      print(path);
      file.writeAsBytesSync(List.from(await pdf.save()));
      print("path of file open $path");
      Alerts.showAlertPdf(context, 'Invoice List', 'Pdf Generated', path);
    }
  }

  final pdf = pw.Document();

  generatePdf() {
    pdf.addPage(pw.MultiPage(
      margin: pw.EdgeInsets.all(15),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return <pw.Widget>[
          pw.Header(
              level: 5,
              child: pw.Text("Invoice List",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 40,
                    color: PdfColor.fromHex('#4684C2'),
                    fontWeight: pw.FontWeight.bold,
                  ))),
          pw.SizedBox(height: 30),
          pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    child: pw.Text(
                      'Sr. No.',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 15),
                      textAlign: pw.TextAlign.center,
                    ),
                    width: 50,
                    height: 52,
                    padding: pw.EdgeInsets.only(left: 5),
                    alignment: pw.Alignment.center,
                  ),
                  pw.Container(
                    child: pw.Text(
                      'Order Number',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 15),
                      textAlign: pw.TextAlign.center,
                    ),
                    width: 100,
                    height: 52,
                    padding: pw.EdgeInsets.only(left: 10),
                    alignment: pw.Alignment.center,
                  ),
                  pw.Container(
                    child: pw.Text(
                      'Quantity',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 15),
                      textAlign: pw.TextAlign.center,
                    ),
                    width: 60,
                    height: 52,
                    alignment: pw.Alignment.center,
                  ),
                ]),
            pw.Divider(color: PdfColor.fromHex('#4684C2'), thickness: 3),
            pw.ListView.builder(
                //padding: pw.EdgeInsets.only(bottom: 10),
                itemCount: as.invoiceProducts.length,
                itemBuilder: (c, i) {
                  if (i.isEven) {
                    return pw.Container(
                        color: PdfColor.fromHex('#E0F7FA'),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              child: pw.Text(
                                '${i + 1}',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15),
                                textAlign: pw.TextAlign.center,
                              ),
                              width: 50,
                              height: 52,
                              padding: pw.EdgeInsets.only(left: 5),
                              alignment: pw.Alignment.center,
                            ),
                            pw.Container(
                              child: pw.Text(
                                '${as.invoiceProducts[i].modelNoId}',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15),
                                textAlign: pw.TextAlign.center,
                              ),
                              width: 100,
                              height: 52,
                              padding: pw.EdgeInsets.only(left: 10),
                              alignment: pw.Alignment.center,
                            ),
                            pw.Container(
                              child: pw.Text(
                                '${as.invoiceProducts[i].productQuantity}',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 15),
                                textAlign: pw.TextAlign.center,
                              ),
                              width: 60,
                              height: 52,
                              alignment: pw.Alignment.center,
                            ),
                          ],
                        ));
                  } else {
                    return pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          child: pw.Text(
                            '${i + 1}',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 15),
                            textAlign: pw.TextAlign.center,
                          ),
                          width: 50,
                          height: 52,
                          padding: pw.EdgeInsets.only(left: 5),
                          alignment: pw.Alignment.center,
                        ),
                        pw.Container(
                          child: pw.Text(
                            '${as.invoiceProducts[i].modelNoId}',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 15),
                            textAlign: pw.TextAlign.center,
                          ),
                          width: 100,
                          height: 52,
                          padding: pw.EdgeInsets.only(left: 10),
                          alignment: pw.Alignment.center,
                        ),
                        pw.Container(
                          child: pw.Text(
                            '${as.invoiceProducts[i].productQuantity}',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 15),
                            textAlign: pw.TextAlign.center,
                          ),
                          width: 60,
                          height: 52,
                          alignment: pw.Alignment.center,
                        ),
                      ],
                    );
                  }
                })
          ])
        ];
      },
    ));
  }
}
