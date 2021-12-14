class OrderModel {
  bool status;
  List<Data> data;
  String message;

  OrderModel({this.status, this.data, this.message});

  OrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String orderId;
  String salesmanId;
  String editorderapproval;
  String departmentStatus;
  String orderNumber;
  String customerId;
  String shippingId;
  String addressId;
  String totalOrderQuantity;
  String orderAmount;
  String discountCoupon;
  String discountedOrderAmount;
  String orderNotes;
  String orderDate;
  String deliveryStatus;

  Data(
      {this.orderId,
        this.salesmanId,
        this.editorderapproval,
        this.departmentStatus,
        this.orderNumber,
        this.customerId,
        this.shippingId,
        this.addressId,
        this.totalOrderQuantity,
        this.orderAmount,
        this.discountCoupon,
        this.discountedOrderAmount,
        this.orderNotes,
        this.orderDate,
        this.deliveryStatus});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    salesmanId = json['salesman_id'];
    editorderapproval = json['editorderapproval'];
    departmentStatus = json['department_status'];
    orderNumber = json['order_number'];
    customerId = json['customer_id'];
    shippingId = json['shipping_id'];
    addressId = json['address_id'];
    totalOrderQuantity = json['total_order_quantity'];
    orderAmount = json['order_amount'];
    discountCoupon = json['discount_coupon'];
    discountedOrderAmount = json['discounted_order_amount'];
    orderNotes = json['order_notes'];
    orderDate = json['order_date'];
    deliveryStatus = json['delivery_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['salesman_id'] = this.salesmanId;
    data['editorderapproval'] = this.editorderapproval;
    data['department_status'] = this.departmentStatus;
    data['order_number'] = this.orderNumber;
    data['customer_id'] = this.customerId;
    data['shipping_id'] = this.shippingId;
    data['address_id'] = this.addressId;
    data['total_order_quantity'] = this.totalOrderQuantity;
    data['order_amount'] = this.orderAmount;
    data['discount_coupon'] = this.discountCoupon;
    data['discounted_order_amount'] = this.discountedOrderAmount;
    data['order_notes'] = this.orderNotes;
    data['order_date'] = this.orderDate;
    data['delivery_status'] = this.deliveryStatus;
    return data;
  }
}
