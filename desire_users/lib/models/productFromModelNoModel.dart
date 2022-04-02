class ProductFromModelNoModel {
  bool status;
  String message;
  String imagepath;
  List<Data> data;

  ProductFromModelNoModel(
      {this.status, this.message, this.imagepath, this.data});

  ProductFromModelNoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    imagepath = json['imagepath'];
    if (json['data'] != "null") {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['imagepath'] = this.imagepath;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
