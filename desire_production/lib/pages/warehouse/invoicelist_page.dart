import 'dart:io';

import 'package:desire_production/bloc/invoice_list_bloc.dart';
import 'package:desire_production/bloc/readyToDispatchBloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/invoices_list_Model.dart';
import 'package:desire_production/model/readyToDispatchListModel.dart';
import 'package:desire_production/pages/warehouse/add_new_invoice_order.dart';
import 'package:desire_production/pages/warehouse/invoicedetail_page.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class InvoicesListPage extends StatefulWidget {
  final String page;
  const InvoicesListPage({@required this.page});

  @override
  _InvoicesListPageState createState() => _InvoicesListPageState();
}

class _InvoicesListPageState extends State<InvoicesListPage> {
  final InvoicesListBloc modelWiseListBloc = InvoicesListBloc();
  TextEditingController searchView;

  bool search = false;
  List<InvoiceInfo> _searchResult = [];
  List<InvoiceInfo> _list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modelWiseListBloc.fetchinvoicesList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    modelWiseListBloc.dispose();
  }

  AsyncSnapshot<InvoicesListModel> asyncSnapshot;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
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
                        Navigator.pop(context);
                        final pdf = pw.Document();
                        generatePDF(pdf);
                        savePdf(pdf);
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
                        Alerts.showLogOut(context, "Log Out", "Are you sure?");
                      },
                    )),
                  ])
        ],
        backgroundColor: Colors.white,
        title: Text(
          "Invoice List",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: _searchView(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            showDialog(
                context: context,
                builder: (builder) =>
                    AddInvoiceDailog());
          },
          label: Text("Add Invoice")),
      body: StreamBuilder<InvoicesListModel>(
        stream: modelWiseListBloc.invoicesStream,
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
          } else
            _list = s.data.data;
          asyncSnapshot = s;
          return asyncSnapshot.data.data.isEmpty
              ? Center(
                  child: Text("No invoices found!}"),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ...List.generate(
                          asyncSnapshot.data.data.length,
                          (index) => ModelWiseListTile(
                              data: asyncSnapshot.data.data[index],
                              url: asyncSnapshot.data.invoicePDFPath))
                    ],
                  ),
                );
        },
      ),
    );
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
      if (exp.invoiceNumber.contains(text)) _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }

  void generatePDF(pw.Document pdf) {
    pdf.addPage(pw.MultiPage(
        margin: pw.EdgeInsets.all(15),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        pageFormat: PdfPageFormat.standard,
        build: (context) {
          return [
            pw.Header(
              level: 5,
              child: pw.Text(
                "Invoice List",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 40,
                  color: PdfColor.fromHex('#4684C2'),
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 30),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    child: pw.Text(
                      'Invoice No',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 15),
                      textAlign: pw.TextAlign.center,
                    ),
                    width: 150,
                    height: 52,
                    padding: pw.EdgeInsets.only(left: 5),
                    alignment: pw.Alignment.center,
                  ),
                  pw.Container(
                    child: pw.Text(
                      'Customer Name',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 15),
                      textAlign: pw.TextAlign.center,
                    ),
                    width: 200,
                    height: 52,
                    padding: pw.EdgeInsets.only(left: 10),
                    alignment: pw.Alignment.center,
                  ),
                  pw.Container(
                    child: pw.Text(
                      'Date',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold, fontSize: 15),
                      textAlign: pw.TextAlign.center,
                    ),
                    width: 150,
                    height: 52,
                    alignment: pw.Alignment.center,
                  ),
                ]),
            pw.Divider(color: PdfColor.fromHex('#4684C2'), thickness: 3),
            pw.ListView.builder(
              itemCount: asyncSnapshot.data.data.length,
              itemBuilder: (c, i) {
                if (i.isEven) {
                  return pw.Container(
                    color: PdfColor.fromHex('#E0F7FA'),
                    child: buildRow(c, i),
                  );
                } else {
                  return pw.Container(
                    child: buildRow(c, i),
                  );
                }
              },
            ),
            // asyncSnapshot
          ];
        }));
  }

  pw.Row buildRow(pw.Context c, int i) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          child: pw.Text(
            '${asyncSnapshot.data.data[i].invoiceNumber}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15),
            textAlign: pw.TextAlign.center,
          ),
          width: 150,
          height: 52,
          padding: pw.EdgeInsets.only(left: 5),
          alignment: pw.Alignment.center,
        ),
        pw.Container(
          child: pw.Text(
            '${asyncSnapshot.data.data[i].customerName}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15),
            textAlign: pw.TextAlign.center,
          ),
          width: 200,
          height: 52,
          padding: pw.EdgeInsets.only(left: 5),
          alignment: pw.Alignment.center,
        ),
        pw.Container(
          child: pw.Text(
            '${asyncSnapshot.data.data[i].invoiceDate}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15),
            textAlign: pw.TextAlign.center,
          ),
          width: 150,
          height: 52,
          padding: pw.EdgeInsets.only(left: 5),
          alignment: pw.Alignment.center,
        ),
      ],
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

  Future savePdf(pw.Document pdf) async {
    String path;
    if (await _reqPer(Permission.storage)) {
      var dir = await DownloadsPathProvider.downloadsDirectory;
      print("object directory path ${dir.path}");
      File file = File(dir.path + "/ProductList.pdf");
      path = dir.path + "/ProductList.pdf";

      print(path);
      file.writeAsBytesSync(List.from(await pdf.save()));
      print("path of file open $path");
      Alerts.showAlertPdf(context, 'Invoice List', 'Pdf Generated', path);
    }
  }
}

