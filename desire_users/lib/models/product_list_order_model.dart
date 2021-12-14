class ProductListOrderModel {
  ProductListOrderModel({
    this.status,
    this.products,
    this.message,
  });

  bool status;
  List<Product> products;
  String message;

  factory ProductListOrderModel.fromJson(Map<String, dynamic> json) => ProductListOrderModel(
    status: json["status"],
    products: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(products.map((x) => x.toJson())),
    "message": message,
  };
}

class Product {
  Product({
    this.orderdetailId,
    this.dispatchStatus,
    this.orderTrackingDetails,
    this.orderDetailKey,
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
    this.futureProduct,
    this.newProduct,
    this.bestSeller,
    this.dimensionsName,
    this.size,
    this.isStatus,
  });

  String orderdetailId;
  String dispatchStatus;
  String orderDetailKey;
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
  String ordAddDate;
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
  String futureProduct;
  String newProduct;
  String bestSeller;
  String dimensionsName;
  String size;
  String isStatus;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    orderdetailId: json["orderdetail_id"],
    dispatchStatus: json["Dispatch_Status"],
    orderDetailKey: json["order_details_key"] == null ? null : json["order_details_key"],
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
    ordAddDate: json["ord_add_date"],
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
    futureProduct: json["Future_Product"],
    newProduct: json["New_Product"],
    bestSeller: json["Best_Seller"],
    dimensionsName : json["dimensions_name"],
    size : json["size"],
    isStatus: json["is_status"],
  );

  Map<String, dynamic> toJson() => {
    "orderdetail_id": orderdetailId,
    "Dispatch_Status":dispatchStatus,
    "order_details_key":orderDetailKey,
    "order_tracking_details":orderTrackingDetails,
    "order_id": orderId,
    "product_id": productId,
    "product_quantity": productQuantity,
    "mrp_price": mrpPrice,
    "net_rate": netRate,
    "total_amount": totalAmount,
    "bill": bill,
    "ord_add_by": ordAddBy,
    "ord_update_by": ordUpdateBy,
    "ord_add_date": ordAddDate,
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
    "Future_Product": futureProduct,
    "New_Product": newProduct,
    "Best_Seller": bestSeller,
    "dimensions_name":dimensionsName,
    "size":size,
    "is_status": isStatus,
  };
}
