import 'dart:convert';
import 'dart:io';

import 'package:desire_production/bloc/add_products_bloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/all_dimensions_model.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/keyboard_util.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:desire_production/utils/validator.dart';

class EditDimensionsPage extends StatefulWidget {
  final dimensionId;
  final String dmSize;
  final String image;

  const EditDimensionsPage({Key key, this.dimensionId, this.dmSize, this.image})
      : super(key: key);

  @override
  _EditDimensionsPageState createState() => _EditDimensionsPageState();
}

class _EditDimensionsPageState extends State<EditDimensionsPage>
    with Validator {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  TextEditingController height, width, size, sizeInch;
  var fileName = '';
  var filepath = "";

  @override
  void initState() {
    super.initState();
    height = TextEditingController();
    width = TextEditingController();
    size = TextEditingController();
    sizeInch = TextEditingController();
    if (widget.dmSize != null && widget.dmSize != "") {
      String s = widget.dmSize;
      int idx = s.indexOf("x");
      List parts = [s.substring(0, idx).trim(), s.substring(idx + 1).trim()];
      print(parts);
      height.text = parts[0];
      width.text = parts[1];
    }
  }

  @override
  void dispose() {
    super.dispose();
    width.dispose();
    height.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          (widget.dimensionId != null && widget.dimensionId != "")
              ? "Edit Dimensions"
              : "Add Dimensions",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(child: _body()),
    );
  }

  Widget _body() {
    return Form(
      autovalidateMode: _autoValidateMode,
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              controller: height,
              validator: validateRequired,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  labelText: 'Dimension height(mm)',
                  hintText: 'Enter Dimension height',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: kSecondaryColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: kPrimaryColor))),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              controller: width,
              validator: validateRequired,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: kSecondaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: kPrimaryColor)),
                labelText: 'Dimension width(mm)',
                hintText: 'Enter Dimension width',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
          /*Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              controller: size,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: kSecondaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: kPrimaryColor)),
                labelText: 'Dimension size(mm)',
                hintText: 'Enter Dimension size in mm',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: TextFormField(
              controller: sizeInch,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: kSecondaryColor)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(color: kPrimaryColor)),
                labelText: 'Dimension size(inch)',
                hintText: 'Enter Dimension size in inch',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
          ),*/
          filepath == ""
              ? Padding(
                  padding: EdgeInsets.all(15),
                  child: widget.image != "" && widget.image != null
                      ? FadeInImage.assetNetwork(
                          placeholder: "assets/images/dimensions.png",
                          image: widget.image,
                          width: 100,
                          height: 100,
                        ): Container (),
                )
              : Image.file(
                  File(filepath),
                  width: 100,
                  height: 100,
                ),
          Padding(
            padding: EdgeInsets.all(15),
            child: DefaultButton(
              text: "Choose File",
              press: () {
                filePicker();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15),
            child: DefaultButton(
              text: "Save",
              press: () {
                /*  if (_formKey.currentState.validate()) {
                _formKey.currentState.save();*/
                KeyboardUtil.hideKeyboard(context);
                (widget.dimensionId != null && widget.dimensionId != "")
                    ? EditDimesion()
                    : AddDimesion();
                // }
              },
            ),
          ),
        ],
      ),
    );
  }

  void filePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['jpg', 'png', "jpeg"]);

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

  EditDimesion() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
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
              "http://loccon.in/desiremoulding/api/AdminApiController/editDimension"));
      request.fields.addAll({
        'secretkey': Connection.secretKey,
        'dimensions_id': widget.dimensionId,
        'dimensions_height': height.text,
        'dimensions_width': width.text
      });
      request.files.add(await http.MultipartFile.fromPath('image', filepath));

      request.send().then((response) async {
        pr.hide();
        if (response.statusCode == 200) {
          var dimension = await response.stream.bytesToString();
          var decode = json.decode(dimension);
          var msg = decode["message"];
          Alerts.showAlertAndBack(context, "Success", msg);
        } else {
          Alerts.showAlertAndBack(
              context, "Something Went Wrong", await response.reasonPhrase);
        }
      });
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  AddDimesion() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
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
              "http://loccon.in/desiremoulding/api/AdminApiController/addDimension"));
      request.fields.addAll({
        'secretkey': Connection.secretKey,
        'dimensions_height': height.text,
        'dimensions_width': width.text
      });
      request.files.add(await http.MultipartFile.fromPath('image', filepath));

      request.send().then((response) async {
        pr.hide();
        if (response.statusCode == 200) {
          setState(() {});
          var dimension = await response.stream.bytesToString();
          var decode = json.decode(dimension);
          var msg = decode["message"];
          Alerts.showAlertAndBack(context, "Success", msg);
        } else {
          Alerts.showAlertAndBack(
              context, "Something Went Wrong", await response.reasonPhrase);
        }
      });
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }
}

class AllDimensionsListTile extends StatelessWidget {
  final AllDimension allDimension;
  final String imgPath;

  const AllDimensionsListTile({Key key, this.allDimension, this.imgPath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
            onTap: () {},
            child: Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                alignment: Alignment.centerRight,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: Card(
                elevation: 5,
                margin: EdgeInsets.zero,
                child: Container(
                  height: 80,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1, color: kPrimaryColor)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: "Size : ",
                                style:
                                    TextStyle(color: kBlackColor, fontSize: 15),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: allDimension.size,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: "Size in inch : ",
                                style:
                                    TextStyle(color: kBlackColor, fontSize: 15),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: allDimension.sizeInch,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      FadeInImage.assetNetwork(
                        placeholder: "assets/images/dimensions.png",
                        image: imgPath + allDimension.image,
                        width: 50,
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
