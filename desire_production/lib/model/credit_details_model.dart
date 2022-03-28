class CreditDetailsModel {
  bool status;
  CustomerCreditDetails customerCreditDetails;

  CreditDetailsModel({this.status, this.customerCreditDetails});

  CreditDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    customerCreditDetails = json['customerCreditDetails'] != null
        ? new CustomerCreditDetails.fromJson(json['customerCreditDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.customerCreditDetails != null) {
      data['customerCreditDetails'] = this.customerCreditDetails.toJson();
    }
    return data;
  }
}

class CustomerCreditDetails {
  String creditId;
  String customerId;
  String customerName;
  String creditLimit;
  String creditDays;
  String pendingCreditLimit;
  String creditStatus;

  CustomerCreditDetails(
      {this.creditId,
        this.customerId,
        this.customerName,
        this.creditLimit,
        this.creditDays,
        this.pendingCreditLimit,
        this.creditStatus});

  CustomerCreditDetails.fromJson(Map<String, dynamic> json) {
    creditId = json['credit_id'];
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    creditLimit = json['credit_limit'];
    creditDays = json['credit_days'];
    pendingCreditLimit = json['pending_credit_limit'];
    creditStatus = json['credit_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['credit_id'] = this.creditId;
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['credit_limit'] = this.creditLimit;
    data['credit_days'] = this.creditDays;
    data['pending_credit_limit'] = this.pendingCreditLimit;
    data['credit_status'] = this.creditStatus;
    return data;
  }
}