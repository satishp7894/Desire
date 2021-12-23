import 'package:desire_production/components/default_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DispatchtoWarehouse extends StatefulWidget {
  @override
  _DispatchtoWarehouseState createState() => _DispatchtoWarehouseState();
}

class _DispatchtoWarehouseState extends State<DispatchtoWarehouse> {
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
      body: DefaultButton(
        text: "Choose file",
        press: () {
          filePicker();
        },
      ),
    );
  }

  void filePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;

      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    } else {
      // User canceled the picker
    }
  }
}
