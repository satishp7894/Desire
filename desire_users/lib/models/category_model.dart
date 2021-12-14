// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    @required this.status,
    @required this.data,
    @required this.message,
  });

  bool status;
  List<Datum> data;
  String message;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  Datum({
    @required this.categoryId,
    @required this.parentCategoryId,
    @required this.categoryName,
    @required this.categoryUrlName,
    @required this.topMenu,
    @required this.menuPos,
    @required this.description,
    @required this.catImage,
    @required this.catFavicon,
    @required this.catType,
    @required this.isFilter,
    @required this.isPopular,
    @required this.isSearch,
    @required this.createdBy,
    @required this.modifiedBy,
    @required this.created,
    @required this.modified,
    @required this.isActive,
  });

  String categoryId;
  String parentCategoryId;
  String categoryName;
  String categoryUrlName;
  String topMenu;
  String menuPos;
  String description;
  String catImage;
  String catFavicon;
  String catType;
  String isFilter;
  String isPopular;
  String isSearch;
  String createdBy;
  String modifiedBy;
  DateTime created;
  DateTime modified;
  String isActive;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    categoryId: json["category_id"],
    parentCategoryId: json["parent_category_id"] == null ? null : json["parent_category_id"],
    categoryName: json["category_name"],
    categoryUrlName: json["category_url_name"],
    topMenu: json["top_menu"],
    menuPos: json["menu_pos"] == null ? null : json["menu_pos"],
    description: json["description"] == null ? null : json["description"],
    catImage: json["cat_image"],
    catFavicon: json["cat_favicon"] == null ? null : json["cat_favicon"],
    catType: json["cat_type"] == null ? null : json["cat_type"],
    isFilter: json["is_filter"],
    isPopular: json["is_popular"],
    isSearch: json["is_search"],
    createdBy: json["created_by"],
    modifiedBy: json["modified_by"],
    created: DateTime.parse(json["created"]),
    modified: DateTime.parse(json["modified"]),
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "parent_category_id": parentCategoryId == null ? null : parentCategoryId,
    "category_name": categoryName,
    "category_url_name": categoryUrlName,
    "top_menu": topMenu,
    "menu_pos": menuPos == null ? null : menuPos,
    "description": description == null ? null : description,
    "cat_image": catImage,
    "cat_favicon": catFavicon == null ? null : catFavicon,
    "cat_type": catType == null ? null : catType,
    "is_filter": isFilter,
    "is_popular": isPopular,
    "is_search": isSearch,
    "created_by": createdBy,
    "modified_by": modifiedBy,
    "created": created.toIso8601String(),
    "modified": modified.toIso8601String(),
    "is_active": isActive,
  };
}
