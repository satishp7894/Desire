class CartModel {
  CartModel({
    this.status,
    this.data,
    this.message,
  });

  bool status;
  List<Cart> data;
  String message;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    status: json["status"],
    data: json["data"] == "null" ? null : List<Cart>.from(json["data"].map((x) => Cart.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Cart {
  Cart({
    this.productId,
    this.categoryId,
    this.productName,
    this.customerprice,
    this.image,
    this.quantity,
  });

  String productId;
  String categoryId;
  String productName;
  String customerprice;
  String image;
  String quantity;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    productId: json["product_id"],
    categoryId: json["category_id"],
    productName: json["product_name"],
    customerprice: json["Customerprice"],
    image: json["image"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "category_id": categoryId,
    "product_name": productName,
    "Customerprice": customerprice,
    "image": image,
    "quantity": quantity,
  };
}
