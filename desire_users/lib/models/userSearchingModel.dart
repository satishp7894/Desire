class UserSearchingModel {
  bool status;
  String categoryImagepath;
  String dimensionImagepath;
  String productImagepath;
  List<CategoryList> categoryList;
  List<ModelNoList> modelNoList;
  List<ProductList> productList;
  String message;

  UserSearchingModel(
      {this.status,
        this.categoryImagepath,
        this.dimensionImagepath,
        this.productImagepath,
        this.categoryList,
        this.modelNoList,
        this.productList,
        this.message});

  UserSearchingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    categoryImagepath = json['category_imagepath'];
    dimensionImagepath = json['dimension_imagepath'];
    productImagepath = json['product_imagepath'];
    if (json['category_list'] != null) {
      categoryList = new List<CategoryList>();
      json['category_list'].forEach((v) {
        categoryList.add(new CategoryList.fromJson(v));
      });
    }
    if (json['model_no_list'] != null) {
      modelNoList = new List<ModelNoList>();
      json['model_no_list'].forEach((v) {
        modelNoList.add(new ModelNoList.fromJson(v));
      });
    }
    if (json['product_list'] != null) {
      productList = new List<ProductList>();
      json['product_list'].forEach((v) {
        productList.add(new ProductList.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['category_imagepath'] = this.categoryImagepath;
    data['dimension_imagepath'] = this.dimensionImagepath;
    data['product_imagepath'] = this.productImagepath;
    if (this.categoryList != null) {
      data['category_list'] = this.categoryList.map((v) => v.toJson()).toList();
    }
    if (this.modelNoList != null) {
      data['model_no_list'] = this.modelNoList.map((v) => v.toJson()).toList();
    }
    if (this.productList != null) {
      data['product_list'] = this.productList.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class CategoryList {

  String categoryId;
  String categoryName;
  String categoryImage;

  CategoryList({this.categoryId, this.categoryName, this.categoryImage});

  CategoryList.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryImage = json['cat_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['cat_image'] = this.categoryImage;
    return data;
  }
}

class ModelNoList {
  String modelNoId;
  String modelNo;
  String dimensionsId;
  String size;
  String image;

  ModelNoList(
      {this.modelNoId, this.modelNo, this.dimensionsId, this.size, this.image});

  ModelNoList.fromJson(Map<String, dynamic> json) {
    modelNoId = json['model_no_id'];
    modelNo = json['model_no'];
    dimensionsId = json['dimensions_id'];
    size = json['size'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_no_id'] = this.modelNoId;
    data['model_no'] = this.modelNo;
    data['dimensions_id'] = this.dimensionsId;
    data['size'] = this.size;
    data['image'] = this.image;
    return data;
  }
}

class ProductList {
  String id;
  String productName;
  String profileNo;
  String modelNo;
  String customerprice;
  String distributorprice;
  String salesmanprice;
  String customernewprice;
  bool inPriceList;
  List<String> image;

  ProductList(
      {this.id,
        this.productName,
        this.profileNo,
        this.modelNo,
        this.customerprice,
        this.distributorprice,
        this.salesmanprice,
        this.customernewprice,
        this.inPriceList,
        this.image});

  ProductList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    profileNo = json['profile_No'];
    modelNo = json['model_no'];
    customerprice = json['Customerprice'];
    distributorprice = json['Distributorprice'];
    salesmanprice = json['Salesmanprice'];
    customernewprice = json['Customernewprice'];
    inPriceList = json['in_price_list'];
    image = json['image'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['profile_No'] = this.profileNo;
    data['model_no'] = this.modelNo;
    data['Customerprice'] = this.customerprice;
    data['Distributorprice'] = this.distributorprice;
    data['Salesmanprice'] = this.salesmanprice;
    data['Customernewprice'] = this.customernewprice;
    data['in_price_list'] = this.inPriceList;
    data['image'] = this.image;
    return data;
  }
}
