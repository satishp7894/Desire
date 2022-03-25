class KycPendingListModel {
  bool status;
  String message;
  List<CustomerList> customerList;

  KycPendingListModel({this.status, this.message, this.customerList});

  KycPendingListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['customerList'] != null) {
      customerList = new List<CustomerList>();
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
  String companyName;
  String salesmanIDAssign;
  String salesmanName;
  String email;
  String mobileNo;
  String kycStatus;
  String kycApprove;
  String creditLimit;
  String creditDays;
  String pendingCreditLimit;
  String creditStatus;

  CustomerList(
      {this.customerId,
        this.customerName,
        this.companyName,
        this.salesmanIDAssign,
        this.salesmanName,
        this.email,
        this.mobileNo,
        this.kycStatus,
        this.kycApprove,this.creditLimit,
        this.creditDays,
        this.pendingCreditLimit,
        this.creditStatus});

  CustomerList.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    companyName = json['Company_name'];
    salesmanIDAssign = json['salesmanID_assign'];
    salesmanName = json['salesman_name'];
    email = json['Email'];
    mobileNo = json['Mobile_no'];
    kycStatus = json['kyc_status'];
    kycApprove = json['kyc_approve'];
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
    data['Email'] = this.email;
    data['Mobile_no'] = this.mobileNo;
    data['kyc_status'] = this.kycStatus;
    data['kyc_approve'] = this.kycApprove;
    data['credit_limit'] = this.creditLimit;
    data['credit_days'] = this.creditDays;
    data['pending_credit_limit'] = this.pendingCreditLimit;
    data['credit_status'] = this.creditStatus;
    return data;
  }
}