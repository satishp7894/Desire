class OrderModel {
  OrderModel({
    this.status,
    this.order,
    this.message,
  });

  bool status;
  List<Order> order;
  String message;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    status: json["status"],
    order: json["data"] == "null" ? null : List<Order>.from(json["data"].map((x) => Order.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(order.map((x) => x.toJson())),
    "message": message,
  };
}

class Order {
  Order({
    this.orderId,
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
    this.deliveryStatus,
    this.reason,
    this.orderAddBy,
    this.orderUpdateBy,
    this.orderAddDate,
    this.orderUpdateDate,
    this.orderStatus,
    this.editOrderApproval,
  });

  String orderId;
  String departmentStatus;
  String orderNumber;
  String customerId;
  dynamic shippingId;
  String addressId;
  String totalOrderQuantity;
  String orderAmount;
  String discountCoupon;
  String discountedOrderAmount;
  String orderNotes;
  DateTime orderDate;
  String deliveryStatus;
  String reason;
  String orderAddBy;
  String orderUpdateBy;
  DateTime orderAddDate;
  String orderUpdateDate;
  String orderStatus;
  String editOrderApproval;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    orderId: json["order_id"],
    departmentStatus: json["department_status"],
    orderNumber: json["order_number"],
    customerId: json["customer_id"],
    shippingId: json["shipping_id"],
    addressId: json["address_id"],
    totalOrderQuantity: json["total_order_quantity"],
    orderAmount: json["order_amount"],
    discountCoupon: json["discount_coupon"],
    discountedOrderAmount: json["discounted_order_amount"],
    orderNotes: json["order_notes"],
    orderDate: DateTime.parse(json["order_date"]),
    deliveryStatus: json["delivery_status"],
    reason: json["reason"],
    orderAddBy: json["order_add_by"],
    orderUpdateBy: json["order_update_by"],
    orderAddDate: DateTime.parse(json["order_add_date"]),
    orderUpdateDate: json["order_update_date"],
    orderStatus: json["order_status"],
    editOrderApproval: json["editorderapproval"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "department_status": departmentStatus,
    "order_number": orderNumber,
    "customer_id": customerId,
    "shipping_id": shippingId,
    "address_id": addressId,
    "total_order_quantity": totalOrderQuantity,
    "order_amount": orderAmount,
    "discount_coupon": discountCoupon,
    "discounted_order_amount": discountedOrderAmount,
    "order_notes": orderNotes,
    "order_date": orderDate.toIso8601String(),
    "delivery_status": deliveryStatus,
    "reason": reason,
    "order_add_by": orderAddBy,
    "order_update_by": orderUpdateBy,
    "order_add_date": orderAddDate.toIso8601String(),
    "order_update_date": orderUpdateDate,
    "order_status": orderStatus,
    "editorderapproval":editOrderApproval,
  };
}
