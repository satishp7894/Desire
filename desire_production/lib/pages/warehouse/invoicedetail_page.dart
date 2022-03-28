import 'dart:convert';

import 'package:desire_production/bloc/InvoiceDetailBloc.dart';
import 'package:desire_production/bloc/dispatch_warhouse_bloc.dart';
import 'package:desire_production/model/InvoiceDetail.dart';
import 'package:desire_production/model/dispatchOrderDetailsModel.dart';
import 'package:desire_production/model/dispatch_order_warhouse_list_model.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/default_button.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;

class InvoiceDetailPage extends StatefulWidget {
  final dispatchInvoiceId;

  const InvoiceDetailPage(@required this.dispatchInvoiceId);

  @override
  _InvoiceDetailPageState createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  final InvoiceDetailBloc invoicedetailbloc = InvoiceDetailBloc();
  TextEditingController searchViewController = TextEditingController();
  TextEditingController invoiceController = TextEditingController();
  TextEditingController lrNoController = TextEditingController();
  TextEditingController eWayBillViewController = TextEditingController();
  TextEditingController _qtyController = TextEditingController();
  final DispatchWarhouseBloc dispatchwarhousebloc = DispatchWarhouseBloc();
  AsyncSnapshot<DispatchOrderDetailsModel> asyncSnapshot;

  List<bool> check = [];
  bool checkAll = false;
  List<String> send = [];
  bool search = false;
  List<OrderDetails> _searchResult = [];
  List<OrderDetails> _list = [];

