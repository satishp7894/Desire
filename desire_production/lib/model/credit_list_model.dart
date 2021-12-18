class CreditListModel {
  CreditListModel({
    this.status,
    this.credit,
    this.message,
  });

  bool status;
  List<Credit> credit;
  String message;

  factory CreditListModel.fromJson(Map<String, dynamic> json) => CreditListModel(
    status: json["status"],
    credit: List<Credit>.from(json["data"].map((x) => Credit.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(credit.map((x) => x.toJson())),
    "message": message,
  };
}

class Credit {
  Credit({
    this.creditId,
    this.userId,
    this.creditAmount,
    this.creditDays,
    this.status,
    this.customerId,
    this.customerName,
    this.salesmanIdAssign,
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
    this.createdBy,
    this.modifiedBy,
    this.isActive,
  });

  String creditId;
  String userId;
  String creditAmount;
  String creditDays;
  String status;
  String customerId;
  String customerName;
  dynamic salesmanIdAssign;
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
  dynamic remarks;
  dynamic createdBy;
  dynamic modifiedBy;
  String isActive;

  factory Credit.fromJson(Map<String, dynamic> json) => Credit(
    creditId: json["credit_id"],
    userId: json["user_id"],
    creditAmount: json["credit_amount"],
    creditDays: json["credit_days"],
    status: json["status"],
    customerId: json["customer_id"],
    customerName: json["Customer_name"],
    salesmanIdAssign: json["salesmanID_assign"],
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
    createdBy: json["created_by"],
    modifiedBy: json["modified_by"],
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "credit_id": creditId,
    "user_id": userId,
    "credit_amount": creditAmount,
    "credit_days": creditDays,
    "status": status,
    "customer_id": customerId,
    "Customer_name": customerName,
    "salesmanID_assign": salesmanIdAssign,
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
    "created_by": createdBy,
    "modified_by": modifiedBy,
    "is_active": isActive,
  };
}
