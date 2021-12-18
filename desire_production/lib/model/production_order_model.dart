// To parse this JSON data, do
//
//     final productionOrderModel = productionOrderModelFromJson(jsonString);
class ProductionOrderModel {
  ProductionOrderModel({
    this.status,
    this.data,
    this.message,
  });

  bool status;
  Data data;
  String message;

  factory ProductionOrderModel.fromJson(Map<String, dynamic> json) => ProductionOrderModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  Data({
    this.order,
  });

  List<Order> order;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    order: List<Order>.from(json["order"].map((x) => Order.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "order": List<dynamic>.from(order.map((x) => x.toJson())),
  };
}

class Order {
  Order({
    this.orderId,
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
    this.deliveryStatus,
    this.reason,
    this.orderAddBy,
    this.orderUpdateBy,
    this.orderAddDate,
    this.orderUpdateDate,
    this.orderStatus,
  });

  String orderId;
  dynamic salesmanId;
  dynamic editorderapproval;
  String departmentStatus;
  String orderNumber;
  String customerId;
  dynamic shippingId;
  String addressId;
  String totalOrderQuantity;
  String orderAmount;
  dynamic discountCoupon;
  dynamic discountedOrderAmount;
  String orderNotes;
  DateTime orderDate;
  String deliveryStatus;
  String reason;
  String orderAddBy;
  String orderUpdateBy;
  String orderAddDate;
  String orderUpdateDate;
  String orderStatus;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    orderId: json["order_id"],
    salesmanId: json["salesman_id"],
    editorderapproval: json["editorderapproval"],
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
    orderAddDate: json["order_add_date"],
    orderUpdateDate: json["order_update_date"],
    orderStatus: json["order_status"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "salesman_id": salesmanId,
    "editorderapproval": editorderapproval,
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
    "order_add_date": orderAddDate,
    "order_update_date": orderUpdateDate,
    "order_status": orderStatus,
  };
}
