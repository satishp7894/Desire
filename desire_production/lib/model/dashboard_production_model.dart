class ProductionDashBoardModel {
  bool status;
  String message;
  Data data;

  ProductionDashBoardModel({this.status, this.message, this.data});

  ProductionDashBoardModel.fromJson(Map<String, dynamic> json) {
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
  String dailyOrder;
  String dailyProduction;

  Data({this.dailyOrder, this.dailyProduction});

  Data.fromJson(Map<String, dynamic> json) {
    dailyOrder = json['dailyOrder'];
    dailyProduction = json['dailyProduction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dailyOrder'] = this.dailyOrder;
    data['dailyProduction'] = this.dailyProduction;
    return data;
  }
}
