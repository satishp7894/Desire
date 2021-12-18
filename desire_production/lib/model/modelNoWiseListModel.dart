class ModelNoWiseListModel {
  bool status;
  String message;
  List<Data> data;

  ModelNoWiseListModel({this.status, this.message, this.data});

  ModelNoWiseListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
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

class Data {
  var orderdetailId;
  var customerName;
  var productName;
  var productQuantity;
  var perBoxStick;

  Data(
      {this.orderdetailId,
        this.customerName,
        this.productName,
        this.productQuantity,
        this.perBoxStick});

  Data.fromJson(Map<String, dynamic> json) {
    orderdetailId = json['orderdetail_id'];
    customerName = json['Customer_name'];
    productName = json['product_name'];
    productQuantity = json['product_quantity'];
    perBoxStick = json['per_box_stick'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderdetail_id'] = this.orderdetailId;
    data['Customer_name'] = this.customerName;
    data['product_name'] = this.productName;
    data['product_quantity'] = this.productQuantity;
    data['per_box_stick'] = this.perBoxStick;
    return data;
  }
}
