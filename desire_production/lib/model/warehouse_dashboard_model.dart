class WarehouseDashBoardModel {
  bool status;
  String message;
  Data data;

  WarehouseDashBoardModel({this.status, this.message, this.data});

  WarehouseDashBoardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String totalWarehouseList;
  String totalReadyToDispatch;

  Data({this.totalWarehouseList, this.totalReadyToDispatch});

  Data.fromJson(Map<String, dynamic> json) {
    totalWarehouseList = json['totalWarehouseList'];
    totalReadyToDispatch = json['totalReadyToDispatch'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalWarehouseList'] = this.totalWarehouseList;
    data['totalReadyToDispatch'] = this.totalReadyToDispatch;
    return data;
  }
}
