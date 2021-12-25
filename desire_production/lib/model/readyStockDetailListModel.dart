class ReadyStockDetailModel {
  String readyStockDetailsId;
  String readyStockId;
  String modelNoId;
  String modelNo;
  String productId;
  String productName;
  String image;
  String quantity;

  ReadyStockDetailModel(
      {this.readyStockDetailsId,
      this.readyStockId,
      this.modelNoId,
      this.modelNo,
      this.productId,
      this.productName,
      this.image,
      this.quantity});

  ReadyStockDetailModel.fromJson(Map<String, dynamic> json) {
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

class ReadyStockDetailListModel {
  bool status;
  String message;
  List<ReadyStockDetailModel> readyStockList;
  String productImageUrl;

  ReadyStockDetailListModel(
      {this.status, this.message, this.readyStockList, this.productImageUrl});

  ReadyStockDetailListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    productImageUrl = json['product_image_url'];
    if (json['readyStockProductList'] != null) {
      readyStockList = <ReadyStockDetailModel>[];
      json['readyStockProductList'].forEach((v) {
        readyStockList.add(new ReadyStockDetailModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['product_image_url'] = this.productImageUrl;
    if (this.readyStockList != null) {
      data['readyStockProductList'] =
          this.readyStockList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
