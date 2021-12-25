import 'dart:io';

import 'package:desire_production/bloc/ready_stock_list_bloc.dart';
import 'package:desire_production/model/readyStockListModel.dart';
import 'package:desire_production/pages/dashboards/dashboard_page_warhouse.dart';
import 'package:desire_production/pages/warehouse/ready_stock_detail_page.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class ReadyStockListPage extends StatefulWidget {
  final String page;

  const ReadyStockListPage({@required this.page});

  @override
  _ReadyStockListPageListPageState createState() =>
      _ReadyStockListPageListPageState();
}

class _ReadyStockListPageListPageState extends State<ReadyStockListPage> {
  final ReadyStockListBloc readyToDispatchBloc = ReadyStockListBloc();

  AsyncSnapshot<ReadyStockListModel> as;

  TextEditingController searchView;

  bool search = false;
  List<ReadyStock> _searchResult = [];
  List<ReadyStock> _list = [];

  @override
  void initState() {
    super.initState();
    searchView = TextEditingController();
    readyToDispatchBloc.fetchreadyStockList();
  }

  @override
  void dispose() {
    super.dispose();
    searchView.dispose();
    readyToDispatchBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return widget.page == "warHouse"
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (builder) => DashboardPageWarehouse(
                          page: widget.page,
                        )),
                (route) => false)
            : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (builder) => DashboardPageWarehouse(
                          page: widget.page,
                        )),
              );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            PopupMenuButton(
                icon: Icon(
                  Icons.settings_outlined,
                  color: Colors.black,
                ),
                itemBuilder: (b) => [
                      PopupMenuItem(
                          child: TextButton(
                        child: Text(
                          "Generate PDF",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          print(
                              "object search result inside pdf ${_searchResult.length}");
                          Navigator.pop(context);
                          _searchResult.length == 0
                              ? generatePdf()
                              : generatePdfSearch();
                          _searchResult.length == 0
                              ? savePdf()
                              : savePdfSearch();
                        },
                      )),
                      PopupMenuItem(
                          child: TextButton(
                        child: Text(
                          "Log Out",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Alerts.showLogOut(
                              context, "Log Out", "Are you sure?");
                        },
                      )),
                    ])
          ],
          title: Text(
            "Ready Stock List",
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
          return widget.page == "warHouse"
              ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (builder) =>
                          ReadyStockListPage(page: 'warHouse')),
                  (route) => false)
              : Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => ReadyStockListPage(page: 'admin')),
                );
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            physics: AlwaysScrollableScrollPhysics(),
            child: StreamBuilder<ReadyStockListModel>(
                stream: readyToDispatchBloc.readyStockStream,
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
                    _list = s.data.readyStockList;
                    as = s;
                    _list == null
                        ? print("0")
                        : print("Length" + _list.length.toString());
                    return _list == null
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 40,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: kPrimaryColor,
                                                      border: Border(
                                                          left: BorderSide(
                                                              color:
                                                                  Colors.black),
                                                          right: BorderSide(
                                                              color:
                                                                  Colors.black),
                                                          bottom: BorderSide(
                                                              color:
                                                                  Colors.black),
                                                          top: BorderSide(
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                    child: Text(
                                                        'Sr No.', //style: content1,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    //alignment: Alignment.center,
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      decoration: BoxDecoration(
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
                                                          'Model No', //style: content1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      decoration: BoxDecoration(
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
                                                          'quantity', //style: content1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      decoration: BoxDecoration(
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
                                                          '', //style: content1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
                                              ],
                                            ),
                                          ),
                                          for (int i = 0;
                                              i < s.data.readyStockList.length;
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
                                                        Expanded(
                                                          child: Container(
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
                                                            ),
                                                            //alignment: Alignment.center,
                                                          ),
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
                                                                '${s.data.readyStockList[i].modelNo}', //style: content1,
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
                                                                '${s.data.readyStockList[i].quantity}', //style: content1,
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
                                                                GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            ReadyStockDetailPage(
                                                                              modelNoId: s.data.readyStockList[i].modelNoId,
                                                                              modelNo: s.data.readyStockList[i].modelNo,
                                                                              status: 1,
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
                                                                          color:
                                                                              Colors.black)),
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
                                                            ))
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 40,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    width: 50,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: kPrimaryColor,
                                                      border: Border(
                                                          left: BorderSide(
                                                              color:
                                                                  Colors.black),
                                                          right: BorderSide(
                                                              color:
                                                                  Colors.black),
                                                          bottom: BorderSide(
                                                              color:
                                                                  Colors.black),
                                                          top: BorderSide(
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                    child: Text(
                                                        'Sr No.', //style: content1,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    //alignment: Alignment.center,
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      decoration: BoxDecoration(
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
                                                          'Model No', //style: content1,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      decoration: BoxDecoration(
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
                                                              color: Colors
                                                                  .white)),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
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
                                                        Expanded(
                                                          child: Container(
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
                                                            ),
                                                            //alignment: Alignment.center,
                                                          ),
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
                                                                '${_searchResult[i].modelNo}', //style: content1,
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
                                                                '${_searchResult[i].quantity}', //style: content1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
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
                })));
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
                      'Model Number',
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
                itemCount: as.data.readyStockList.length,
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
                                '${as.data.readyStockList[i].modelNo}',
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
                                '${as.data.readyStockList[i].quantity}',
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
                            '${as.data.readyStockList[i].modelNo}',
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
                            '${as.data.readyStockList[i].quantity}',
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
      File file = File(dir.path + "/WarehouseList.pdf");
      path = dir.path + "/WarehouseList.pdf";

      print(path);
      file.writeAsBytesSync(List.from(await pdf.save()));
      print("path of file open $path");
      Alerts.showAlertPdf(context, 'Warehouse List', 'Pdf Generated', path);
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
                      'Model Number',
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
                itemCount: as.data.readyStockList.length,
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
                                '${as.data.readyStockList[i].modelNo}',
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
                                '${as.data.readyStockList[i].quantity}',
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
                            '${as.data.readyStockList[i].modelNo}',
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
                            '${as.data.readyStockList[i].quantity}',
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
      File file = File(dir.path + "/WarehouseList.pdf");
      path1 = dir.path + "/WarehouseList.pdf";

      print(path1);
      file.writeAsBytesSync(List.from(await pdf1.save()));
      print("path of file open $path1");
      Alerts.showAlertPdf(context, 'Warehouse List', 'Pdf Generated', path1);
    }
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

    _list.forEach((exp) {
      if (exp.modelNo.contains(text)) _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
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
}
