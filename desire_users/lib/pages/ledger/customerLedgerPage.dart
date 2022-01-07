import 'dart:convert';

import 'package:desire_users/bloc/ledger_bloc.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/models/ledger_model.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class CustomerLedgerPage extends StatefulWidget {
  final customerId;

  const CustomerLedgerPage({Key key, this.customerId}) : super(key: key);

  @override
  _CustomerLedgerPageState createState() => _CustomerLedgerPageState();
}

class _CustomerLedgerPageState extends State<CustomerLedgerPage> {
  var ledgerBloc = LedgerBloc();
  List<CustomerLedger> asyncSnapshot;
  LedgerModel ledgermodel;

  List<CustomerLedger> as;
  TextEditingController fromDateinput = TextEditingController();
  TextEditingController toDateinput = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ledgerBloc.fetchLedger(widget.customerId);
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
        backgroundColor: kWhiteColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: kBlackColor),
        titleTextStyle: TextStyle(color: kBlackColor, fontSize: 18.0),
        title: Text("Ledger Details"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          generatePdf();
          savePdf(context);
        },
        label: Text(
          "Generate PDF",
          style: TextStyle(color: kWhiteColor),
        ),
        icon: Icon(
          Icons.add,
          color: kWhiteColor,
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
                  Column(
                    children: [
                      Center(
                          child: TextField(
                        controller: fromDateinput,
                        //editing controller of this TextField
                        decoration: InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            //icon of text field
                            labelText: "Enter Start Date" //label text of field
                            ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

                            setState(() {
                              fromDateinput.text =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              //set output date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                      )),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                            child: TextField(
                          controller: toDateinput,
                          //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(Icons.calendar_today),
                              //icon of text field
                              labelText: "Enter End Date" //label text of field
                              ),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

                              setState(() {
                                toDateinput.text = DateFormat('yyyy-MM-dd').format(
                                    pickedDate); //set output date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              width: 150,
                              height: 50,
                              child: DefaultButton(
                                text: "Filter",
                                press: () {
                                  if (fromDateinput.text != "" &&
                                      toDateinput.text != "") {
                                    filterLedgerList(widget.customerId);
                                  } else {
                                    final snackBar = SnackBar(
                                        content: Text(
                                            "Please Enter Start Date and End Date."));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 150,
                              height: 50,
                              child: DefaultButton(
                                text: "Clear Filter",
                                press: () {
                                  fromDateinput.clear();
                                  toDateinput.clear();
                                  asyncSnapshot.clear();
                                  ledgerBloc.fetchLedger(widget.customerId);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ...List.generate(
                      asyncSnapshot.length,
                      (index) => LedgerListTile(
                            customerLedger: asyncSnapshot[index],
                          ))
                ],
              ),
            );
          }
        });
  }

  String path;

  Future savePdf(BuildContext context) async {
    if (await _reqPer(Permission.storage)) {
      var dir = await DownloadsPathProvider.downloadsDirectory;
      print("object directory path ${dir.path}");
      File file = File(dir.path + "/LedgerDetail.pdf");
      path = dir.path + "/LedgerDetail.pdf";

      print(path);
      file.writeAsBytesSync(List.from(await pdf.save()));
      print("path of file open $path");
      Alerts.showAlertPdf(context, 'Ledger Detail', 'Pdf Generated', path);
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
              child: pw.Text("Ledger Detail",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    fontSize: 40,
                    color: PdfColor.fromHex('#4684C2'),
                    fontWeight: pw.FontWeight.bold,
                  ))),
          pw.SizedBox(height: 30),
          pw.Column(children: [
            pw.Divider(color: PdfColor.fromHex('#4684C2'), thickness: 3),
            pw.ListView.builder(
                //padding: pw.EdgeInsets.only(bottom: 10),
                itemCount: as.length,
                itemBuilder: (c, i) {
                  return pw.Container(
                      child: pw.Column(
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            as[i].ledgerDate == null
                                ? pw.Text("N/A")
                                : pw.Text(as[i].ledgerDate,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                            as[i].ledgerAccount == null
                                ? pw.Text("N/A")
                                : pw.Text(as[i].ledgerAccount,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold)),
                            as[i].creditAmount != ""
                                ? pw.Text(
                                    "${as[i].creditAmount} Cr ",
                                    style: pw.TextStyle(
                                        color: PdfColor.fromHex('#000000'),
                                        fontWeight: pw.FontWeight.bold),
                                  )
                                : pw.Text("${as[i].debitAmount} Dr ",
                                    style: pw.TextStyle(
                                        color: PdfColor.fromHex('#000000'),
                                        fontWeight: pw.FontWeight.bold)),
                            as[i].type == ""
                                ? pw.Text("")
                                : pw.Text(as[i].type,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold))
                          ]),
                      pw.SizedBox(
                        height: 10,
                      )
                    ],
                  ));
                })
          ])
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
            "http://loccon.in/desiremoulding/api/UserApiController/customerLedgerFilter"),
        body: {
          'secretkey': Connection.secretKey,
          'customer_id': "83",
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
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10.0, top: 5, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
            color: kWhiteColor,
            border: Border.all(color: kSecondaryColor),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customerLedger.ledgerDate == null
                                  ? Text("N/A")
                                  : Text(customerLedger.ledgerDate,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              customerLedger.ledgerAccount == null
                                  ? Text("N/A")
                                  : Text(
                                      customerLedger.ledgerAccount,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      customerLedger.creditAmount != ""
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${customerLedger.creditAmount} Cr ",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${customerLedger.debitAmount} Dr ",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          customerLedger.type == ""
                              ? Text("")
                              : Text(customerLedger.type,
                                  style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
