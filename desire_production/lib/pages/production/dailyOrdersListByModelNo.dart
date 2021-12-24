import 'dart:io';

import 'package:desire_production/bloc/modelWiseListBloc.dart';
import 'package:desire_production/model/modelNoWiseListModel.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

class DailyOrdersListByModelNumber extends StatefulWidget {
  final modelNo;
  final modelNoId;
  final status;
  const DailyOrdersListByModelNumber(
      {Key key, this.modelNo, this.modelNoId, this.status})
      : super(key: key);

  @override
  _DailyOrdersListByModelNumberState createState() =>
      _DailyOrdersListByModelNumberState();
}

class _DailyOrdersListByModelNumberState
    extends State<DailyOrdersListByModelNumber> {
  final ModelWiseListBloc modelWiseListBloc = ModelWiseListBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modelWiseListBloc.fetchModelWiseDailyOrderList(widget.modelNoId.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    modelWiseListBloc.dispose();
  }

  AsyncSnapshot<ModelNoWiseListModel> asyncSnapshot;
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
      body: StreamBuilder<ModelNoWiseListModel>(
        stream: modelWiseListBloc.modelWiseDailyOrdersListStream,
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
            asyncSnapshot = s;
          return asyncSnapshot.data.data.isEmpty
              ? Center(
                  child:
                      Text("No Production List of ${widget.modelNo} Model No."),
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ...List.generate(
                          asyncSnapshot.data.data.length,
                          (index) => ModelWiseListTile(
                                data: asyncSnapshot.data.data[index],
                              ))
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
                    width: 150,
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
                  pw.Container(
                    child: pw.Text(
                      'Stick per Box',
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
            '${asyncSnapshot.data.data[i].customerName}',
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
            '${asyncSnapshot.data.data[i].productName}',
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
            '${asyncSnapshot.data.data[i].productQuantity}',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15),
            textAlign: pw.TextAlign.center,
          ),
          width: 60,
          height: 52,
          padding: pw.EdgeInsets.only(left: 5),
          alignment: pw.Alignment.center,
        ),
        pw.Container(
          child: pw.Text(
            '${asyncSnapshot.data.data[i].perBoxStick}',
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
  final Data data;
  const ModelWiseListTile({Key key, this.data}) : super(key: key);

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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Customer Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Product Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Quantity",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Stick per Box",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(":-"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(":-"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(":-"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(":-"),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.customerName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.productName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.productQuantity,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.perBoxStick,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
