class CustomerListWithCreditModel {
  bool status;
  String message;
  List<CustomerListWithCredit> customerListWithCredit;

  CustomerListWithCreditModel({this.status, this.message, this.customerListWithCredit});

  CustomerListWithCreditModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['customerListWithCredit'] != null) {
      customerListWithCredit = new List<CustomerListWithCredit>();
      json['customerListWithCredit'].forEach((v) {
        customerListWithCredit.add(new CustomerListWithCredit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.customerListWithCredit != null) {
      data['customerListWithCredit'] =
          this.customerListWithCredit.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerListWithCredit {
  String customerId;
  String customerName;
  String companyName;
  String salesmanIDAssign;
  String firstname;
  String lastname;
  String creditLimit;
  String pendingCreditLimit;
  String creditDays;

  CustomerListWithCredit(
      {this.customerId,
        this.customerName,
        this.companyName,
        this.salesmanIDAssign,
        this.firstname,
        this.lastname,
        this.creditLimit,
        this.pendingCreditLimit,
        this.creditDays});

  CustomerListWithCredit.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    companyName = json['Company_name'];
    salesmanIDAssign = json['salesmanID_assign'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    creditLimit = json['credit_limit'];
    pendingCreditLimit = json['pending_credit_limit'];
    creditDays = json['credit_days'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['Company_name'] = this.companyName;
    data['salesmanID_assign'] = this.salesmanIDAssign;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['credit_limit'] = this.creditLimit;
    data['pending_credit_limit'] = this.pendingCreditLimit;
    data['credit_days'] = this.creditDays;
    return data;
  }
}