import 'dart:convert';

import 'package:desire_users/bloc/invoice_detail_bloc.dart';
import 'package:desire_users/models/invoice_detail_model.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmitReturnMaterial extends StatefulWidget {
  final id;
  final customerId;

  const SubmitReturnMaterial({Key key, this.id, this.customerId}) : super(key: key);

  @override
  _SubmitReturnMaterialState createState() => _SubmitReturnMaterialState();
}

class _SubmitReturnMaterialState extends State<SubmitReturnMaterial> {
  InvoiceDetailBloc invoiceDetailBloc = InvoiceDetailBloc();
  List<bool> check = [];
  bool checkAll = false;

  List<String> send = [];
  InvoiceDetailModel as;
  TextEditingController searchView;
  bool search = false;
  List<InvoiceProducts> _searchResult = [];
  List<InvoiceProducts> _order = [];
  TextEditingController fromDateinput = TextEditingController();
  TextEditingController toDateinput = TextEditingController();
  TextEditingController searchViewController = TextEditingController();
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoiceDetailBloc.fetchInvoiceDetails("11");
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
          title: Text("Return Material"),
          titleTextStyle: TextStyle(
              color: kBlackColor, fontSize: 18, fontWeight: FontWeight.bold),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: _searchView(),
          )),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          sumbitMaterial(widget.id, widget.customerId);
        },
        label: Text(
          "Return Material",
          style: TextStyle(color: kWhiteColor),
        ),
        icon: Icon(
          Icons.assignment_return,
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

  Widget _body() {
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () {
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (builder) => SubmitReturnMaterial(
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
                                                            onChanged: (text) {
                                                              setState(() {
                                                                check[i] = true;
                                                                data[i].isSelected =
                                                                    true;
                                                                data[i].changeQuantity =
                                                                    int.parse(
                                                                        text);
                                                              });
                                                            },
                                                            initialValue: data[
                                                                    i]
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
                                                            onChanged: (text) {
                                                              setState(() {
                                                                check[i] = true;
                                                                _searchResult[i]
                                                                        .isSelected =
                                                                    true;
                                                                _searchResult[i]
                                                                        .changeQuantity =
                                                                    int.parse(
                                                                        text);
                                                              });
                                                            },
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

  void sumbitMaterial(id, customerId) async {
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
    var response =
        await http.post(Uri.parse(Connection.submitReturnMaterial), body: {
      'secretkey': Connection.secretKey,
      'customer_id': customerId,
      'invoice_id': id,
      'orderdetails_list': jsonEncode(as.toPostJson()),
      'description': "test return material"
    });
    pr.hide();
    if (response.statusCode == 200) {
      print(response.body);
      var results = json.decode(response.body);
      print('response == $results  ${response.body}');
      pr.hide();
      if (results['status'] == true) {
        Alerts.showAlertAndBack(context, "Success", results['message']);
      } else {
        print('error deleting address');
        Alerts.showAlertAndBack(context, 'Error', 'Address not Deleted.');
      }
    }
  }
}
