import 'package:desire_users/bloc/invoice_detail_bloc.dart';
import 'package:desire_users/models/invoice_detail_model.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';

import 'package:pdf/widgets.dart' as pw;

class InvoiceDetailPage extends StatefulWidget{
  final id;

  const InvoiceDetailPage({Key key, this.id}) : super(key: key);

  @override
  _InvoiceDetailPageState createState() => _InvoiceDetailPageState();

}
class _InvoiceDetailPageState extends State<InvoiceDetailPage>{
  InvoiceDetailBloc invoiceDetailBloc = InvoiceDetailBloc();
  List<bool> check = [];
  bool checkAll = false;

  List<String> send = [];
  AsyncSnapshot<InvoiceDetailModel> as;
  TextEditingController searchView;
  bool search = false;
  List<InvoiceProducts> _searchResult = [];
  List<InvoiceProducts> _order = [];

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
        iconTheme: IconThemeData(
            color: kBlackColor
        ),
        title: Text("Invoice Detail"),
        titleTextStyle: TextStyle(color: kBlackColor,fontSize: 18,fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: _body(),
    );


  }

  Widget _body() {
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () {
        // return Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //         builder: (builder) => InvoiceDetailPage(
        //           page: widget.page,
        //         )),
        //         (route) => false);
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

              as = s;
              _order = s.data.invoiceProducts;

              for (int i = 0; i < s.data.invoiceProducts.length; i++) {
                check.add(false);
              }

              print("object length ${s.data.invoiceProducts.length} ${check.length}");

              return Container(
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
                                                color: Colors.black),
                                            bottom: BorderSide(
                                                color: Colors.black),
                                            top: BorderSide(
                                                color: Colors.black)),
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
                                /*Container(
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    border: Border(top: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                  ),
                                  child: Checkbox(
                                    value: checkAll,
                                    checkColor:kPrimaryColor,
                                    activeColor: Colors.white,
                                    onChanged: (value) {
                                      setState(() {
                                        checkAll = value;
                                      });
                                      print("object remember $checkAll");
                                      if(checkAll == true){
                                        for(int i=0; i<s.data.data.length; i++){
                                          check[i] = true;
                                          send.add(s.data.data[i].dailyProductionId);
                                        }
                                      } else{
                                        for(int i=0; i<s.data.data.length; i++){
                                          check[i] = false;
                                          send = [];
                                        }
                                      }
                                    },
                                  ),
                                ),*/
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
                                        style: TextStyle(color: Colors.white),
                                        //style: content1,
                                        textAlign: TextAlign.center,
                                      ),
                                      alignment: Alignment.center,
                                    )),
                              ],
                            ),
                          ),
                          for (int i = 0; i < s.data.invoiceProducts.length; i++)
                            s.data.invoiceProducts.length == 0
                                ? Container(
                              height: 300,
                              alignment: Alignment.center,
                              child: Text(
                                "No Orders Found",
                              ),
                            )
                                : AnimationConfiguration.staggeredList(
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
                                            '${i + 1}', //style: content1,
                                            textAlign:
                                            TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
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
                                                        color: Colors
                                                            .black)),
                                              ),
                                              child: Text(
                                                '${s.data.invoiceProducts[i].modelNoId}',
                                                //style: content1,
                                                textAlign: TextAlign
                                                    .center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors
                                                        .black,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
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
                                                '${s.data.invoiceProducts[i].productQuantity}',
                                                //style: content1,
                                                textAlign:
                                                TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              ),
                                              alignment:
                                              Alignment.center,
                                            )),
                                        /* Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            //color: bg,
                                            border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                          ),
                                          child: Checkbox(
                                            value: check[i],
                                            activeColor: kPrimaryColor,
                                            onChanged: (value) {
                                              setState(() {
                                                check[i] = value;
                                              });
                                              print("object remember ${check[i]}");
                                              if(check[i] == true){
                                                send.add(s.data.data[i].dailyProductionId);
                                              } else{
                                                send.remove(s.data.data[i].dailyProductionId);
                                              }
                                            },
                                          ),
                                        ),*/
                                        Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder:
                                                //             (context) =>
                                                //             DailyProductionListByModelNumber(
                                                //               modelNoId: s
                                                //                   .data
                                                //                   .data[i]
                                                //                   .modelNoId,
                                                //               modelNo: s
                                                //                   .data
                                                //                   .data[i]
                                                //                   .modelNo,
                                                //               dailyProductionId: s
                                                //                   .data
                                                //                   .data[i]
                                                //                   .dailyProductionId,
                                                //             )));
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
                                                      kPrimaryColor),
                                                  //style: content1,
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
                                    style: TextStyle(color: Colors.white),
                                    //style: content1,
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
                                                color: Colors.black),
                                            bottom: BorderSide(
                                                color: Colors.black),
                                            top: BorderSide(
                                                color: Colors.black)),
                                      ),
                                      child: Text(
                                        'Model Number',
                                        style: TextStyle(
                                            color: Colors.white),
                                        //style: content1,
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
                                        style: TextStyle(color: Colors.white),
                                        //style: content1,
                                        textAlign: TextAlign.center,
                                      ),
                                      alignment: Alignment.center,
                                    )),
                                /* Container(
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    border: Border(top: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                  ),
                                  child: Checkbox(
                                    value: checkAll,
                                    checkColor: Colors.white,
                                    onChanged: (value) {
                                      setState(() {
                                        checkAll = value;
                                      });
                                      print("object remember $checkAll");
                                      if(checkAll == true){
                                        for(int i=0; i<_searchResult.length; i++){
                                          check[i] = true;
                                          send.add(_searchResult[i].dailyProductionId);
                                        }
                                      } else{
                                        for(int i=0; i<_searchResult.length; i++){
                                          check[i] = false;
                                          send = [];
                                        }
                                      }
                                    },
                                  ),
                                ),*/
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
                                        style: TextStyle(color: Colors.white),
                                        //style: content1,
                                        textAlign: TextAlign.center,
                                      ),
                                      alignment: Alignment.center,
                                    )),
                              ],
                            ),
                          ),
                          for (int i = 0; i < _searchResult.length; i++)
                            AnimationConfiguration.staggeredList(
                              position: i,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Container(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            //color: bg,
                                            border: Border(
                                                left: BorderSide(
                                                    color: Colors.black),
                                                right: BorderSide(
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                          child: Text(
                                            '${i + 1}',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.bold),
                                            //style: content1,
                                            textAlign: TextAlign.center,
                                          ),
                                          //alignment: Alignment.center,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        color:
                                                        Colors.black),
                                                    bottom: BorderSide(
                                                        color: Colors
                                                            .black)),
                                              ),
                                              child: Text(
                                                '${_searchResult[i].modelNoId}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold),
                                                //style: content1,
                                                textAlign:
                                                TextAlign.center,
                                              ),
                                              alignment: Alignment.center,
                                            )),
                                        Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        color: Colors.black),
                                                    bottom: BorderSide(
                                                        color: Colors.black)),
                                              ),
                                              child: Text(
                                                '${_searchResult[i].productQuantity}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold),
                                                //style: content1,
                                                textAlign: TextAlign.center,
                                              ),
                                              alignment: Alignment.center,
                                            )),
                                        /*Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            //color: bg,
                                            border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                          ),
                                          child: Checkbox(
                                            value: check[i],
                                            activeColor: kPrimaryColor,
                                            onChanged: (value) {
                                              setState(() {
                                                check[i] = value;
                                              });
                                              print("object remember ${check[i]}");
                                              if(check[i] == true){
                                                send.add(_searchResult[i].dailyProductionId);
                                              } else{
                                                send.remove(_searchResult[i].dailyProductionId);
                                              }
                                            },
                                          ),
                                        ),*/
                                        Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                // Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             DailyOrdersListByModelNumber(
                                                //               modelNoId:
                                                //               _searchResult[
                                                //               i]
                                                //                   .modelNoId,
                                                //               modelNo:
                                                //               _searchResult[
                                                //               i]
                                                //                   .modelNo,
                                                //               status: 2,
                                                //             )));
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
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
                                                  'View Details',
                                                  style: TextStyle(
                                                      decoration:
                                                      TextDecoration
                                                          .underline,
                                                      fontSize: 14,
                                                      color: kPrimaryColor),
                                                  //style: content1,
                                                  textAlign: TextAlign.center,
                                                ),
                                                alignment: Alignment.center,
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
                  ],
                ),
              );
            }),
      ),
    );
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
                itemCount: as.data.invoiceProducts.length,
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
                                '${as.data.invoiceProducts[i].modelNoId}',
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
                                '${as.data.invoiceProducts[i].productQuantity}',
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
                            '${as.data.invoiceProducts[i].modelNoId}',
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
                            '${as.data.invoiceProducts[i].productQuantity}',
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