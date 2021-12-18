import 'package:meta/meta.dart';


class ModelNoFromCategoryModel {
  ModelNoFromCategoryModel({
    @required this.status,
    @required this.message,
    @required this.imagepath,
    @required this.data,
  });

  bool status;
  String message;
  String imagepath;
  List<Datum> data;

  factory ModelNoFromCategoryModel.fromJson(Map<String, dynamic> json) => ModelNoFromCategoryModel(
    status: json["status"],
    message: json["message"],
    imagepath: json["imagepath"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "imagepath": imagepath,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    @required this.modelNoId,
    @required this.modelNo,
    @required this.dimensionsId,
    @required this.size,
    @required this.image,
  });

  String modelNoId;
  String modelNo;
  String dimensionsId;
  String size;
  String image;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    modelNoId: json["model_no_id"],
    modelNo: json["model_no"],
    dimensionsId: json["dimensions_id"],
    size: json["size"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "model_no_id": modelNoId,
    "model_no": modelNo,
    "dimensions_id": dimensionsId,
    "size": size,
    "image": image,
  };
}