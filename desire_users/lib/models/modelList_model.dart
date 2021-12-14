// To parse this JSON data, do
//
//     final modelListModel = modelListModelFromJson(jsonString);

import 'dart:convert';

ModelListModel modelListModelFromJson(String str) => ModelListModel.fromJson(json.decode(str));

String modelListModelToJson(ModelListModel data) => json.encode(data.toJson());

class ModelListModel {
  ModelListModel({
    this.status,
    this.priceList,
    this.message,
    this.modelList,
  });

  bool status;
  bool priceList;
  String message;
  List<ModelList> modelList;

  factory ModelListModel.fromJson(Map<String, dynamic> json) => ModelListModel(
    status: json["status"],
    priceList: json["price_list"],
    message: json["message"],
    modelList: List<ModelList>.from(json["data"].map((x) => ModelList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "price_list": priceList,
    "message": message,
    "data": List<dynamic>.from(modelList.map((x) => x.toJson())),
  };
}

class ModelList {
  ModelList({
    this.modelNoId,
    this.modelNo,
    this.customerPrice,
    this.salesPrice,
    this.listPrice,
    this.listOldPrice,
    this.checked,
  });

  String modelNoId;
  String modelNo;
  String customerPrice;
  String salesPrice;
  String listPrice;
  String listOldPrice;
  bool checked;

  factory ModelList.fromJson(Map<String, dynamic> json) => ModelList(
    modelNoId: json["model_no_id"],
    modelNo: json["model_no"],
    customerPrice: json["customer_price"],
    salesPrice: json["sales_price"],
    listPrice: json["list_price"],
    listOldPrice: json["list_old_price"],
    checked: json["checked"],
  );

  Map<String, dynamic> toJson() => {
    "model_no_id": modelNoId,
    "model_no": modelNo,
    "customer_price": customerPrice,
    "sales_price": salesPrice,
    "list_price": listPrice,
    "list_old_price": listOldPrice,
    "checked": checked,
  };
}