  var list;
  var customerID;
  DataInvoice od;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    invoicedetailbloc.fetchinvoicesDetail(widget.dispatchInvoiceId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    invoicedetailbloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Invoice Orders Details List",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
          textAlign: TextAlign.center,
        ),
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
          return Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (builder) =>
                      InvoiceDetailPage(widget.dispatchInvoiceId)),
              (route) => false);
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                StreamBuilder<InvoiceDetail>(
                    stream: invoicedetailbloc.invoicesStream,
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
                        return Container(
                          height: 300,
                          alignment: Alignment.center,
                          child: Text(
                            "Error Loading Data",
                          ),
                        );
                      } else {
                        var data = s.data.data;
                        od = s.data.data;

                        Future.delayed(const Duration(milliseconds: 500), () {
                          invoiceController.text = data
                              .invoiceResult[0].clientInvoiceNumber
                              .toString();

                          lrNoController.text =
                              data.dispatchResult[0].lrNumber.toString();
                          eWayBillViewController.text =
                              data.dispatchResult[0].ewayBill.toString();
                        });

                        _list = data.orderDetails;

                        _list == null
                            ? print("0")
                            : print("Length" + _list.length.toString());
                        for (int i = 0; i < _list.length; i++) {
                          check.add(false);
                        }

                        print("object length ${_list.length} ${check.length}");
                        return _list == null
                            ? Center(
                                child: Text("No Items are ready to dispatch"),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  searchViewController.text.length == 0
                                      ? Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 40,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: kPrimaryColor,
                                                        border: Border(
                                                            top: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                      child: Checkbox(
                                                        value: checkAll,
                                                        checkColor:
                                                            kPrimaryColor,
                                                        activeColor:
                                                            Colors.white,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            checkAll = value;
                                                          });
                                                          print(
                                                              "object remember $checkAll");
                                                          if (checkAll ==
                                                              true) {
                                                            for (int i = 0;
                                                                i <
                                                                    data.orderDetails
                                                                        .length;
                                                                i++) {
                                                              check[i] = true;
                                                              data
                                                                  .orderDetails[
                                                                      i]
                                                                  .isSelected = true;
                                                              send.add(data
                                                                  .orderDetails[
                                                                      i]
                                                                  .orderId);
                                                            }
                                                          } else {
                                                            for (int i = 0;
                                                                i <
                                                                    data.orderDetails
                                                                        .length;
                                                                i++) {
                                                              check[i] = false;
                                                              data
                                                                  .orderDetails[
                                                                      i]
                                                                  .isSelected = false;
                                                              send = [];
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kPrimaryColor,
                                                          border: Border(
                                                              left: BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                              top: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        child: Text(
                                                            'Customer Name',
                                                            //style: content1,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                        //alignment: Alignment.center,
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                kPrimaryColor,
                                                            border: Border(
                                                                right: BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                                top: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                          child: Text(
                                                              'Product Name',
                                                              //style: content1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          alignment:
                                                              Alignment.center,
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                kPrimaryColor,
                                                            border: Border(
                                                                right: BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                                top: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                          child: Text(
                                                              'Order Id',
                                                              //style: content1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          alignment:
                                                              Alignment.center,
                                                        )),
                                                    Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                kPrimaryColor,
                                                            border: Border(
                                                                right: BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                                top: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                          child: Text(
                                                              'Model No', //style: content1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                          alignment:
                                                              Alignment.center,
                                                        )),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        width: 50,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: kPrimaryColor,
                                                          border: Border(
                                                              right: BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                              bottom: BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                              top: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                        ),
                                                        child: Text(
                                                          'Qty', //style: content1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        //alignment: Alignment.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              for (int i = 0;
                                                  i < data.orderDetails.length;
                                                  i++)
                                                AnimationConfiguration
                                                    .staggeredList(
                                                  position: i,
                                                  duration: const Duration(
                                                      milliseconds: 375),
                                                  child: SlideAnimation(
                                                    verticalOffset: 50.0,
                                                    child: FadeInAnimation(
                                                      child: Container(
                                                        height: 50,
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              decoration:
                                                                  BoxDecoration(
                                                                //color: bg,
                                                                border: Border(
                                                                    right: BorderSide(
                                                                        color: Colors
                                                                            .black),
                                                                    bottom: BorderSide(
                                                                        color: Colors
                                                                            .black)),
                                                              ),
                                                              child: Checkbox(
                                                                value: check[i],
                                                                activeColor:
                                                                    kPrimaryColor,
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    check[i] =
                                                                        value;
                                                                    data
                                                                        .orderDetails[
                                                                            i]
                                                                        .isSelected = value;
                                                                  });
                                                                  print(
                                                                      "object remember ${check[i]}");
                                                                  if (check[
                                                                          i] ==
                                                                      true) {
                                                                    send.add(data
                                                                        .orderDetails[
                                                                            i]
                                                                        .orderId);
                                                                  } else {
                                                                    send.remove(data
                                                                        .orderDetails[
                                                                            i]
                                                                        .orderId);
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  //color: bg,
                                                                  border: Border(
                                                                      left: BorderSide(
                                                                          color: Colors
                                                                              .black),
                                                                      right: BorderSide(
                                                                          color: Colors
                                                                              .black),
                                                                      bottom: BorderSide(
                                                                          color:
                                                                              Colors.black)),
                                                                ),
                                                                child: Text(
                                                                  data
                                                                      .orderDetails[
                                                                          i]
                                                                      .customerName,
                                                                  //style: content1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                //alignment: Alignment.center,
                                                              ),
                                                            ),
                                                            Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border(
                                                                        right: BorderSide(
                                                                            color: Colors
                                                                                .black),
                                                                        bottom: BorderSide(
                                                                            color:
                                                                                Colors.black)),
                                                                  ),
                                                                  child: Text(
                                                                    '${data.orderDetails[i].productName}',
                                                                    //style: content1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                )),
                                                            Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border(
                                                                        right: BorderSide(
                                                                            color: Colors
                                                                                .black),
                                                                        bottom: BorderSide(
                                                                            color:
                                                                                Colors.black)),
                                                                  ),
                                                                  child: Text(
                                                                    '${data.orderDetails[i].orderId}',
                                                                    //style: content1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                )),
                                                            Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border(
                                                                        right: BorderSide(
                                                                            color: Colors
                                                                                .black),
                                                                        bottom: BorderSide(
                                                                            color:
                                                                                Colors.black)),
                                                                  ),
                                                                  child: Text(
                                                                    '${data.orderDetails[i].modelNo}',
                                                                    //style: content1,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                )),
                                                            Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border(
                                                                        right: BorderSide(
                                                                            color: Colors
                                                                                .black),
                                                                        bottom: BorderSide(
                                                                            color:
                                                                                Colors.black)),
                                                                  ),
                                                                  child: TextFormField(
                                                                      onChanged: (text) {
                                                                        setState(
                                                                            () {
                                                                          check[i] =
                                                                              true;
                                                                          data.orderDetails[i].isSelected =
                                                                              true;
                                                                          data.orderDetails[i].invoiceTotalStick =
                                                                              text;
                                                                          data.orderDetails[i].invoiceTotalPrice =
                                                                              (int.parse(text) * int.parse(data.orderDetails[i].invoicePrice)).toString();
                                                                          // OrderDetailsUpdate(data.orderDetails[i].orderdetailId,text,(int.parse(text) * int.parse(data.orderDetails[i].invoicePrice)).toString());
                                                                          customerID = data
                                                                              .orderDetails[i]
                                                                              .customerId;
                                                                        });
                                                                      },
                                                                      initialValue: data.orderDetails[i].invoiceTotalStick,
                                                                      maxLines: 1,
                                                                      textAlign: TextAlign.center,
                                                                      maxLength: 4,
                                                                      decoration: InputDecoration(
                                                                        border:
                                                                            InputBorder.none,
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
                                                                      Alignment
                                                                          .center,
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
                                      : _searchResult.length == 0
                                          ? Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(top: 10),
                                              child: Text(
                                                "No Data Found",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ))
                                          : Container(
                                              alignment: Alignment.center,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: 40,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                kPrimaryColor,
                                                            border: Border(
                                                                top: BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                                right: BorderSide(
                                                                    color: Colors
                                                                        .black),
                                                                bottom: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                          ),
                                                          child: Checkbox(
                                                            value: checkAll,
                                                            checkColor:
                                                                kPrimaryColor,
                                                            activeColor:
                                                                Colors.white,
                                                            onChanged: (value) {
                                                              setState(() {
                                                                checkAll =
                                                                    value;
                                                              });
                                                              print(
                                                                  "object remember $checkAll");
                                                              if (checkAll ==
                                                                  true) {
                                                                for (int i = 0;
                                                                    i <
                                                                        data.orderDetails
                                                                            .length;
                                                                    i++) {
                                                                  check[i] =
                                                                      true;
                                                                  send.add(data
                                                                      .orderDetails[
                                                                          i]
                                                                      .orderId);
                                                                }
                                                              } else {
                                                                for (int i = 0;
                                                                    i <
                                                                        data.orderDetails
                                                                            .length;
                                                                    i++) {
                                                                  check[i] =
                                                                      false;
                                                                  send = [];
                                                                }
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  kPrimaryColor,
                                                              border: Border(
                                                                  left: BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                  right: BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                  bottom: BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                  top: BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                            child: Text(
                                                                'Customer Name',
                                                                //style: content1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                            //alignment: Alignment.center,
                                                          ),
                                                        ),
                                                        Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    kPrimaryColor,
                                                                border: Border(
                                                                    right: BorderSide(
                                                                        color: Colors
                                                                            .black),
                                                                    bottom: BorderSide(
                                                                        color: Colors
                                                                            .black),
                                                                    top: BorderSide(
                                                                        color: Colors
                                                                            .black)),
                                                              ),
                                                              child: Text(
                                                                  'Product Name',
                                                                  //style: content1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            )),
                                                        Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    kPrimaryColor,
                                                                border: Border(
                                                                    right: BorderSide(
                                                                        color: Colors
                                                                            .black),
                                                                    bottom: BorderSide(
                                                                        color: Colors
                                                                            .black),
                                                                    top: BorderSide(
                                                                        color: Colors
                                                                            .black)),
                                                              ),
                                                              child: Text(
                                                                  'Order Id',
                                                                  //style: content1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            )),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    kPrimaryColor,
                                                                border: Border(
                                                                    right: BorderSide(
                                                                        color: Colors
                                                                            .black),
                                                                    bottom: BorderSide(
                                                                        color: Colors
                                                                            .black),
                                                                    top: BorderSide(
                                                                        color: Colors
                                                                            .black)),
                                                              ),
                                                              child: Text(
                                                                  'Model No', //style: content1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            )),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width: 50,
                                                            alignment: Alignment
                                                                .center,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  kPrimaryColor,
                                                              border: Border(
                                                                  right: BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                  bottom: BorderSide(
                                                                      color: Colors
                                                                          .black),
                                                                  top: BorderSide(
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                            child: Text(
                                                              'Qty', //style: content1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                                                    AnimationConfiguration
                                                        .staggeredList(
                                                      position: i,
                                                      duration: const Duration(
                                                          milliseconds: 375),
                                                      child: SlideAnimation(
                                                        verticalOffset: 50.0,
                                                        child: FadeInAnimation(
                                                          child: Container(
                                                            height: 50,
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width: 50,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    //color: bg,
                                                                    border: Border(
                                                                        right: BorderSide(
                                                                            color: Colors
                                                                                .black),
                                                                        bottom: BorderSide(
                                                                            color:
                                                                                Colors.black)),
                                                                  ),
                                                                  child:
                                                                      Checkbox(
                                                                    value:
                                                                        check[
                                                                            i],
                                                                    activeColor:
                                                                        kPrimaryColor,
                                                                    onChanged:
                                                                        (value) {
                                                                      setState(
                                                                          () {
                                                                        check[i] =
                                                                            value;
                                                                      });
                                                                      print(
                                                                          "object remember ${check[i]}");
                                                                      if (check[
                                                                              i] ==
                                                                          true) {
                                                                        send.add(
                                                                            _searchResult[i].orderId);
                                                                      } else {
                                                                        send.remove(
                                                                            _searchResult[i].orderId);
                                                                      }
                                                                    },
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 2,
                                                                  child:
                                                                      Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      //color: bg,
                                                                      border: Border(
                                                                          left: BorderSide(
                                                                              color: Colors
                                                                                  .black),
                                                                          right:
                                                                              BorderSide(color: Colors.black),
                                                                          bottom: BorderSide(color: Colors.black)),
                                                                    ),
                                                                    child: Text(
                                                                      _searchResult[
                                                                              i]
                                                                          .customerName,
                                                                      //style: content1,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    //alignment: Alignment.center,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border(
                                                                            right:
                                                                                BorderSide(color: Colors.black),
                                                                            bottom: BorderSide(color: Colors.black)),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        '${_searchResult[i].productName}',
                                                                        //style: content1,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                    )),
                                                                Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border(
                                                                            right:
                                                                                BorderSide(color: Colors.black),
                                                                            bottom: BorderSide(color: Colors.black)),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        '${_searchResult[i].hsnSac}',
                                                                        //style: content1,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                    )),
                                                                Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border(
                                                                            right:
                                                                                BorderSide(color: Colors.black),
                                                                            bottom: BorderSide(color: Colors.black)),
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        '${_searchResult[i].modelNo}',
                                                                        //style: content1,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                    )),
                                                                Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border: Border(
                                                                            right:
                                                                                BorderSide(color: Colors.black),
                                                                            bottom: BorderSide(color: Colors.black)),
                                                                      ),
                                                                      child: TextFormField(
                                                                          onChanged: (text) {
                                                                            setState(() {
                                                                              check[i] = true;
                                                                              _searchResult[i].isSelected = true;
                                                                              _searchResult[i].invoiceTotalStick = text;
                                                                              _searchResult[i].invoiceTotalPrice = (int.parse(text) * int.parse(_searchResult[i].invoicePrice)).toString();
                                                                              // OrderDetailsUpdate(data.orderDetails[i].orderdetailId,text,(int.parse(text) * int.parse(data.orderDetails[i].invoicePrice)).toString());
                                                                              customerID = _searchResult[i].customerId;
                                                                            });
                                                                          },
                                                                          initialValue: _searchResult[i].invoiceTotalStick,
                                                                          maxLines: 1,
                                                                          textAlign: TextAlign.center,
                                                                          maxLength: 4,
                                                                          decoration: InputDecoration(
                                                                            border:
                                                                                InputBorder.none,
                                                                            counter:
                                                                                Offstage(),
                                                                          )),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
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
                      }
                    }),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: invoiceController,
                  decoration: InputDecoration(
                      labelText: "Invoice No",
                      hintText: "Enter Invoice No.",
                      labelStyle: TextStyle(color: kPrimaryColor),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: lrNoController,
                  decoration: InputDecoration(
                      labelText: "LR No",
                      hintText: "Enter LR No.",
                      labelStyle: TextStyle(color: kPrimaryColor),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor))),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: eWayBillViewController,
                  decoration: InputDecoration(
                      labelText: "EWay Bill No",
                      hintText: "Enter EWay Bill No.",
                      labelStyle: TextStyle(color: kPrimaryColor),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kPrimaryColor))),
                ),
                SizedBox(
                  height: 20,
                ),
                DefaultButton(
                  press: () {
                    if (check.contains(true)) {
                      SubmitDispatch();
                    } else {
                      Alerts.showAlertAndBack(
                          context, "Failed", "Please add desire product");
                    }
                  },
                  text: 'Sumbit',
                )
              ],
            )));
  }

  SubmitDispatch() async {
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );
    pr.style(
      message: 'Please wait...',
      progressWidget: Center(
          child: CircularProgressIndicator(
        color: kPrimaryColor,
      )),
    );
    pr.show();

    var response = await http.post(
        Uri.parse(
            "http://loccon.in/desiremoulding/api/ProductionApiController/submitDispatchInvoice"),
        body: {
          'secretkey': Connection.secretKey,
          'orderdetails_list': jsonEncode(od.toPostJson()),
          'dispatch_id': od.dispatchResult[0].dispatchId,
          "customer_id": od.dispatchResult[0].customerId,
          "dispatch_invoice_id": od.dispatchResult[0].dispatchInvoiceId,
          "invoice_no": invoiceController.text,
          "lr_no": lrNoController.text,
          "eway_bill_no": eWayBillViewController.text,
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
      // Alerts.showAlertAndBack(context, "Success", response.body);
    }
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

  onSearchTextChangedICD(String text) async {
    _searchResult.clear();
    print("$text value from search");
    if (text.isEmpty) {
      setState(() {
        search = false;
      });
      return;
    }
    _list.forEach((exp) {
      if (exp.modelNo.toLowerCase().contains(text.toLowerCase()) ||
          exp.productName.toLowerCase().contains(text.toLowerCase()) ||
          exp.customerName.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length} ");
    setState(() {});
  }
}
