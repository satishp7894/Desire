class SalesReportModel {
  bool status;
  String message;
  ReportData reportData;

  SalesReportModel({this.status, this.message, this.reportData});

  SalesReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    reportData = json['reportData'] != null
        ? new ReportData.fromJson(json['reportData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.reportData != null) {
      data['reportData'] = this.reportData.toJson();
    }
    return data;
  }
}

class ReportData {
  String totalOrder;
  String totalQuantity;
  String totalAmount;

  ReportData({this.totalOrder, this.totalQuantity, this.totalAmount});

  ReportData.fromJson(Map<String, dynamic> json) {
    totalOrder = json['total_order'];
    totalQuantity = json['total_quantity'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_order'] = this.totalOrder;
    data['total_quantity'] = this.totalQuantity;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}