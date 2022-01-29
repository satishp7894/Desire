class CustomerCreditDetailsModel {
  bool status;
  String message;
  creditDetails data;

  CustomerCreditDetailsModel({this.status, this.message, this.data});

  CustomerCreditDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new creditDetails.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class creditDetails {
  String creditLimit;
  String pendingCreditLimit;
  String creditDays;

  creditDetails({this.creditLimit, this.pendingCreditLimit, this.creditDays});

  creditDetails.fromJson(Map<String, dynamic> json) {
    creditLimit = json['credit_limit'];
    pendingCreditLimit = json['pending_credit_limit'];
    creditDays = json['credit_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['credit_limit'] = this.creditLimit;
    data['pending_credit_limit'] = this.pendingCreditLimit;
    data['credit_days'] = this.creditDays;
    return data;
  }
}