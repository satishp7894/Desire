class DispatchOrderDetailsModel {
  bool status;
  String message;
  String orderId;
  String customerId;
  List<Data> data;

  DispatchOrderDetailsModel(
      {this.status, this.message, this.orderId, this.customerId, this.data});

  DispatchOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    orderId = json['order_id'];
    customerId = json['customer_id'];
    if (json['data'] != null) {
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
    data['order_id'] = this.orderId;
    data['customer_id'] = this.customerId;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String wdId;
  String orderId;
  String orderNumber;
  String customerId;
  String customerName;
  String modelNoId;
  String modelNo;
  String orderDetailsId;
  String productId;
  String productName;
  String qty;

  Data(
      {this.wdId,
        this.orderId,
        this.orderNumber,
        this.customerId,
        this.customerName,
        this.modelNoId,
        this.modelNo,
        this.orderDetailsId,
        this.productId,
        this.productName,
        this.qty});

  Data.fromJson(Map<String, dynamic> json) {
    wdId = json['wd_id'];
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    modelNoId = json['model_no_id'];
    modelNo = json['model_no'];
    orderDetailsId = json['order_details_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wd_id'] = this.wdId;
    data['order_id'] = this.orderId;
    data['order_number'] = this.orderNumber;
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['model_no_id'] = this.modelNoId;
    data['model_no'] = this.modelNo;
    data['order_details_id'] = this.orderDetailsId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['qty'] = this.qty;
    return data;
  }
}
