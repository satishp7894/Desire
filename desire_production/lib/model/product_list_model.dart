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
    this.model_no,
    this.planning_date,
  });

  String id;
  String model_no;
  String planning_date;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    model_no: json["model_no"],
    planning_date: json["planning_date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "model_no": model_no,
    "planning_date": planning_date,
  };
}
