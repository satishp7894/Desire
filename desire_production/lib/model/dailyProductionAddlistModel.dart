class DailyProductionAddlistModel {
  bool status;
  String message;
  List<Data1> data;

  DailyProductionAddlistModel({this.status, this.message, this.data});

  DailyProductionAddlistModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data1>[];
      json['data'].forEach((v) {
        data.add(new Data1.fromJson(v));
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

class Data1 {
  String modelNoId;
  String modelNo;

  Data1(
      {
        this.modelNoId,
        this.modelNo,
       });

  Data1.fromJson(Map<String, dynamic> json) {
    modelNoId = json['model_no_id'];
    modelNo = json['model_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_no_id'] = this.modelNoId;
    data['model_no'] = this.modelNo;
    return data;
  }
}
