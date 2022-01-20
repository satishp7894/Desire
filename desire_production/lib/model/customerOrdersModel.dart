class CustomerOrdersModel {
  bool status;
  String message;
  List<Data> data;

  CustomerOrdersModel({this.status, this.message, this.data});

  CustomerOrdersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String orderId;
  String departmentStatus;
  String orderNumber;
  String customerId;
  String customerName;
  String addressId;
  String totalOrderQuantity;
  String orderAmount;
  String orderDate;
  String deliveryStatus;

  Data(
      {this.orderId,
        this.departmentStatus,
        this.orderNumber,
        this.customerId,
        this.customerName,
        this.addressId,
        this.totalOrderQuantity,
        this.orderAmount,
        this.orderDate,
        this.deliveryStatus});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    departmentStatus = json['department_status'];
    orderNumber = json['order_number'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    addressId = json['address_id'];
    totalOrderQuantity = json['total_order_quantity'];
    orderAmount = json['order_amount'];
    orderDate = json['order_date'];
    deliveryStatus = json['delivery_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['department_status'] = this.departmentStatus;
    data['order_number'] = this.orderNumber;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['address_id'] = this.addressId;
    data['total_order_quantity'] = this.totalOrderQuantity;
    data['order_amount'] = this.orderAmount;
    data['order_date'] = this.orderDate;
    data['delivery_status'] = this.deliveryStatus;
    return data;
  }
}
