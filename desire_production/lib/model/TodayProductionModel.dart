class TodayProductionModel {
  bool status;
  String message;
  List<TodaysProduction> todaysProduction;

  TodayProductionModel({this.status, this.message, this.todaysProduction});

  TodayProductionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['todaysProduction'] != null) {
      todaysProduction = new List<TodaysProduction>();
      json['todaysProduction'].forEach((v) {
        todaysProduction.add(new TodaysProduction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.todaysProduction != null) {
      data['todaysProduction'] =
          this.todaysProduction.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TodaysProduction {
  String dailyProductionId;
  String modelNoId;
  String modelNo;
  String qty;

  TodaysProduction(
      {this.dailyProductionId, this.modelNoId, this.modelNo, this.qty});

  TodaysProduction.fromJson(Map<String, dynamic> json) {
    dailyProductionId = json['daily_production_id'];
    modelNoId = json['model_no_id'];
    modelNo = json['model_no'];
    qty = json['qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['daily_production_id'] = this.dailyProductionId;
    data['model_no_id'] = this.modelNoId;
    data['model_no'] = this.modelNo;
    data['qty'] = this.qty;
    return data;
  }
}
