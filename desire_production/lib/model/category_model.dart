class CategoryModel {
  CategoryModel({
    this.status,
    this.category,
    this.message,
  });

  bool status;
  List<CategoryData> category;
  String message;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    status: json["status"],
    category: json["data"] == "null" ? null : List<CategoryData>.from(json["data"].map((x) => CategoryData.fromJson(x))).toList(),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(category.map((x) => x.toJson())),
    "message": message,
  };
}

class CategoryData {
  CategoryData({
    this.categoryId,
    this.parentCategoryId,
    this.categoryName,
    this.categoryUrlName,
    this.topMenu,
    this.menuPos,
    this.description,
    this.catImage,
    this.catFavicon,
    this.catType,
    this.isFilter,
    this.isPopular,
    this.isSearch,
    this.createdBy,
    this.modifiedBy,
    this.created,
    this.modified,
    this.isActive,
  });

  String categoryId;
  dynamic parentCategoryId;
  String categoryName;
  String categoryUrlName;
  String topMenu;
  dynamic menuPos;
  dynamic description;
  String catImage;
  dynamic catFavicon;
  dynamic catType;
  String isFilter;
  String isPopular;
  String isSearch;
  String createdBy;
  String modifiedBy;
  DateTime created;
  DateTime modified;
  String isActive;

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
    categoryId: json["category_id"],
    parentCategoryId: json["parent_category_id"],
    categoryName: json["category_name"],
    categoryUrlName: json["category_url_name"],
    topMenu: json["top_menu"],
    menuPos: json["menu_pos"],
    description: json["description"],
    catImage: json["cat_image"],
    catFavicon: json["cat_favicon"],
    catType: json["cat_type"],
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
    "parent_category_id": parentCategoryId,
    "category_name": categoryName,
    "category_url_name": categoryUrlName,
    "top_menu": topMenu,
    "menu_pos": menuPos,
    "description": description,
    "cat_image": catImage,
    "cat_favicon": catFavicon,
    "cat_type": catType,
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
