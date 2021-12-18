// To parse this JSON data, do
//
//     final roleModel = roleModelFromJson(jsonString);

import 'dart:convert';

RoleModel roleModelFromJson(String str) => RoleModel.fromJson(json.decode(str));

String roleModelToJson(RoleModel data) => json.encode(data.toJson());

class RoleModel {
  RoleModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  List<Roles> data;

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
    status: json["status"],
    message: json["message"],
    data: List<Roles>.from(json["data"].map((x) => Roles.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Roles {
  Roles({
    this.roleId,
    this.roleName,
  });

  int roleId;
  String roleName;

  factory Roles.fromJson(Map<String, dynamic> json) => Roles(
    roleId: json["role_id"],
    roleName: json["role_name"],
  );

  Map<String, dynamic> toJson() => {
    "role_id": roleId,
    "role_name": roleName,
  };
}
