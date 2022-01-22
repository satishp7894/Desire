class UserListModel {
  bool status;
  String message;
  List<UserList> userList;

  UserListModel({this.status, this.message, this.userList});

  UserListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['userList'] != null) {
      userList = new List<UserList>();
      json['userList'].forEach((v) {
        userList.add(new UserList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.userList != null) {
      data['userList'] = this.userList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserList {
  String userId;
  String roleId;
  String roleName;
  String firstname;
  String lastname;
  String email;
  String username;
  String password;
  String userMobile;
  String userPhoto;
  String pincode;
  String state;
  String city;
  String address;
  String isActive;

  UserList(
      {this.userId,
        this.roleId,
        this.roleName,
        this.firstname,
        this.lastname,
        this.email,
        this.username,
        this.password,
        this.userMobile,
        this.userPhoto,
        this.pincode,
        this.state,
        this.city,
        this.address,
        this.isActive});

  UserList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    roleId = json['role_id'];
    roleName = json['role_name'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    userMobile = json['user_mobile'];
    userPhoto = json['user_photo'];
    pincode = json['pincode'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['role_id'] = this.roleId;
    data['role_name'] = this.roleName;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['user_mobile'] = this.userMobile;
    data['user_photo'] = this.userPhoto;
    data['pincode'] = this.pincode;
    data['state'] = this.state;
    data['city'] = this.city;
    data['address'] = this.address;
    data['is_active'] = this.isActive;
    return data;
  }
}