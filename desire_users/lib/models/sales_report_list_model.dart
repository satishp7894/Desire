class SalesReportListModel {
  bool status;
  String message;
  List<ReportDetails> reportDetails;

  SalesReportListModel({this.status, this.message, this.reportDetails});

  SalesReportListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['reportDetails'] != null) {
      reportDetails = new List<ReportDetails>();
      json['reportDetails'].forEach((v) {
        reportDetails.add(new ReportDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.reportDetails != null) {
      data['reportDetails'] =
          this.reportDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReportDetails {
  String orderId;
  String orderNumber;
  String customerId;
  String customerName;
  String totalOrderQuantity;
  String orderAmount;
  String orderDate;

  ReportDetails(
      {this.orderId,
        this.orderNumber,
        this.customerId,
        this.customerName,
        this.totalOrderQuantity,
        this.orderAmount,
        this.orderDate});

  ReportDetails.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    totalOrderQuantity = json['total_order_quantity'];
    orderAmount = json['order_amount'];
    orderDate = json['order_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_number'] = this.orderNumber;
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['total_order_quantity'] = this.totalOrderQuantity;
    data['order_amount'] = this.orderAmount;
    data['order_date'] = this.orderDate;
    return data;
  }
}