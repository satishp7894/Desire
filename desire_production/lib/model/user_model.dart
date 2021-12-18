class UserModel {
  UserModel({
    this.status,
    this.user,
    this.message,
  });

  bool status;
  List<User> user;
  String message;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    status: json["status"],
    user: List<User>.from(json["data"].map((x) => User.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(user.map((x) => x.toJson())),
    "message": message,
  };
}

class User {
  User({
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
  dynamic userMobile;
  dynamic userPhoto;
  dynamic pincode;
  dynamic state;
  dynamic city;
  dynamic address;
  String isActive;

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["user_id"],
    roleId: json["role_id"],
    departmentId: json["department_id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    email: json["email"],
    username: json["username"],
    password: json["password"],
    gender: json["gender"],
    userMobile: json["user_mobile"] == null ? "" : json["user_mobile"],
    userPhoto: json["user_photo"] == null ? "" : json["user_photo"],
    pincode: json["pincode"] == null ? "" : json["pincode"],
    state: json["state"] == null ? "" : json["state"],
    city: json["city"] == null ? "" : json["city"],
    address: json["address"] == null ? "" : json["address"],
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
    "is_active": isActive,
  };
}
