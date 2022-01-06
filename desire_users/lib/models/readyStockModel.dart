class ReadyStockModel {
  bool status;
  String message;
  String productImageUrl;
  List<ReadyStockProductList> readyStockProductList;

  ReadyStockModel(
      {this.status,
        this.message,
        this.productImageUrl,
        this.readyStockProductList});

  ReadyStockModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    productImageUrl = json['product_image_url'];
    if (json['readyStockProductList'] != null) {
      readyStockProductList = new List<ReadyStockProductList>();
      json['readyStockProductList'].forEach((v) {
        readyStockProductList.add(new ReadyStockProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['product_image_url'] = this.productImageUrl;
    if (this.readyStockProductList != null) {
      data['readyStockProductList'] =
          this.readyStockProductList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReadyStockProductList {
  String readyStockDetailsId;
  String readyStockId;
  String modelNoId;
  String modelNo;
  String productId;
  String productName;
  String image;
  String quantity;

  ReadyStockProductList(
      {this.readyStockDetailsId,
        this.readyStockId,
        this.modelNoId,
        this.modelNo,
        this.productId,
        this.productName,
        this.image,
        this.quantity});

  ReadyStockProductList.fromJson(Map<String, dynamic> json) {
    readyStockDetailsId = json['ready_stock_details_id'];
    readyStockId = json['ready_stock_id'];
    modelNoId = json['model_no_id'];
    modelNo = json['model_no'];
    productId = json['product_id'];
    productName = json['product_name'];
    image = json['image'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ready_stock_details_id'] = this.readyStockDetailsId;
    data['ready_stock_id'] = this.readyStockId;
    data['model_no_id'] = this.modelNoId;
    data['model_no'] = this.modelNo;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['image'] = this.image;
    data['quantity'] = this.quantity;
    return data;
  }
}