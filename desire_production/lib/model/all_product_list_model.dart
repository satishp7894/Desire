class AllProductListModel {
  bool status;
  String productImagePath;
  List<AllProduct> data;
  String message;

  AllProductListModel(
      {this.status, this.productImagePath, this.data, this.message});

  AllProductListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    productImagePath = json['productImagePath'];
    if (json['data'] != null) {
      data = new List<AllProduct>();
      json['data'].forEach((v) {
        data.add(new AllProduct.fromJson(v));
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

class AllProduct {
  String id;
  String productName;
  String profileNo;
  String modelNo;
  Null dimensionsName;
  String size;
  List<String> image;

  AllProduct(
      {this.id,
      this.productName,
      this.profileNo,
      this.modelNo,
      this.dimensionsName,
      this.size,
      this.image});

  AllProduct.fromJson(Map<String, dynamic> json) {
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
