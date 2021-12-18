class CustomerListForChatModel {
  bool status;
  String message;
  List<CustomerList> customerList;

  CustomerListForChatModel({this.status, this.message, this.customerList});

  CustomerListForChatModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['customerList'] != null) {
      customerList = <CustomerList>[];
      json['customerList'].forEach((v) {
        customerList.add(new CustomerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.customerList != null) {
      data['customerList'] = this.customerList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerList {
  String customerId;
  String customerName;


  CustomerList(
      {this.customerId,
        this.customerName,
       });

  CustomerList.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    return data;
  }
}
