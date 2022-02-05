class TodayOrderDetailsPageModel {
  bool status;
  String message;
  List<TodayOrder> todayOrder;

  TodayOrderDetailsPageModel({this.status, this.message, this.todayOrder});

  TodayOrderDetailsPageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['todayOrder'] != null) {
      todayOrder = new List<TodayOrder>();
      json['todayOrder'].forEach((v) {
        todayOrder.add(new TodayOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.todayOrder != null) {
      data['todayOrder'] = this.todayOrder.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TodayOrder {
  String orderId;
  String orderNumber;
  String customerId;
  String customerName;
  String totalOrderQuantity;
  String orderAmount;

  TodayOrder(
      {this.orderId,
        this.orderNumber,
        this.customerId,
        this.customerName,
        this.totalOrderQuantity,
        this.orderAmount});

  TodayOrder.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    totalOrderQuantity = json['total_order_quantity'];
    orderAmount = json['order_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_number'] = this.orderNumber;
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['total_order_quantity'] = this.totalOrderQuantity;
    data['order_amount'] = this.orderAmount;
    return data;
  }
}