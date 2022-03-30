import 'dart:convert';

import 'package:desire_production/bloc/add_products_bloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/all_category.dart';
import 'package:desire_production/model/all_dimensions_model.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/keyboard_util.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditModelPage extends StatefulWidget {
  final modelNo;
  final String customerPrice;
  final String salesPrice;
  final String distributorPrice;
  final String model_no_id;

  const EditModelPage(
      {Key key,
      this.modelNo,
      this.customerPrice,
      this.salesPrice,
      this.distributorPrice, this.model_no_id})
      : super(key: key);

  @override
  _EditModelPageState createState() => _EditModelPageState();
}

class _EditModelPageState extends State<EditModelPage> with Validator {
  AddProductsBloc addProductsBloc = AddProductsBloc();
  AsyncSnapshot<AllCategory> asyncSnapshot;
  AsyncSnapshot<AllDimensionsModel> asyncSnapshotDimension;
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  TextEditingController modelNo, perBox, cPrice, sPrice, dPrice;
  var fileName = '';
  var filepath = "";
  List<String> category = ["Select your Category"];
  List<Category> categoryList = [];
  List<String> categoryId = [];
  List<String> dimesion = ["Select your Category"];
  List<AllDimension> dimesionList = [];
  String dimesionId;
  bool future = false;
  bool newModel = false;
  bool best = false;

  @override
  void initState() {
    super.initState();
    addProductsBloc.fetchAllDimensions();
    addProductsBloc.fetchAllCategory();
    modelNo = TextEditingController();
    perBox = TextEditingController();
    cPrice = TextEditingController();
    sPrice = TextEditingController();
    dPrice = TextEditingController();
    modelNo.text = widget.modelNo;
    cPrice.text = widget.customerPrice;
    sPrice.text = widget.salesPrice;
    dPrice.text = widget.distributorPrice;
  }

  @override
  void dispose() {
    super.dispose();
    modelNo.dispose();
    perBox.dispose();
    cPrice.dispose();
    sPrice.dispose();
    dPrice.dispose();
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
              ? "Edit Model"
              : "Add Model",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<AllCategory>(
          stream: addProductsBloc.allCategoryStream,
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
              categoryList = s.data.data;
              for (int i = 0; i < s.data.data.length; i++) {
                category.add(s.data.data[i].categoryName);
              }
              return SingleChildScrollView(child: _body());
            }
          }),
    );
  }

  Widget _body() {
    return StreamBuilder<AllDimensionsModel>(
        stream: addProductsBloc.allDimensionStream,
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
            asyncSnapshotDimension = s;
            // allModel = asyncSnapshot.data.data;
            dimesionList = s.data.data;
            for (int i = 0; i < s.data.data.length; i++) {
              dimesion.add(s.data.data[i].size);
            }
            return Form(
              autovalidateMode: _autoValidateMode,
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      controller: modelNo,
                      validator: validateRequired,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Model No.',
                          hintText: 'Enter Model No.',
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
                      controller: perBox,
                      validator: validateRequired,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: kSecondaryColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: kPrimaryColor)),
                        labelText: 'Per Box Stick',
                        hintText: 'Enter per box stick',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      controller: cPrice,
                      keyboardType: TextInputType.number,
                      validator: validateRequired,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: kSecondaryColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: kPrimaryColor)),
                        labelText: 'Customer Price',
                        hintText: 'Enter customer price',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      controller: sPrice,
                      keyboardType: TextInputType.number,
                      validator: validateRequired,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: kSecondaryColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: kPrimaryColor)),
                        labelText: 'Sales Price',
                        hintText: 'Enter sales price',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      controller: dPrice,
                      keyboardType: TextInputType.number,
                      validator: validateRequired,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: kSecondaryColor)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: kPrimaryColor)),
                        labelText: 'Distributor Price',
                        hintText: 'Enter distributor price',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: DropdownSearch<String>.multiSelection(
                      validator: (v) => v == null ? "required field" : null,
                      mode: Mode.BOTTOM_SHEET,
                      showSearchBox: true,
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 30, right: 20, top: 5, bottom: 5),
                        alignLabelWithHint: true,
                        hintText: "Please Select Category",
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
                      items: category,
                      onChanged: (value) {
                        for (int i = 0; i < categoryList.length; i++) {
                          if (categoryList[i].categoryName == value[i]) {
                            setState(() {
                              categoryId.add(categoryList[i].categoryId);
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
                      dropdownSearchDecoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 30, right: 20, top: 5, bottom: 5),
                        alignLabelWithHint: true,
                        hintText: "Please Select Dimension",
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
                      items: dimesion,
                      onChanged: (value) {
                        for (int i = 0; i < dimesionList.length; i++) {
                          if (dimesionList[i].size == value) {
                            setState(() {
                              dimesionId =
                                  dimesionList[i].dimensionsId.toString();
                            });
                          }
                        }
                      },
                      //selectedItem: "Please Select your Area",
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(1),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                  value: future,
                                  onChanged: (v) {
                                    setState(() {
                                      future = v;
                                    });
                                  }),
                              Text("Future Model No.")
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                  value: newModel,
                                  onChanged: (v) {
                                    setState(() {
                                      newModel = v;
                                    });
                                  }),
                              Text("New Model No.")
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
                        (widget.modelNo != null && widget.modelNo != "")
                            ? EditModel()
                            : AddModel();
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  EditModel() async {
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
      var response;
      response = await http.post(
          Uri.parse(
              "http://loccon.in/desiremoulding/api/AdminApiController/editModelNo"),
          body: {
            'secretkey': Connection.secretKey,
            "model_no": widget.modelNo,
            "model_no_id":widget.model_no_id,
            "box_per_stick": perBox.text,
            "product_category": categoryId.toString(),
            "dimension": dimesionId,
            "customer_price": cPrice.text,
            "sales_price": sPrice.text,
            "distributor_price": dPrice.text,
            "future_model_no": future ? "1" : "0",
            "new_model_no": newModel ? "1" : "0",
            "best_seller": best ? "1" : "0",
          });
      var results = json.decode(response.body);
      print('response == $results  ${response.body}');
      pr.hide();
      if (results['status'] == true) {
        Alerts.showAlertAndBack(context, "Success", results['message']);
        // addProductBloc.fetchAllDimensions();
      } else {
        Alerts.showAlertAndBack(context, "Error", results['message']);
      }
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
    print(categoryId);
  }

  AddModel() async {
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
      var response;
      response = await http.post(
          Uri.parse(
              "http://loccon.in/desiremoulding/api/AdminApiController/addModelNo"),
          body: {
            'secretkey': Connection.secretKey,
            "model_no": modelNo.text,
            "box_per_stick": perBox.text,
            "product_category": categoryId.toString(),
            "dimension": dimesionId,
            "customer_price": cPrice.text,
            "sales_price": sPrice.text,
            "distributor_price": dPrice.text,
            "future_model_no": future ? "1" : "0",
            "new_model_no": newModel ? "1" : "0",
            "best_seller": best ? "1" : "0",
          });
      var results = json.decode(response.body);
      print('response == $results  ${response.body}');
      pr.hide();
      if (results['status'] == true) {
        Alerts.showAlertAndBack(context, "Success", results['message']);
        // addProductBloc.fetchAllDimensions();
      } else {
        Alerts.showAlertAndBack(context, "Error", results['message']);
      }
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
