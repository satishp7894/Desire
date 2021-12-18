class SalesCustomerModel {
  SalesCustomerModel({
    this.status,
    this.customer,
    this.message,
  });

  bool status;
  List<UserModel> customer;
  String message;

  factory SalesCustomerModel.fromJson(Map<String, dynamic> json) => SalesCustomerModel(
    status: json["status"],
    customer: json["data"] == "null" ? null : List<UserModel>.from(json["data"].map((x) => UserModel.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "customer": List<dynamic>.from(customer.map((x) => x.toJson())),
    "message": message,
  };
}

class UserModel {
  UserModel({
    this.companyName,
    this.customerId,
    this.customerName,
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
    this.remarks,
    this.isActive,
    this.salesmanId
  });

  String companyName;
  String customerId;
  String customerName;
  String email;
  String mobileNo;
  String userName;
  String password;
  String showPassword;
  String address;
  String salesmanId;
  String area;
  String city;
  String state;
  String pincode;
  String kycStatus;
  String kycApprove;
  String remarks;
  String isActive;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    companyName: json["Company_name"],
    salesmanId: json["salesmanID_assign"],
    customerId: json["customer_id"],
    customerName: json["Customer_name"],
    email: json["Email"],
    mobileNo: json["Mobile_no"],
    userName: json["User_name"],
    password: json["Password"],
    showPassword: json["show_password"],
    address: json["address"],
    area: json["area"],
    city: json["City"],
    state: json["State"],
    pincode: json["Pincode"],
    kycStatus: json["kyc_status"],
    kycApprove: json["kyc_approve"],
    remarks: json["remarks"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "Company_name": companyName,
    "customer_id": customerId,
    "Customer_name": customerName,
    "Email": email,
    "Mobile_no": mobileNo,
    "User_name": userName,
    "Password": password,
    "show_password": showPassword,
    "address": address,
    "area": area,
    "City": city,
    "State": state,
    "Pincode": pincode,
    "kyc_status": kycStatus,
    "kyc_approve": kycApprove,
    "remarks": remarks,
    "is_active": isActive,
    "salesmanID_assign": salesmanId
  };
}
