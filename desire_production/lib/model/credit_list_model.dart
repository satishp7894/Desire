class CreditListModel {
  bool status;
  String message;
  List<AllCustomerCredit> allCustomerCredit;

  CreditListModel({this.status, this.message, this.allCustomerCredit});

  CreditListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['allCustomerCredit'] != null) {
      allCustomerCredit = new List<AllCustomerCredit>();
      json['allCustomerCredit'].forEach((v) {
        allCustomerCredit.add(new AllCustomerCredit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.allCustomerCredit != null) {
      data['allCustomerCredit'] =
          this.allCustomerCredit.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllCustomerCredit {
  String customerId;
  String customerName;
  String companyName;
  String salesmanIDAssign;
  String salesmanName;
  String creditLimit;
  String creditDays;
  String pendingCreditLimit;
  String creditStatus;

  AllCustomerCredit(
      {this.customerId,
      this.customerName,
      this.companyName,
      this.salesmanIDAssign,
      this.salesmanName,
      this.creditLimit,
      this.creditDays,
      this.pendingCreditLimit,
      this.creditStatus});

  AllCustomerCredit.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    companyName = json['Company_name'];
    salesmanIDAssign = json['salesmanID_assign'];
    salesmanName = json['salesman_name'];
    creditLimit = json['credit_limit'];
    creditDays = json['credit_days'];
    pendingCreditLimit = json['pending_credit_limit'];
    creditStatus = json['credit_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['Company_name'] = this.companyName;
    data['salesmanID_assign'] = this.salesmanIDAssign;
    data['salesman_name'] = this.salesmanName;
    data['credit_limit'] = this.creditLimit;
    data['credit_days'] = this.creditDays;
    data['pending_credit_limit'] = this.pendingCreditLimit;
    data['credit_status'] = this.creditStatus;
    return data;
  }
}
