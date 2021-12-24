class ProductionUserProfileModelListModel {
  ProductionUserProfileModelListModel(
      {this.status, this.data, this.message, this.imageUrl});

  bool status;
  List<ProductionUserProfileModel> data;
  String message;
  String imageUrl;

  factory ProductionUserProfileModelListModel.fromJson(
          Map<String, dynamic> json) =>
      ProductionUserProfileModelListModel(
        status: json["status"],
        data: List<ProductionUserProfileModel>.from(
            json["data"].map((x) => ProductionUserProfileModel.fromJson(x))),
        message: json["message"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "image_url": imageUrl
      };
}

class ProductionUserProfileModel {
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
  String logindate;
  String logoutdate;
  String priceList;
  String createdBy;
  String modifiedBy;
  String created;
  String modified;
  String isActive;

  ProductionUserProfileModel(
      {this.userId,
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
      this.priceList,
      this.createdBy,
      this.modifiedBy,
      this.created,
      this.modified,
      this.isActive});

  ProductionUserProfileModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    roleId = json['role_id'];
    departmentId = json['department_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    gender = json['gender'];
    userMobile = json['user_mobile'];
    userPhoto = json['user_photo'];
    pincode = json['pincode'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    logindate = json['logindate'];
    logoutdate = json['logoutdate'];
    priceList = json['price_list'];
    createdBy = json['created_by'];
    modifiedBy = json['modified_by'];
    created = json['created'];
    modified = json['modified'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['role_id'] = this.roleId;
    data['department_id'] = this.departmentId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['user_mobile'] = this.userMobile;
    data['user_photo'] = this.userPhoto;
    data['pincode'] = this.pincode;
    data['state'] = this.state;
    data['city'] = this.city;
    data['address'] = this.address;
    data['logindate'] = this.logindate;
    data['logoutdate'] = this.logoutdate;
    data['price_list'] = this.priceList;
    data['created_by'] = this.createdBy;
    data['modified_by'] = this.modifiedBy;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['is_active'] = this.isActive;
    return data;
  }
}
