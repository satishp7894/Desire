class ReadyStock {
  String readyStockId;
  String modelNoId;
  String modelNo;
  String quantity;

  ReadyStock({this.readyStockId, this.modelNoId, this.modelNo, this.quantity});

  ReadyStock.fromJson(Map<String, dynamic> json) {
    readyStockId = json['ready_stock_id'];
    modelNoId = json['model_no_id'];
    modelNo = json['model_no'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ready_stock_id'] = this.readyStockId;
    data['model_no_id'] = this.modelNoId;
    data['model_no'] = this.modelNo;
    data['quantity'] = this.quantity;
    return data;
  }
}

class ReadyStockListModel {
  bool status;
  String message;
  List<ReadyStock> readyStockList;

  ReadyStockListModel({this.status, this.message, this.readyStockList});

  ReadyStockListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['readyStockList'] != null) {
      readyStockList = <ReadyStock>[];
      json['readyStockList'].forEach((v) {
        readyStockList.add(new ReadyStock.fromJson(v));
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
