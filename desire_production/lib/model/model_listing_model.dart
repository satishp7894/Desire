// To parse this JSON data, do
//
//     final modelListModel = modelListModelFromJson(jsonString);

import 'dart:convert';

ModelListingModel modelListModelFromJson(String str) => ModelListingModel.fromJson(json.decode(str));

String modelListModelToJson(ModelListingModel data) => json.encode(data.toJson());

class ModelListingModel {

  ModelListingModel({
    this.status,
    this.message,
    this.modelList,
  });

  bool status;
  String message;
  List<ModelList> modelList;

  factory ModelListingModel.fromJson(Map<String, dynamic> json) => ModelListingModel(
    status: json["status"],
    message: json["message"],
    modelList: List<ModelList>.from(json["data"].map((x) => ModelList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(modelList.map((x) => x.toJson())),
  };

}

class ModelList {

  ModelList({
    this.modelNoId,
    this.modelNo,
  });

  String modelNoId;
  String modelNo;

  factory ModelList.fromJson(Map<String, dynamic> json) => ModelList(
    modelNoId: json["model_no_id"],
    modelNo: json["model_no"],
  );

  Map<String, dynamic> toJson() => {
    "model_no_id": modelNoId,
    "model_no": modelNo,
  };

}
