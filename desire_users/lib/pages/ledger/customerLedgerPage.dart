import 'package:desire_users/bloc/ledger_bloc.dart';
import 'package:desire_users/models/ledger_model.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class CustomerLedgerPage extends StatefulWidget {
  final customerId;

  const CustomerLedgerPage({Key key, this.customerId}) : super(key: key);

  @override
  _CustomerLedgerPageState createState() => _CustomerLedgerPageState();
}

class _CustomerLedgerPageState extends State<CustomerLedgerPage> {
  var ledgerBloc = LedgerBloc();
  AsyncSnapshot<LedgerModel> asyncSnapshot;

  List<CustomerLedger> as;

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
            asyncSnapshot = s;
            as = s.data.customerLedger;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                      asyncSnapshot.data.customerLedger.length,
                      (index) => LedgerListTile(
                            customerLedger:
                                asyncSnapshot.data.customerLedger[index],
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
    print("total lenght" + as.length.toString());
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
                  // pw.Column(
                  //          children: [
                  //            pw.Row(
                  //              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  //              crossAxisAlignment: pw.CrossAxisAlignment.start,
                  //              children: [
                  //                pw.Row(
                  //                  children: [
                  //                    pw.Column(
                  //                      mainAxisAlignment: pw.MainAxisAlignment.start,
                  //                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                  //                      children: [
                  //                        pw.Row(
                  //                          mainAxisAlignment: pw.MainAxisAlignment.start,
                  //                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                  //                          children: [
                  //                            as[i].ledgerDate == null
                  //                                ? pw.Text("N/A")
                  //                                : pw.Text( as[i].ledgerDate,
                  //                                style:pw.TextStyle(
                  //                                    fontWeight: pw.FontWeight.bold)),
                  //                          ],
                  //                        ),
                  //                        pw.SizedBox(
                  //                          height: 10,
                  //                        ),
                  //                        pw.Row(
                  //                          mainAxisAlignment: pw.MainAxisAlignment.start,
                  //                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                  //                          children: [
                  //                            as[i].ledgerAccount == null
                  //                                ? pw.Text("N/A")
                  //                                : pw.Text(
                  //                              as[i].ledgerAccount,
                  //                              style: pw.TextStyle(
                  //                                  fontWeight: pw.FontWeight.bold),
                  //                            ),
                  //                          ],
                  //                        ),
                  //                      ],
                  //                    ),
                  //                  ],
                  //                ),
                  //                pw.Column(
                  //                  children: [
                  //                    as[i].creditAmount != ""
                  //                        ?  pw.Row(
                  //                      mainAxisAlignment: pw.MainAxisAlignment.end,
                  //                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                  //                      children: [
                  //                        pw.Text(
                  //                          "${ as[i].creditAmount} Cr ",
                  //                          style: pw.TextStyle(
                  //                              color: PdfColor.fromHex('#000000'),
                  //                              fontWeight: pw.FontWeight.bold),
                  //                        ),
                  //                      ],
                  //                    )
                  //                        :  pw.Row(
                  //                      mainAxisAlignment:pw.MainAxisAlignment.end,
                  //                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                  //                      children: [
                  //                        pw.Text("${ as[i].debitAmount} Dr ",
                  //                            style: pw.TextStyle(
                  //                                color: PdfColor.fromHex('#000000'),
                  //                                fontWeight: pw.FontWeight.bold)),
                  //                      ],
                  //                    ),
                  //                    pw.Row(
                  //                      mainAxisAlignment: pw.MainAxisAlignment.end,
                  //                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                  //                      children: [
                  //                        as[i].type == ""
                  //                            ? pw.Text("")
                  //                            : pw.Text( as[i].type,
                  //                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold))
                  //                      ],
                  //                    ),
                  //                  ],
                  //                )
                  //              ],
                  //            ),
                  //            pw.SizedBox(
                  //              height: 10,
                  //            ),
                  //          ],
                  //        );
                })
          ])
        ];
      },
    ));
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
