class ProductListOrderModel {
  bool status;
  String productImagePath;
  List<Product> data;
  String message;

  ProductListOrderModel({this.status, this.productImagePath, this.data, this.message});

  ProductListOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    productImagePath = json['productImagePath'];
    if (json['data'] != null) {
      data = new List<Product>();
      json['data'].forEach((v) {
        data.add(new Product.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['productImagePath'] = this.productImagePath;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Product {
  String id;
  String productName;
  String profileNo;
  String modelNo;
  String dimensionsName;
  String size;
  List<String> image;

  Product(
      {this.id,
        this.productName,
        this.profileNo,
        this.modelNo,
        this.dimensionsName,
        this.size,
        this.image});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    profileNo = json['profile_no'];
    modelNo = json['model_no'];
    dimensionsName = json['dimensions_name'];
    size = json['size'];
    image = json['image'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_name'] = this.productName;
    data['profile_no'] = this.profileNo;
    data['model_no'] = this.modelNo;
    data['dimensions_name'] = this.dimensionsName;
    data['size'] = this.size;
    data['image'] = this.image;
    return data;
  }
}