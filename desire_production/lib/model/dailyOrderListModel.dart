class DailyOrdersListModel {
  bool status;
  String message;
  List<Data> data;

  DailyOrdersListModel({this.status, this.message, this.data});

  DailyOrdersListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
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
  String dailyOrderId;
  String modelNoId;
  String modelNo;
  String qty;
  String createAt;

  Data(
      {this.dailyOrderId,
        this.modelNoId,
        this.modelNo,
        this.qty,
        this.createAt});

  Data.fromJson(Map<String, dynamic> json) {
    dailyOrderId = json['daily_order_id'];
    modelNoId = json['model_no_id'];
    modelNo = json['model_no'];
    qty = json['qty'];
    createAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['daily_order_id'] = this.dailyOrderId;
    data['model_no_id'] = this.modelNoId;
    data['model_no'] = this.modelNo;
    data['qty'] = this.qty;
    data['create_at'] = this.createAt;
    return data;
  }
}
