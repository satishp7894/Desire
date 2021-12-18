class ReadyToDispatchListModel {
  bool status;
  String message;
  List<Data> data;

  ReadyToDispatchListModel({this.status, this.message, this.data});

  ReadyToDispatchListModel.fromJson(Map<String, dynamic> json) {
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
  String orderId;
  String customerId;
  String orderNumber;
  String customerName;

  Data({this.orderId, this.customerId, this.orderNumber, this.customerName});

  Data.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    customerId = json['customer_id'];
    orderNumber = json['order_number'];
    customerName = json['Customer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['customer_id'] = this.customerId;
    data['order_number'] = this.orderNumber;
    data['Customer_name'] = this.customerName;
    return data;
  }
}
