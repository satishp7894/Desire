class SalesModel {
  SalesModel({
    this.status,
    this.sales,
    this.message,
  });

  bool status;
  List<Sale> sales;
  String message;

  factory SalesModel.fromJson(Map<String, dynamic> json) => SalesModel(
    status: json["status"],
    sales: json["data"] == "null" ? null : List<Sale>.from(json["data"].map((x) => Sale.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "sales": List<dynamic>.from(sales.map((x) => x.toJson())),
    "message": message,
  };
}

class Sale {
  Sale({
    this.userId,
    this.roleId,
    this.departmentId,
    this.firstname,
    this.lastname,
    this.email,
    this.username,
    this.password,
    this.gender,
    this.userMobile,
    this.userPhoto,
    this.pincode,
    this.state,
    this.city,
    this.address,
    this.logindate,
    this.logoutdate,
    this.createdBy,
    this.modifiedBy,
    this.created,
    this.modified,
    this.isActive,
  });

  String userId;
  String roleId;
  String departmentId;
  String firstname;
  String lastname;
  String email;
  String username;
  String password;
  String gender;
  String userMobile;
  String userPhoto;
  String pincode;
  String state;
  String city;
  String address;
  DateTime logindate;
  DateTime logoutdate;
  String createdBy;
  String modifiedBy;
  DateTime created;
  DateTime modified;
  String isActive;

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
    userId: json["user_id"],
    roleId: json["role_id"],
    departmentId: json["department_id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    username: json["username"],
    password: json["password"],
    gender: json["gender"],
    userMobile: json["user_mobile"],
    userPhoto: json["user_photo"],
    pincode: json["pincode"],
    state: json["state"],
    city: json["city"],
    address: json["address"],
    logindate: DateTime.parse(json["logindate"]),
    logoutdate: DateTime.parse(json["logoutdate"]),
    createdBy: json["created_by"],
    modifiedBy: json["modified_by"],
    created: DateTime.parse(json["created"]),
    modified: DateTime.parse(json["modified"]),
    isActive: json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "role_id": roleId,
    "department_id": departmentId,
    "firstname": firstname,
    "lastname": lastname,
    "email": email,
    "username": username,
    "password": password,
    "gender": gender,
    "user_mobile": userMobile,
    "user_photo": userPhoto,
    "pincode": pincode,
    "state": state,
    "city": city,
    "address": address,
    "logindate": logindate.toIso8601String(),
    "logoutdate": logoutdate.toIso8601String(),
    "created_by": createdBy,
    "modified_by": modifiedBy,
    "created": created.toIso8601String(),
    "modified": modified.toIso8601String(),
    "is_active": isActive,
  };
}
