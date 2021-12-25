import 'dart:convert';
import 'dart:io';

import 'package:desire_production/bloc/daily_order_list_bloc.dart';
import 'package:desire_production/model/dailyOrderListModel.dart';
import 'package:desire_production/pages/dashboards/production_dashboard_page.dart';
import 'package:desire_production/pages/production/dailyOrdersListByModelNo.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/default_button.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class DailyOrdersPage extends StatefulWidget {
  final String page;

  const DailyOrdersPage({@required this.page});

  @override
  _DailyOrdersPageState createState() => _DailyOrdersPageState();
}

class _DailyOrdersPageState extends State<DailyOrdersPage> {
  TextEditingController _controller3;

  List<bool> check = [];
  bool checkAll = false;
  List<String> send = [];
  TextEditingController searchView;
  bool search = false;
  List<Data> _searchResult = [];
  List<Data> _order = [];
  final DailyOrderListBloc dailyOrderListBloc = DailyOrderListBloc();

  AsyncSnapshot<DailyOrdersListModel> as;

  @override
  void initState() {
    super.initState();
    dailyOrderListBloc.fetchDailyOrderList();
    searchView = TextEditingController();
    _controller3 = TextEditingController(text: DateTime.now().toString());
  }

  @override
  void dispose() {
    super.dispose();
    dailyOrderListBloc.dispose();
    searchView.dispose();
    _controller3.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return widget.page == "production"
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (builder) => DashboardPageProduction(
                          page: widget.page,
                        )),
                (route) => false)
            : Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (builder) => DashboardPageProduction(
                          page: widget.page,
                        )),
                (route) => false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Daily Orders",
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
      ),
    );
  }

  Widget _body() {
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () {
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (builder) => DailyOrdersPage(
                      page: widget.page,
                    )),
            (route) => false);
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: StreamBuilder<DailyOrdersListModel>(
            stream: dailyOrderListBloc.dailyOrderListStream,
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
              if (s.data.data == null) {
                print("as3 empty");
                return Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: Text(
                    "No Orders Found",
                  ),
                );
              }

              as = s;
              _order = s.data.data;

              for (int i = 0; i < s.data.data.length; i++) {
                check.add(false);
              }

              print("object length ${s.data.data.length} ${check.length}");

              return _order.length == 0
                  ? Center(
                      heightFactor: 20,
                      child: Text(
                        "No Daily Orders Available",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _searchResult.length == 0
                              ? Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                    left: BorderSide(
                                                        color: Colors.black),
                                                    right: BorderSide(
                                                        color: Colors.black),
                                                    bottom: BorderSide(
                                                        color: Colors.black),
                                                    top: BorderSide(
                                                        color: Colors.black)),
                                              ),
                                              child: Text(
                                                'Sr No.', //style: content1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              //alignment: Alignment.center,
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    border: Border(
                                                        right: BorderSide(
                                                            color:
                                                                Colors.black),
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.black),
                                                        top: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  child: Text(
                                                    'Model Number', //style: content1,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  alignment: Alignment.center,
                                                )),
                                            Expanded(
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
                                                'Qty', //style: content1,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                            )),
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
                                                        i < s.data.data.length;
                                                        i++) {
                                                      check[i] = true;
                                                      send.add(s.data.data[i]
                                                          .dailyOrderId);
                                                    }
                                                  } else {
                                                    for (int i = 0;
                                                        i < s.data.data.length;
                                                        i++) {
                                                      check[i] = false;
                                                      send = [];
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                            Expanded(
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
                                                'Details',
                                                style: TextStyle(
                                                    color: Colors
                                                        .white), //style: content1,
                                                textAlign: TextAlign.center,
                                              ),
                                              alignment: Alignment.center,
                                            )),
                                          ],
                                        ),
                                      ),
                                      for (int i = 0;
                                          i < s.data.data.length;
                                          i++)
                                        s.data.data.length == 0
                                            ? Container(
                                                height: 300,
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "No Orders Found",
                                                ),
                                              )
                                            : AnimationConfiguration
                                                .staggeredList(
                                                position: i,
                                                duration: const Duration(
                                                    milliseconds: 375),
                                                child: SlideAnimation(
                                                  verticalOffset: 50.0,
                                                  child: FadeInAnimation(
                                                    child: Container(
                                                      height: 40,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            width: 50,
                                                            alignment: Alignment
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
                                                                      color: Colors
                                                                          .black)),
                                                            ),
                                                            child: Text(
                                                              '${i + 1}', //style: content1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            //alignment: Alignment.center,
                                                          ),
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
                                                                          color:
                                                                              Colors.black)),
                                                                ),
                                                                child: Text(
                                                                  '${s.data.data[i].modelNo}', //style: content1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                              )),
                                                          Expanded(
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
                                                              '${s.data.data[i].qty}', //style: content1,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            alignment: Alignment
                                                                .center,
                                                          )),
                                                          Container(
                                                            width: 50,
                                                            alignment: Alignment
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
                                                                });
                                                                print(
                                                                    "object remember ${check[i]}");
                                                                if (check[i] ==
                                                                    true) {
                                                                  send.add(s
                                                                      .data
                                                                      .data[i]
                                                                      .dailyOrderId);
                                                                } else {
                                                                  send.remove(s
                                                                      .data
                                                                      .data[i]
                                                                      .dailyOrderId);
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child:
                                                                  GestureDetector(
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          DailyOrdersListByModelNumber(
                                                                            modelNoId:
                                                                                s.data.data[i].modelNoId,
                                                                            modelNo:
                                                                                s.data.data[i].modelNo,
                                                                            status:
                                                                                1,
                                                                          )));
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
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
                                                                'View Details',
                                                                style: TextStyle(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline,
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        kPrimaryColor), //style: content1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                            ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                    left: BorderSide(
                                                        color: Colors.black),
                                                    right: BorderSide(
                                                        color: Colors.black),
                                                    bottom: BorderSide(
                                                        color: Colors.black),
                                                    top: BorderSide(
                                                        color: Colors.black)),
                                              ),
                                              child: Text(
                                                'Sr No.',
                                                style: TextStyle(
                                                    color: Colors
                                                        .white), //style: content1,
                                                textAlign: TextAlign.center,
                                              ),
                                              //alignment: Alignment.center,
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: kPrimaryColor,
                                                    border: Border(
                                                        right: BorderSide(
                                                            color:
                                                                Colors.black),
                                                        bottom: BorderSide(
                                                            color:
                                                                Colors.black),
                                                        top: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  child: Text(
                                                    'Model Number',
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white), //style: content1,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  alignment: Alignment.center,
                                                )),
                                            Expanded(
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
                                                'Qty',
                                                style: TextStyle(
                                                    color: Colors
                                                        .white), //style: content1,
                                                textAlign: TextAlign.center,
                                              ),
                                              alignment: Alignment.center,
                                            )),
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
                                                checkColor: Colors.white,
                                                onChanged: (value) {
                                                  setState(() {
                                                    checkAll = value;
                                                  });
                                                  print(
                                                      "object remember $checkAll");
                                                  if (checkAll == true) {
                                                    for (int i = 0;
                                                        i <
                                                            _searchResult
                                                                .length;
                                                        i++) {
                                                      check[i] = true;
                                                      send.add(_searchResult[i]
                                                          .dailyOrderId);
                                                    }
                                                  } else {
                                                    for (int i = 0;
                                                        i <
                                                            _searchResult
                                                                .length;
                                                        i++) {
                                                      check[i] = false;
                                                      send = [];
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                            Expanded(
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
                                                'Details',
                                                style: TextStyle(
                                                    color: Colors
                                                        .white), //style: content1,
                                                textAlign: TextAlign.center,
                                              ),
                                              alignment: Alignment.center,
                                            )),
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
                                                height: 40,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        //color: bg,
                                                        border: Border(
                                                            left: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                      child: Text(
                                                        '${i + 1}',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .bold), //style: content1,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      //alignment: Alignment.center,
                                                    ),
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
                                                            '${_searchResult[i].modelNo}',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold), //style: content1,
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          alignment:
                                                              Alignment.center,
                                                        )),
                                                    Expanded(
                                                        child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                            right: BorderSide(
                                                                color: Colors
                                                                    .black),
                                                            bottom: BorderSide(
                                                                color: Colors
                                                                    .black)),
                                                      ),
                                                      child: Text(
                                                        '${_searchResult[i].qty}',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight
                                                                .bold), //style: content1,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
                                                    Container(
                                                      width: 50,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
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
                                                        onChanged: (value) {
                                                          setState(() {
                                                            check[i] = value;
                                                          });
                                                          print(
                                                              "object remember ${check[i]}");
                                                          if (check[i] ==
                                                              true) {
                                                            send.add(
                                                                _searchResult[i]
                                                                    .dailyOrderId);
                                                          } else {
                                                            send.remove(
                                                                _searchResult[i]
                                                                    .dailyOrderId);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        DailyOrdersListByModelNumber(
                                                                          modelNoId:
                                                                              _searchResult[i].modelNoId,
                                                                          modelNo:
                                                                              _searchResult[i].modelNo,
                                                                          status:
                                                                              1,
                                                                        )));
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
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
                                                          'View Details',
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              fontSize: 14,
                                                              color:
                                                                  kPrimaryColor), //style: content1,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                      ),
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
                          send.length > 0
                              ? Padding(
                                  padding: const EdgeInsets.all(50),
                                  child: DefaultButton(
                                    text: "Submit",
                                    press: () async {
                                      sendToDailyProduction(send.toString());
                                    },
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(50),
                                  child: DefaultButtonGrey(
                                    text: "Submit",
                                    press: () {},
                                  ),
                                )
                        ],
                      ),
                    );
            }),
      ),
    );
  }

  sendToDailyProduction(String value) async {
    print("Id" + value);
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
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
            "http://loccon.in/desiremoulding/api/ProductionApiController/dailyOrderToDailyProduction"),
        body: {
          'secretkey': Connection.secretKey,
          'id': "$value",
        });
    print("object ${response.body}");

    var results = json.decode(response.body);
    print("object $results");
    pr.hide();
    if (results['status'] == true) {
      print("user details ${results['data']}");
      Alerts.showAlertAndBackPro(context, "Success",
          "Successfully Order Sent To Production", widget.page);
    } else {
      Alerts.showAlertAndBackPro(context, "Something Went Wrong",
          "Could not send to Production", widget.page);
    }
  }

  final pdf = pw.Document();

  generatePdf() {
    pdf.addPage(pw.MultiPage(
      margin: pw.EdgeInsets.all(15),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      pageFormat: PdfPageFormat.standard,
      build: (context) {
        return <pw.Widget>[
          pw.Header(
              level: 5,
              child: pw.Text("Product List | Desire Moulding",
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
                itemCount: as.data.data.length,
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
                                '${as.data.data[i].modelNo}',
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
                                '${as.data.data[i].qty}',
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
                            '${as.data.data[i].modelNo}',
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
                            '${as.data.data[i].qty}',
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

  String path;
  Future savePdf() async {
    if (await _reqPer(Permission.storage)) {
      var dir = await DownloadsPathProvider.downloadsDirectory;
      print("object directory path ${dir.path}");
      File file = File(dir.path + "/ProductList.pdf");
      path = dir.path + "/ProductList.pdf";

      print(path);
      file.writeAsBytesSync(List.from(await pdf.save()));
      print("path of file open $path");
      Alerts.showAlertPdf(context, 'Product List', 'Pdf Generated', path);
    }
  }

  final pdf1 = pw.Document();

  generatePdfSearch() {
    pdf1.addPage(pw.MultiPage(
      margin: pw.EdgeInsets.all(15),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      pageFormat: PdfPageFormat.standard,
      build: (context) {
        return <pw.Widget>[
          pw.Header(
              level: 5,
              child: pw.Text("Product List | Desire Moulding",
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
                itemCount: as.data.data.length,
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
                                '${as.data.data[i].modelNo}',
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
                                '${as.data.data[i].qty}',
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
                            '${as.data.data[i].modelNo}',
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
                            '${as.data.data[i].qty}',
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

  String path1;
  Future savePdfSearch() async {
    if (await _reqPer(Permission.storage)) {
      var dir = await DownloadsPathProvider.downloadsDirectory;
      print("object directory path ${dir.path}");
      File file = File(dir.path + "/ProductList.pdf");
      path1 = dir.path + "/ProductList.pdf";

      print(path1);
      file.writeAsBytesSync(List.from(await pdf1.save()));
      print("path of file open $path1");
      Alerts.showAlertPdf(context, 'Product List', '  Pdf Generated', path1);
    }
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

    _order.forEach((exp) {
      if (exp.modelNo.contains(text)) _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }
}
