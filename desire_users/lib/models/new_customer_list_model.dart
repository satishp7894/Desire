class CustomerListModel {
  bool status;
  String message;
  List<CustomerList> customerList;

  CustomerListModel({this.status, this.message, this.customerList});

  CustomerListModel.fromJson(Map<String, dynamic> json) {
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
  String companyName;
  String salesmanIDAssign;
  String email;
  String mobileNo;
  String userName;
  String password;
  String showPassword;
  String address;
  String area;
  String city;
  String state;
  String pincode;
  String kycStatus;
  String kycApprove;
  String priceList;
  String remarks;
  String createdBy;
  String modifiedBy;
  String created;
  String modified;
  String isActive;

  CustomerList(
      {this.customerId,
        this.customerName,
        this.companyName,
        this.salesmanIDAssign,
        this.email,
        this.mobileNo,
        this.userName,
        this.password,
        this.showPassword,
        this.address,
        this.area,
        this.city,
        this.state,
        this.pincode,
        this.kycStatus,
        this.kycApprove,
        this.priceList,
        this.remarks,
        this.createdBy,
        this.modifiedBy,
        this.created,
        this.modified,
        this.isActive});

  CustomerList.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    companyName = json['Company_name'];
    salesmanIDAssign = json['salesmanID_assign'];
    email = json['Email'];
    mobileNo = json['Mobile_no'];
    userName = json['User_name'];
    password = json['Password'];
    showPassword = json['show_password'];
    address = json['address'];
    area = json['area'];
    city = json['City'];
    state = json['State'];
    pincode = json['Pincode'];
    kycStatus = json['kyc_status'];
    kycApprove = json['kyc_approve'];
    priceList = json['price_list'];
    remarks = json['remarks'];
    createdBy = json['created_by'];
    modifiedBy = json['modified_by'];
    created = json['Created'];
    modified = json['Modified'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['Company_name'] = this.companyName;
    data['salesmanID_assign'] = this.salesmanIDAssign;
    data['Email'] = this.email;
    data['Mobile_no'] = this.mobileNo;
    data['User_name'] = this.userName;
    data['Password'] = this.password;
    data['show_password'] = this.showPassword;
    data['address'] = this.address;
    data['area'] = this.area;
    data['City'] = this.city;
    data['State'] = this.state;
    data['Pincode'] = this.pincode;
    data['kyc_status'] = this.kycStatus;
    data['kyc_approve'] = this.kycApprove;
    data['price_list'] = this.priceList;
    data['remarks'] = this.remarks;
    data['created_by'] = this.createdBy;
    data['modified_by'] = this.modifiedBy;
    data['Created'] = this.created;
    data['Modified'] = this.modified;
    data['is_active'] = this.isActive;
    return data;
  }
}
