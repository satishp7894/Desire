class ReadyStockListModel {
  bool status;
  String message;
  List<ReadyStockList> readyStockList;

  ReadyStockListModel({this.status, this.message, this.readyStockList});

  ReadyStockListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['readyStockList'] != null) {
      readyStockList = <ReadyStockList>[];
      json['readyStockList'].forEach((v) {
        readyStockList.add(new ReadyStockList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.readyStockList != null) {
      data['readyStockList'] =
          this.readyStockList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReadyStockList {
  String readyStockId;
  String modelNoId;
  String quantity;
  String createdBy;
  String updateBy;
  String createdAt;
  String updateAt;
  String isActive;

  ReadyStockList(
      {this.readyStockId,
        this.modelNoId,
        this.quantity,
        this.createdBy,
        this.updateBy,
        this.createdAt,
        this.updateAt,
        this.isActive});

  ReadyStockList.fromJson(Map<String, dynamic> json) {
    readyStockId = json['ready_stock_id'];
    modelNoId = json['model_no_id'];
    quantity = json['quantity'];
    createdBy = json['created_by'];
    updateBy = json['update_by'];
    createdAt = json['created_at'];
    updateAt = json['update_at'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ready_stock_id'] = this.readyStockId;
    data['model_no_id'] = this.modelNoId;
    data['quantity'] = this.quantity;
    data['created_by'] = this.createdBy;
    data['update_by'] = this.updateBy;
    data['created_at'] = this.createdAt;
    data['update_at'] = this.updateAt;
    data['is_active'] = this.isActive;
    return data;
  }
}
