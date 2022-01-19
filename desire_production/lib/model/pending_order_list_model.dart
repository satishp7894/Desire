class PendingOrderListModel {
  bool status;
  String message;
  List<PendingOrder> pendingOrder;

  PendingOrderListModel({this.status, this.message, this.pendingOrder});

  PendingOrderListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['pendingOrder'] != null) {
      pendingOrder = new List<PendingOrder>();
      json['pendingOrder'].forEach((v) {
        pendingOrder.add(new PendingOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.pendingOrder != null) {
      data['pendingOrder'] = this.pendingOrder.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PendingOrder {
  String orderId;
  String orderNumber;
  String customerId;
  String totalOrderQuantity;
  String orderAmount;
  String customerName;

  PendingOrder(
      {this.orderId,
        this.orderNumber,
        this.customerId,
        this.totalOrderQuantity,
        this.orderAmount,
        this.customerName});

  PendingOrder.fromJson(Map<String, dynamic> json) {
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