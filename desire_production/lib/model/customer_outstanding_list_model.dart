class CustomerOutstandingListModel {
  bool status;
  String message;
  List<TotalOutstanding> totalOutstanding;

  CustomerOutstandingListModel({this.status, this.message, this.totalOutstanding});

  CustomerOutstandingListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['totalOutstanding'] != null) {
      totalOutstanding = new List<TotalOutstanding>();
      json['totalOutstanding'].forEach((v) {
        totalOutstanding.add(new TotalOutstanding.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.totalOutstanding != null) {
      data['totalOutstanding'] =
          this.totalOutstanding.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TotalOutstanding {
  String customerId;
  String customerName;
  String totalOutstanding;
  String immediatePayment;

  TotalOutstanding(
      {this.customerId,
        this.customerName,
        this.totalOutstanding,
        this.immediatePayment});

  TotalOutstanding.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    totalOutstanding = json['total_outstanding'];
    immediatePayment = json['immediatePayment'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['total_outstanding'] = this.totalOutstanding;
    data['immediatePayment'] = this.immediatePayment;
    return data;
  }
}