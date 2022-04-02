import 'dart:convert';

import 'package:desire_production/bloc/add_products_bloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/all_dimensions_model.dart';
import 'package:desire_production/model/all_model_list_model.dart';
import 'package:desire_production/model/all_profile_model.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/keyboard_util.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditProductPage extends StatefulWidget {
  final modelNo;
  final String profile;
  final String productName;
  final String productId;

  const EditProductPage(
      {Key key, this.modelNo, this.profile, this.productName, this.productId})
      : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> with Validator {
  AddProductsBloc addProductsBloc = AddProductsBloc();
  AsyncSnapshot<AllModellistModel> asyncSnapshot;
  AsyncSnapshot<AllProfileModel> asyncSnapshotProfile;
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  TextEditingController pName, hsn, remarks;
  List<PlatformFile> filepath = [];
  List<String> model = ["Select your Model"];
  List<AllModel> modelList = [];
  String modelId;
  List<String> profile = ["Select your Profile"];
  List<AllProfile> profileList = [];
  String profileId;
  String profileVal;
  String modelVal;
  bool access = false;
  bool future = false;
  bool best = false;
  bool newProduct = false;

  @override
  void initState() {
    super.initState();

    if (modelList.length == 0 && profileList.length == 0) {
      addProductsBloc.fetchAllModel();
      addProductsBloc.fetchAllProfile();
    }
    pName = TextEditingController();
    hsn = TextEditingController();
    remarks = TextEditingController();
    pName.text = widget.productName;
  }

  @override
  void dispose() {
    super.dispose();
    pName.dispose();
    hsn.dispose();
    remarks.dispose();
    addProductsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          (widget.modelNo != null && widget.modelNo != "")
              ? "Edit Product"
              : "Add Product",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<AllModellistModel>(
          stream: addProductsBloc.allModelStream,
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
              print("as3 error");
              print(s.error);
              return Container(
                height: 300,
                alignment: Alignment.center,
                child: SelectableText(
                  "Error Loading Data ${s.error}",
                ),
              );
            } else if (s.data.data.isEmpty) {
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
              // allModel = asyncSnapshot.data.data;
              modelList = s.data.data;
              for (int i = 0; i < s.data.data.length; i++) {
                model.add(s.data.data[i].modelNo);
              }
              if (modelList.length > 0) {
                for (int i = 0; i < modelList.length; i++) {
                  if (modelList[i].modelNo == widget.modelNo) {
                    // setState(() {
                    modelId = modelList[i].modelNoId;
                    // });
                  }
                }
              }
              return SingleChildScrollView(child: _body());
            }
          }),
    );
  }

  Widget _body() {
    return StreamBuilder<AllProfileModel>(
        stream: addProductsBloc.allProfileStream,
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
            print("as3 error");
            print(s.error);
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: SelectableText(
                "Error Loading Data ${s.error}",
              ),
            );
          } else if (s.data.data.isEmpty) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          } else {
            asyncSnapshotProfile = s;
            // allModel = asyncSnapshot.data.data;
            profileList = s.data.data;
            for (int i = 0; i < s.data.data.length; i++) {
              profile.add(s.data.data[i].profileNo);
            }
            if (profileList.length > 0) {
              for (int i = 0; i < profileList.length; i++) {
                if (profileList[i].profileNo == widget.profile) {
                  // setState(() {
                  profileId = profileList[i].profileNoId;
                  // });
                }
              }
            }
            return Form(
              autovalidateMode: _autoValidateMode,
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: DropdownSearch<String>(
                      validator: (v) => v == null ? "required field" : null,
                      mode: Mode.BOTTOM_SHEET,
                      showSearchBox: true,
                      selectedItem: widget.modelNo,
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 30, right: 20, top: 5, bottom: 5),
                        alignLabelWithHint: true,
                        hintText: "Please Select Model",
                        hintStyle: TextStyle(color: Colors.black45),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      showSelectedItems: true,
                      items: model,
                      onChanged: (value) {
                        for (int i = 0; i < modelList.length; i++) {
                          if (modelList[i].modelNo == value) {
                            setState(() {
                              modelId = modelList[i].modelNoId;
                              modelVal = value;
                            });
                          }
                        }
                      },
                      //selectedItem: "Please Select your Area",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: DropdownSearch<String>(
                      validator: (v) => v == null ? "required field" : null,
                      mode: Mode.BOTTOM_SHEET,
                      showSearchBox: true,
                      selectedItem: widget.profile,
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 30, right: 20, top: 5, bottom: 5),
                        alignLabelWithHint: true,
                        hintText: "Please Select Profile",
                        hintStyle: TextStyle(color: Colors.black45),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      showSelectedItems: true,
                      items: profile,
                      onChanged: (value) {
                        for (int i = 0; i < profileList.length; i++) {
                          if (profileList[i].profileNo == value) {
                            setState(() {
                              profileId = profileList[i].profileNoId;
                              pName.text = '${value} - ${modelVal}';
                            });
                          }
                        }
                      },
                      //selectedItem: "Please Select your Area",
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      controller: pName,
                      validator: validateRequired,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Product Name.',
                          hintText: 'Enter Product Name.',
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
                      controller: hsn,
                      validator: validateRequired,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'HSN/SAC.',
                          hintText: 'Enter HSN/SAC.',
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
                    child: DefaultButton(
                      text: "Choose File",
                      press: () {
                        filePicker();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      controller: remarks,
                      validator: validateRequired,
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                      decoration: InputDecoration(
                          labelText: 'Remarks ',
                          hintText: 'Enter Remarks.',
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
                      padding: EdgeInsets.all(1),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  value: access,
                                  onChanged: (v) {
                                    setState(() {
                                      access = v;
                                    });
                                  }),
                              Text("Accessories Product")
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: future,
                                  onChanged: (v) {
                                    setState(() {
                                      future = v;
                                    });
                                  }),
                              Text("Future Product")
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: newProduct,
                                  onChanged: (v) {
                                    setState(() {
                                      newProduct = v;
                                    });
                                  }),
                              Text("new Product")
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: best,
                                  onChanged: (v) {
                                    setState(() {
                                      best = v;
                                    });
                                  }),
                              Text("Best Seller")
                            ],
                          )
                        ],
                      )),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: DefaultButton(
                      text: "Save",
                      press: () {
                        KeyboardUtil.hideKeyboard(context);
                        (widget.productId != null && widget.productId != "")
                            ? EditProduct()
                            : AddProduct();
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  void filePicker() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', "jpeg"]);

    if (result != null) {
      List<PlatformFile> file = result.files;

      setState(() {
        filepath.addAll(file);
      });
      print("File count " + filepath.length.toString());
    } else {
      // User canceled the picker
    }
  }

  EditProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: true,
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
              "http://loccon.in/desiremoulding/api/AdminApiController/editProduct"));
      request.fields.addAll({
        'secretkey': Connection.secretKey,
        "product_id": widget.productId,
        "product_name": widget.productName,
        "profile_no_id": profileId,
        "model_no_id": modelId,
        "hsn_sac": hsn.text,
        "remarks": remarks.text,
        "accessories_product": access ? "1" : "0",
        "future_product": future ? "1" : "0",
        "new_product": newProduct ? "1" : "0",
        "best_seller": best ? "1" : "0",
      });
      for (int i = 0; i < filepath.length; i++) {
        request.files.add(
            await http.MultipartFile.fromPath('image[]', filepath[i].path));
      }

      request.send().then((response) async {
        pr.hide();
        if (response.statusCode == 200) {
          var dimension = await response.stream.bytesToString();
          var decode = json.decode(dimension);
          var msg = decode["message"];
          // Alerts.showAlertAndBack(context, "Success", msg);
          final snackBar = SnackBar(
              content: Text(
            msg,
            textAlign: TextAlign.start,
          ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context, true);
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

  AddProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: true,
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
              "http://loccon.in/desiremoulding/api/AdminApiController/addProduct"));
      request.fields.addAll({
        'secretkey': Connection.secretKey,
        "product_name": pName.text,
        "profile_no_id": profileId,
        "model_no_id": modelId,
        "hsn_sac": hsn.text,
        "remarks": remarks.text,
        "accessories_product": access ? "1" : "0",
        "future_product": future ? "1" : "0",
        "new_product": newProduct ? "1" : "0",
        "best_seller": best ? "1" : "0",
      });
      for (int i = 0; i < filepath.length; i++) {
        request.files.add(
            await http.MultipartFile.fromPath('image[]', filepath[i].path));
      }

      request.send().then((response) async {
        pr.hide();
        if (response.statusCode == 200) {
          var dimension = await response.stream.bytesToString();
          var decode = json.decode(dimension);
          var msg = decode["message"];
          // Alerts.showAlertAndBack(context, "Success", msg);
          setState(() {
            filepath = [];
          });
          final snackBar = SnackBar(
              content: Text(
            msg,
            textAlign: TextAlign.start,
          ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pop(context, true);
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
