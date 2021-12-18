class DispatchProcessingModel {
  DispatchProcessingModel({
    this.status,
    this.dispatch,
    this.message,
  });

  bool status;
  List<Dispatch> dispatch;
  String message;

  factory DispatchProcessingModel.fromJson(Map<String, dynamic> json) => DispatchProcessingModel(
    status: json["status"],
    dispatch: List<Dispatch>.from(json["data"].map((x) => Dispatch.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(dispatch.map((x) => x.toJson())),
    "message": message,
  };
}

class Dispatch {
  Dispatch({
    this.orderdetailId,
    this.dispatchStatus,
    this.orderDetailsKey,
    this.orderTrackingDetails,
    this.orderId,
    this.productId,
    this.productQuantity,
    this.mrpPrice,
    this.netRate,
    this.totalAmount,
    this.bill,
    this.ordAddBy,
    this.ordUpdateBy,
    this.ordAddDate,
    this.ordUpdateDate,
    this.ordStatus,
    this.productName,
    this.image,
    this.profileNo,
    this.modelNo,
    this.dimensionId,
    this.category,
    this.customerprice,
    this.distributorprice,
    this.salesmanprice,
    this.remarks,
    this.accessories,
    this.futureProduct,
    this.newProduct,
    this.bestSeller,
    this.createdBy,
    this.isStatus,
  });

  String orderdetailId;
  String dispatchStatus;
  String orderDetailsKey;
  String orderTrackingDetails;
  String orderId;
  String productId;
  String productQuantity;
  String mrpPrice;
  String netRate;
  String totalAmount;
  String bill;
  String ordAddBy;
  String ordUpdateBy;
  DateTime ordAddDate;
  String ordUpdateDate;
  String ordStatus;
  String productName;
  String image;
  String profileNo;
  String modelNo;
  String dimensionId;
  String category;
  String customerprice;
  String distributorprice;
  String salesmanprice;
  String remarks;
  String accessories;
  String futureProduct;
  String newProduct;
  String bestSeller;
  String createdBy;
  String isStatus;

  factory Dispatch.fromJson(Map<String, dynamic> json) => Dispatch(
    orderdetailId: json["orderdetail_id"],
    dispatchStatus: json["Dispatch_Status"],
    orderDetailsKey: json["order_details_key"],
    orderTrackingDetails: json["order_tracking_details"],
    orderId: json["order_id"],
    productId: json["product_id"],
    productQuantity: json["product_quantity"],
    mrpPrice: json["mrp_price"],
    netRate: json["net_rate"],
    totalAmount: json["total_amount"],
    bill: json["bill"],
    ordAddBy: json["ord_add_by"],
    ordUpdateBy: json["ord_update_by"],
    ordAddDate: DateTime.parse(json["ord_add_date"]),
    ordUpdateDate: json["ord_update_date"],
    ordStatus: json["ord_status"],
    productName: json["product_name"],
    image: json["image"],
    profileNo: json["profile_no"],
    modelNo: json["model_no"],
    dimensionId: json["dimension_id"],
    category: json["category"],
    customerprice: json["Customerprice"],
    distributorprice: json["Distributorprice"],
    salesmanprice: json["Salesmanprice"],
    remarks: json["Remarks"],
    accessories: json["Accessories"],
    futureProduct: json["Future_Product"],
    newProduct: json["New_Product"],
    bestSeller: json["Best_Seller"],
    createdBy: json["created_by"],
    isStatus: json["is_status"],
  );

  Map<String, dynamic> toJson() => {
    "orderdetail_id": orderdetailId,
    "Dispatch_Status": dispatchStatus,
    "order_details_key": orderDetailsKey,
    "order_tracking_details": orderTrackingDetails,
    "order_id": orderId,
    "product_id": productId,
    "product_quantity": productQuantity,
    "mrp_price": mrpPrice,
    "net_rate": netRate,
    "total_amount": totalAmount,
    "bill": bill,
    "ord_add_by": ordAddBy,
    "ord_update_by": ordUpdateBy,
    "ord_add_date": ordAddDate.toIso8601String(),
    "ord_update_date": ordUpdateDate,
    "ord_status": ordStatus,
    "product_name": productName,
    "image": image,
    "profile_no": profileNo,
    "model_no": modelNo,
    "dimension_id": dimensionId,
    "category": category,
    "Customerprice": customerprice,
    "Distributorprice": distributorprice,
    "Salesmanprice": salesmanprice,
    "Remarks": remarks,
    "Accessories": accessories,
    "Future_Product": futureProduct,
    "New_Product": newProduct,
    "Best_Seller": bestSeller,
    "created_by": createdBy,
    "is_status": isStatus,
  };
}