class ModelWiseListTile extends StatelessWidget {
  final InvoiceInfo data;
  final String url;
  const ModelWiseListTile({Key key, this.data, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 5, top: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return InvoiceDetailPage(data.dispatchInvoiceId);
          }));
        },
        child: Card(
          borderOnForeground: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10, bottom: 10, top: 10),
            child: Row(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(right: 8.0),
                //   child: Image.network(
                //     "$url/${data.invoiceFile}",
                //     width: 120,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldValueSet("Invoice No", data.invoiceNumber),
                      SizedBox(width: 10),
                      FieldValueSet("Invoice Date", data.invoiceDate),
                      SizedBox(width: 10),
                      FieldValueSet("Customer Name", data.customerName),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget FieldValueSet(String title, String value) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            color: Colors.grey.shade400),
      ),
      Text(
        value,
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
      ),
    ],
  );
}


class AddInvoiceDailog extends StatefulWidget {
  @override
  _AddInvoiceDailogState createState() => _AddInvoiceDailogState();
}

class _AddInvoiceDailogState extends State<AddInvoiceDailog> {
  String _chosenValue;
  final ReadyToDispatchBloc readyToDispatchBloc = ReadyToDispatchBloc();

  @override
  void initState() {
    // TODO: implement initState
    readyToDispatchBloc.fetchReadyToDispatchList();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    readyToDispatchBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoAlertDialog(
      title: Text("Add Invoice"),
      actions: [
        Container(
          padding: EdgeInsets.all(10),
          child: DefaultButton(
            text: "Add",
            press: () {
              if (_chosenValue != null) {
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddNewInvoiceOrderPage(_chosenValue);
                }));
              } else {
                Alerts.showAlertAndBack(
                    context, "Something went wrong", "Please select customer name");
              }
            },
          ),
        ),
      ],
      content: StreamBuilder<ReadyToDispatchListModel>(
          stream: readyToDispatchBloc.readyToDispatchStream,
          builder: (c, s) {
            if (s.connectionState == ConnectionState.waiting) {
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

            return Container(
              height: 70,
              // padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: DropdownButton<String>(
                          value: _chosenValue,
                          elevation: 16,
                          isExpanded: true,
                          //elevation: 5,
                          style: TextStyle(color: Colors.black),
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          items: s.data.data
                              .map<DropdownMenuItem<String>>((DataReady value) {
                            return DropdownMenuItem<String>(
                              value: value.customerId,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(value.customerName),
                              ),
                            );
                          }).toList(),
                          hint: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Please choose a Customer",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _chosenValue = value;
                            });
                          },
                        )),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
