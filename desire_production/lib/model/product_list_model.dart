class ProductListModel {
  ProductListModel({
    this.status,
    this.product,
    this.message,
  });

  bool status;
  List<Product> product;
  String message;

  factory ProductListModel.fromJson(Map<String, dynamic> json) => ProductListModel(
    status: json["status"],
    product: List<Product>.from(json["data"].map((x) => Product.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(product.map((x) => x.toJson())),
    "message": message,
  };
}

class Product {
  Product({
    this.id,
    this.productName,
    this.qty,
  });

  String id;
  String productName;
  String qty;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    productName: json["product_name"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
    "qty": qty,
  };
}
