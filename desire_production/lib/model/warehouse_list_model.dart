class WareHouseListModel {
  bool status;
  String message;
  List<Data> data;

  WareHouseListModel({this.status, this.message, this.data});

  WareHouseListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String warehouseId;
  String modelNoId;
  String modelNo;
  String warehouseQty;
  String createdBy;

  Data(
      {this.warehouseId,
        this.modelNoId,
        this.modelNo,
        this.warehouseQty,
        this.createdBy});

  Data.fromJson(Map<String, dynamic> json) {
    warehouseId = json['warehouse_id'];
    modelNoId = json['model_no_id'];
    modelNo = json['model_no'];
    warehouseQty = json['warehouse_qty'];
    createdBy = json['created_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['warehouse_id'] = this.warehouseId;
    data['model_no_id'] = this.modelNoId;
    data['model_no'] = this.modelNo;
    data['warehouse_qty'] = this.warehouseQty;
    data['created_by'] = this.createdBy;
    return data;
  }
}
