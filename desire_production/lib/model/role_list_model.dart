class RoleListModel {
  bool status;
  String message;
  List<RoleList> roleList;

  RoleListModel({this.status, this.message, this.roleList});

  RoleListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['roleList'] != null) {
      roleList = new List<RoleList>();
      json['roleList'].forEach((v) {
        roleList.add(new RoleList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.roleList != null) {
      data['roleList'] = this.roleList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoleList {
  String roleId;
  String roleName;
  String roleDescription;
  String createdBy;
  String updatedBy;
  String createAt;
  String updateAt;
  String isActive;

  RoleList(
      {this.roleId,
      this.roleName,
      this.roleDescription,
      this.createdBy,
      this.updatedBy,
      this.createAt,
      this.updateAt,
      this.isActive});

  RoleList.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'];
    roleName = json['role_name'];
    roleDescription = json['role_description'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_id'] = this.roleId;
    data['role_name'] = this.roleName;
    data['role_description'] = this.roleDescription;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    data['is_active'] = this.isActive;
    return data;
  }
}