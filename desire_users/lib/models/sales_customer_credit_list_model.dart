class SalesCustomerCredirListModel {
  bool status;
  String message;
  List<CreditList> creditList;

  SalesCustomerCredirListModel({this.status, this.message, this.creditList});

  SalesCustomerCredirListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['creditList'] != null) {
      creditList = new List<CreditList>();
      json['creditList'].forEach((v) {
        creditList.add(new CreditList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.creditList != null) {
      data['creditList'] = this.creditList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreditList {
  String creditId;
  String customerId;
  String customerName;
  String creditLimit;
  String pendingCreditLimit;
  String creditDays;

  CreditList(
      {this.creditId,
        this.customerId,
        this.customerName,
        this.creditLimit,
        this.pendingCreditLimit,
        this.creditDays});

  CreditList.fromJson(Map<String, dynamic> json) {
    creditId = json['credit_id'];
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    creditLimit = json['credit_limit'];
    pendingCreditLimit = json['pending_credit_limit'];
    creditDays = json['credit_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['credit_id'] = this.creditId;
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['credit_limit'] = this.creditLimit;
    data['pending_credit_limit'] = this.pendingCreditLimit;
    data['credit_days'] = this.creditDays;
    return data;
  }
}