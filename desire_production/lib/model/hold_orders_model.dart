class HoldOrderModel {
  bool status;
  String message;
  List<HoldOrder> holdOrder;

  HoldOrderModel({this.status, this.message, this.holdOrder});

  HoldOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['holdOrder'] != null) {
      holdOrder = new List<HoldOrder>();
      json['holdOrder'].forEach((v) {
        holdOrder.add(new HoldOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.holdOrder != null) {
      data['holdOrder'] = this.holdOrder.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HoldOrder {
  String orderId;
  String orderNumber;
  String customerId;
  String totalOrderQuantity;
  String orderAmount;
  String customerName;

  HoldOrder(
      {this.orderId,
        this.orderNumber,
        this.customerId,
        this.totalOrderQuantity,
        this.orderAmount,
        this.customerName});

  HoldOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    customerId = json['customer_id'];
    totalOrderQuantity = json['total_order_quantity'];
    orderAmount = json['order_amount'];
    customerName = json['Customer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_number'] = this.orderNumber;
    data['customer_id'] = this.customerId;
    data['total_order_quantity'] = this.totalOrderQuantity;
    data['order_amount'] = this.orderAmount;
    data['Customer_name'] = this.customerName;
    return data;
  }
}