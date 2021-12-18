class CartModel {
  bool status;
  int totalQuantity;
  int totalAmount;
  List<Cart> data;
  String message;

  CartModel(
      {this.status,
        this.totalQuantity,
        this.totalAmount,
        this.data,
        this.message});

  CartModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalQuantity = json['total_quantity'];
    totalAmount = json['total_amount'];
    if (json['data'] != null) {
      data = <Cart>[];
      json['data'].forEach((v) {
        data.add(new Cart.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['total_quantity'] = this.totalQuantity;
    data['total_amount'] = this.totalAmount;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Cart {
  String productId;
  String productName;
  String image;
  String customerprice;
  String perBoxStick;
  int boxPrice;
  String quantity;
  int totAmount;

  Cart(
      {this.productId,
        this.productName,
        this.image,
        this.customerprice,
        this.perBoxStick,
        this.boxPrice,
        this.quantity,
        this.totAmount});

  Cart.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    image = json['image'];
    customerprice = json['Customerprice'];
    perBoxStick = json['per_box_stick'];
    boxPrice = json['box_price'];
    quantity = json['quantity'];
    totAmount = json['tot_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['image'] = this.image;
    data['Customerprice'] = this.customerprice;
    data['per_box_stick'] = this.perBoxStick;
    data['box_price'] = this.boxPrice;
    data['quantity'] = this.quantity;
    data['tot_amount'] = this.totAmount;
    return data;
  }
}