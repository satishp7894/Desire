class DispatchOrderWarhouseListModel {
  bool status;
  String message;
  String customerId;
  List<DataWarhouse> data;

  DispatchOrderWarhouseListModel(
      {this.status, this.message, this.customerId, this.data});

  DispatchOrderWarhouseListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    customerId = json['customer_id'];
    if (json['data'] != null) {
      data = new List<DataWarhouse>();
      json['data'].forEach((v) {
        data.add(new DataWarhouse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['customer_id'] = this.customerId;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<Map<String, dynamic>> toPostJson() {
    return this
        .data
        .where((v) => v.isSelected)
        .map((v) => v.toPostJson())
        .toList();
  }
}

class DataWarhouse {
  String orderdetailId;
  String orderId;
  String customerId;
  String customerName;
  String productId;
  String productName;
  String hsnSac;
  String productQuantity;
  String mrpPrice;
  String modelNo;
  String perBoxStick;
  int totalStick;
  int totalPrice;
  bool isSelected = false;

  DataWarhouse(
      {this.orderdetailId,
      this.orderId,
      this.customerId,
      this.customerName,
      this.productId,
      this.productName,
      this.hsnSac,
      this.productQuantity,
      this.mrpPrice,
      this.modelNo,
      this.perBoxStick,
      this.totalStick,
      this.totalPrice});

  DataWarhouse.fromJson(Map<String, dynamic> json) {
    orderdetailId = json['orderdetail_id'];
    orderId = json['order_id'];
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    productId = json['product_id'];
    productName = json['product_name'];
    hsnSac = json['hsn_sac'];
    productQuantity = json['product_quantity'];
    mrpPrice = json['mrp_price'];
    modelNo = json['model_no'];
    perBoxStick = json['per_box_stick'];
    totalStick = json['total_stick'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderdetail_id'] = this.orderdetailId;
    data['order_id'] = this.orderId;
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['hsn_sac'] = this.hsnSac;
    data['product_quantity'] = this.productQuantity;
    data['mrp_price'] = this.mrpPrice;
    data['model_no'] = this.modelNo;
    data['per_box_stick'] = this.perBoxStick;
    data['total_stick'] = this.totalStick;
    data['total_price'] = this.totalPrice;
    return data;
  }

  Map<String, dynamic> toPostJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderdetail_id'] = this.orderdetailId;
    data['total_stick'] = this.totalStick;
    data['total_price'] = this.totalPrice;
    return data;
  }
}
