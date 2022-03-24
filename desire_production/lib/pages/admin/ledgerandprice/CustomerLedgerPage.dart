import 'dart:convert';
import 'dart:io';

import 'package:desire_production/bloc/LedgerBloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/LedgerModel.dart';
import 'package:desire_production/pages/admin/ledgerandprice/ledgerfilterpage.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class CustomerLedgerPage extends StatefulWidget {
  const CustomerLedgerPage({Key key}) : super(key: key);

  @override
  _CustomerLedgerPageState createState() => _CustomerLedgerPageState();
}

class _CustomerLedgerPageState extends State<CustomerLedgerPage> {
  var ledgerBloc = LedgerBloc();
  List<CustomerLedger> asyncSnapshot;
  LedgerModel ledgermodel;
  bool isVisible = false;
  TextEditingController searchView;
  bool search = false;
  List<CustomerLedger> _searchResult = [];

  List<CustomerLedger> as;
  TextEditingController fromDateinput = TextEditingController();
  TextEditingController toDateinput = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ledgerBloc.fetchLedger();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ledgerBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kBlackColor),
        titleTextStyle: TextStyle(color: kBlackColor, fontSize: 18.0),
        title: Text("Ledger Details"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: _searchView(),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         setState(() {
        //           if (isVisible) {
        //             isVisible = false;
        //           } else {
        //             isVisible = true;
        //           }
        //         });
        //       },
        //       icon: Icon(
        //         Icons.filter_list,
        //         size: 30,
        //         color: kPrimaryColor,
        //       ))
        // ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          generatePdf();
          savePdf(context);
        },
        label: Text(
          "Generate PDF",
          style: TextStyle(color: kWhite),
        ),
        icon: Icon(
          Icons.add,
          color: kWhite,
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder<LedgerModel>(
        stream: ledgerBloc.ledgerStream,
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
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: SelectableText(
                "Error Loading Data ${s.error}",
              ),
            );
          } else if (s.data.toString().isEmpty) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          } else if (s.data.customerLedger.length == 0) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          } else {
            asyncSnapshot = s.data.customerLedger;
            as = s.data.customerLedger;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSize(
                      duration: Duration(milliseconds: 1000),
                      child: Container(
                          height: !isVisible ? 0.0 : null,
                          child: Visibility(
                              visible: isVisible,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          margin: const EdgeInsets.only(top: 5),
                                          padding: const EdgeInsets.all(10.0),
                                          child: TextField(
                                            controller: fromDateinput,
                                            //editing controller of this TextField
                                            decoration: InputDecoration(
                                                prefixIcon:
                                                    Icon(Icons.date_range),
                                                hintText: "Enter Start Date",
                                                hintStyle: TextStyle(
                                                    color: kSecondaryColor,
                                                    fontSize: 12),
                                                labelText: "Start Date",
                                                labelStyle: TextStyle(
                                                    color: kPrimaryColor),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                kPrimaryColor)),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: kPrimaryColor))),
                                            readOnly: true,
                                            //set it true, so that user will not able to edit text
                                            onTap: () async {
                                              DateTime pickedDate =
                                                  await showDatePicker(
                                                      context: context,
                                                      initialDate:
                                                          DateTime.now(),
                                                      firstDate: DateTime(2000),
                                                      //DateTime.now() - not to allow to choose before today.
                                                      lastDate: DateTime(2101));

                                              if (pickedDate != null) {
                                                print(
                                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

                                                setState(() {
                                                  fromDateinput.text =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(pickedDate);
                                                  //set output date to TextField value.
                                                });
                                              } else {
                                                print("Date is not selected");
                                              }
                                            },
                                          )),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        margin: const EdgeInsets.only(top: 5),
                                        padding: EdgeInsets.all(10),
                                        child: TextField(
                                          controller: toDateinput,
                                          //editing controller of this TextField
                                          decoration: InputDecoration(
                                              prefixIcon:
                                                  Icon(Icons.date_range),
                                              hintText: "Enter End Date",
                                              hintStyle: TextStyle(
                                                  color: kSecondaryColor,
                                                  fontSize: 12),
                                              labelText: "End Date",
                                              labelStyle: TextStyle(
                                                  color: kPrimaryColor),
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimaryColor)),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimaryColor))),
                                          readOnly: true,
                                          //set it true, so that user will not able to edit text
                                          onTap: () async {
                                            DateTime pickedDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2000),
                                                    lastDate: DateTime(2101));

                                            if (pickedDate != null) {
                                              print(
                                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

                                              setState(() {
                                                toDateinput.text = DateFormat(
                                                        'yyyy-MM-dd')
                                                    .format(
                                                        pickedDate); //set output date to TextField value.
                                              });
                                            } else {
                                              print("Date is not selected");
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: kPrimaryColor,
                                            textStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (fromDateinput.text != "" &&
                                                  toDateinput.text != "") {
                                                // filterLedgerList(
                                                //     widget.customerId);
                                              } else {
                                                final snackBar = SnackBar(
                                                    content: Text(
                                                        "Please Enter Start Date and End Date."));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            });
                                          },
                                          child: const Text('Filter',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: kPrimaryColor,
                                            textStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              fromDateinput.clear();
                                              toDateinput.clear();
                                              asyncSnapshot.clear();
                                              ledgerBloc.fetchLedger();
                                            });
                                          },
                                          child: const Text(
                                            'Clear Filter',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )))),
                  ...List.generate(
                      _searchResult.length == 0
                          ? asyncSnapshot.length
                          : _searchResult.length,
                      (index) => LedgerListTile(
                            customerLedger: _searchResult.length == 0
                                ? asyncSnapshot[index]
                                : _searchResult[index],
                          ))
                ],
              ),
            );
          }
        });
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

    asyncSnapshot.forEach((exp) {
      if (exp.accountName.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }

  String path;

  Future savePdf(BuildContext context) async {
    if (await _reqPer(Permission.storage)) {
      var dir = await DownloadsPathProvider.downloadsDirectory;
      print("object directory path ${dir.path}");
      File file = File(dir.path + "/Ledger.pdf");
      path = dir.path + "/Ledger.pdf";

      print(path);
      file.writeAsBytesSync(List.from(await pdf.save()));
      print("path of file open $path");
      Alerts.showAlertPdf(context, 'Desire', 'Pdf Generated', path);
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

  final pdf = pw.Document();

  generatePdf() {
    print("total lenght" + asyncSnapshot.length.toString());
    pdf.addPage(pw.MultiPage(
      margin: pw.EdgeInsets.all(15),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return <pw.Widget>[
          pw.Header(
              level: 5,
              child: pw.Text("Ledger | Desire Moulding",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 40,
                    color: PdfColor.fromHex('#4684C2'),
                    fontWeight: pw.FontWeight.bold,
                  ))),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  child: pw.Text(
                    'Name',
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
                    'Cr.',
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
                    'Dr.',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 15),
                    textAlign: pw.TextAlign.center,
                  ),
                  width: 60,
                  height: 52,
                  alignment: pw.Alignment.center,
                ),
                pw.Container(
                  child: pw.Text(
                    'Total Amount',
                    style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold, fontSize: 15),
                    textAlign: pw.TextAlign.center,
                  ),
                  width: 60,
                  height: 52,
                  alignment: pw.Alignment.center,
                ),
              ]),
          pw.SizedBox(height: 30),
          pw.ListView.builder(
              //padding: pw.EdgeInsets.only(bottom: 10),
              itemCount: as.length,
              itemBuilder: (c, i) {
                return pw.Container(
                    color: PdfColor.fromHex('#E0F7FA'),
                    margin: pw.EdgeInsets.only(top: 5, bottom: 5),
                    child: pw.Flexible(
                        child: pw.Column(
                  children: [
                    pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          as[i].accountName == null
                              ? pw.Text("N/A")
                              : pw.Container(
                                  width: 130,
                                  child: pw.Text(as[i].accountName,
                                      textAlign: pw.TextAlign.center,
                                      overflow: pw.TextOverflow.clip,
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold))),
                          as[i].totalCreditAmount != ""
                              ? pw.Text(
                                  "${as[i].totalCreditAmount} Cr ",
                                  style: pw.TextStyle(
                                      color: PdfColor.fromHex('#000000'),
                                      fontWeight: pw.FontWeight.bold),
                                )
                              : pw.Container(),
                          as[i].totalDebitAmount != ""
                              ? pw.Text("${as[i].totalDebitAmount} Dr ",
                                  style: pw.TextStyle(
                                      color: PdfColor.fromHex('#000000'),
                                      fontWeight: pw.FontWeight.bold))
                              : pw.Container(),
                          as[i].totalAmount == ""
                              ? pw.Text("")
                              : pw.Text(as[i].totalAmount,
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold))
                        ]),
                    pw.SizedBox(
                      height: 10,
                    )
                  ],
                )));
              })
        ];
      },
    ));
  }

  void filterLedgerList(customerId) async {
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
    var response = await http.post(
        Uri.parse(
            "http://loccon.in/desiremoulding/api/AdminApiController/customerLedgerFilter"),
        body: {
          'secretkey': Connection.secretKey,
          'customer_id': customerId,
          'start_date': fromDateinput.text,
          'end_date': toDateinput.text
        });

    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true) {
      var result = json.decode(response.body);
      print("ledger list response $result");

      ledgermodel = LedgerModel.fromJson(result);
      setState(() {
        if (ledgermodel.customerLedger != null &&
            ledgermodel.customerLedger.length > 0) {
          asyncSnapshot.clear();
          asyncSnapshot.addAll(ledgermodel.customerLedger);
        }
      });
      print(ledgermodel.customerLedger.length);
      // final snackBar = SnackBar(
      //     content: Row(
      //       children: [
      //         Text(results['message']),
      //       ],
      //     ));
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);

      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>AccessoryDetailPage(product: widget.product,page: widget.page,snapshot: widget.snapshot,status: true, orderCount: widget.orderCount,)), (route) => false);
    } else {
      if (results['customerLedger'] != null &&
          results['customerLedger'].length > 0) {
        final snackBar = SnackBar(content: Text(results['message'].toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    pr.hide();
  }
}

class LedgerListTile extends StatelessWidget {
  final CustomerLedger customerLedger;

  const LedgerListTile({Key key, this.customerLedger}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LedgerFilter(customerId: customerLedger.customerId);
          }));
        },
        child: Container(
          margin: EdgeInsets.all(5),
          height: 90,
          padding: EdgeInsets.all(5),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: kSecondaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                      text: 'Name : ',
                      style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: customerLedger.accountName,
                          style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                ),
              ),
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                      text: 'Total Credit Amount : ',
                      style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: customerLedger.totalCreditAmount,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                ),
              ),
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                      text: 'Total Debit Amount : ',
                      style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: customerLedger.totalDebitAmount,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                ),
              ),
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                      text: 'Total Amount : ',
                      style: TextStyle(
                          color: kSecondaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: customerLedger.totalAmount,
                          style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                ),
              )
            ],
          ),
        ));
  }
}
