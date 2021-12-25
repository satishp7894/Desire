import 'dart:io';

import 'package:desire_production/bloc/ready_stock_detail_list_bloc.dart';
import 'package:desire_production/model/readyStockDetailListModel.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class ReadyStockDetailPage extends StatefulWidget {
  final modelNo;
  final modelNoId;
  final status;
  const ReadyStockDetailPage(
      {Key key, this.modelNo, this.modelNoId, this.status})
      : super(key: key);

  @override
  _ReadyStockDetailPageState createState() => _ReadyStockDetailPageState();
}

class _ReadyStockDetailPageState extends State<ReadyStockDetailPage> {
  final ReadyStockDetailListBloc modelWiseListBloc = ReadyStockDetailListBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modelWiseListBloc.fetchreadyStockDetailList(widget.modelNoId.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    modelWiseListBloc.dispose();
  }

  AsyncSnapshot<ReadyStockDetailListModel> asyncSnapshot;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
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
          "Model No - " + widget.modelNo,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<ReadyStockDetailListModel>(
        stream: modelWiseListBloc.readyStockDetailStream,
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
          if (s.data.readyStockList == null) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Orders Found",
              ),
            );
          } else
            asyncSnapshot = s;
          return asyncSnapshot.data.readyStockList.isEmpty
              ? Center(
                  child:
                      Text("No Production List of ${widget.modelNo} Model No."),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ...List.generate(
                          asyncSnapshot.data.readyStockList.length,
                          (index) => ModelWiseListTile(
                              data: asyncSnapshot.data.readyStockList[index],
                              imageURL: asyncSnapshot.data.productImageUrl))
                    ],
                  ),
                );
        },
      ),
    );
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
                "Daily Order For Model No : ${widget.modelNo}",
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
                      'Customer Name',
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
                      'Product Name',
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
                      'Qty',
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
              itemCount: asyncSnapshot.data.readyStockList.length,
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
            '${asyncSnapshot.data.readyStockList[i].modelNo}',
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
            '${asyncSnapshot.data.readyStockList[i].productName}',
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
            '${asyncSnapshot.data.readyStockList[i].quantity}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15),
            textAlign: pw.TextAlign.center,
          ),
          width: 60,
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
      Alerts.showAlertPdf(
          context, 'Daily Orders - ${widget.modelNo}', 'Pdf Generated', path);
    }
  }
}

class ModelWiseListTile extends StatelessWidget {
  final ReadyStockDetailModel data;
  final String imageURL;
  const ModelWiseListTile({Key key, this.data, this.imageURL})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 5, top: 5),
      child: Card(
        borderOnForeground: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10.0, right: 10, bottom: 10, top: 10),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.network(
                  "$imageURL/${data.image}",
                  width: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FieldValueSet("Model No", data.modelNo),
                    SizedBox(width: 10),
                    FieldValueSet("Product Name", data.productName),
                    SizedBox(width: 10),
                    FieldValueSet("Qty", data.quantity),
                  ],
                ),
              ),
            ],
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
