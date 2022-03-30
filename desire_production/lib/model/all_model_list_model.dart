class AllModellistModel {
  bool status;
  String message;
  List<AllModel> data;

  AllModellistModel({this.status, this.message, this.data});

  AllModellistModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<AllModel>();
      json['data'].forEach((v) {
        data.add(new AllModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllModel {
  String modelNoId;
  String modelNo;
  String customerPrice;
  String salesPrice;
  String distributorPrice;

  AllModel(
      {this.modelNoId,
        this.modelNo,
        this.customerPrice,
        this.salesPrice,
        this.distributorPrice});

  AllModel.fromJson(Map<String, dynamic> json) {
    modelNoId = json['model_no_id'];
    modelNo = json['model_no'];
    customerPrice = json['customer_price'];
    salesPrice = json['sales_price'];
    distributorPrice = json['distributor_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_no_id'] = this.modelNoId;
    data['model_no'] = this.modelNo;
    data['customer_price'] = this.customerPrice;
    data['sales_price'] = this.salesPrice;
    data['distributor_price'] = this.distributorPrice;
    return data;
  }
}