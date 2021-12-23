import 'dart:convert';
import 'dart:io';

import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DispatchtoWarehouse extends StatefulWidget {
  @override
  _DispatchtoWarehouseState createState() => _DispatchtoWarehouseState();
}

class _DispatchtoWarehouseState extends State<DispatchtoWarehouse> {
  var fileName = '';
  var filepath = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Dispatch to warehouse",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              fileName != ''
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Selected File : ',
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15)),
                        Text(
                          fileName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )
                      ],
                    )
                  : Text(''),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: DefaultButton(
                  text: "Choose File",
                  press: () {
                    filePicker();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: DefaultButton(
                  text: "Import File",
                  press: () {
                    // filePicker();
                    importFileToWarehouse();
                  },
                ),
              )
            ],
          ),
        ));
  }

  void filePicker() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'xls']);

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        fileName = file.name;
        filepath = file.path;
      });
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    } else {
      // User canceled the picker
    }
  }

  void importFileToWarehouse() async {
    // print("Id"+ value);
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

    var request = await http.MultipartRequest(
        "post",
        Uri.parse(
            "http://loccon.in/desiremoulding/api/ProductionApiController/importSendToWarehouse"));
    request.fields.addAll({'secretkey': Connection.secretKey});
    request.files
        .add(await http.MultipartFile.fromPath('import_file', filepath));

    request.send().then((response) async => {
          pr.hide(),
          if (response.statusCode == 200)
            {
              setState(() {
                fileName = '';
                filepath = '';
              }),
              Alerts.showAlertAndBack(
                  context, "Success", await response.stream.bytesToString())
            }
          else
            {
              Alerts.showAlertAndBack(
                  context, "Something Went Wrong", await response.reasonPhrase)
            }
        });

    // var results = json.decode(response.body);
    // print("object $results");
    // pr.hide();
    // if (results['status'] == true) {
    //   Alerts.showAlertAndBack(context, "Success", results['message']);
    // } else {
    //   Alerts.showAlertAndBack(
    //       context, "Something Went Wrong", "Could not added");
    // }
  }
}
