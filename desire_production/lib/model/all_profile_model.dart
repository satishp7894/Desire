class AllProfileModel {
  bool status;
  String message;
  List<AllProfile> data;

  AllProfileModel({this.status, this.message, this.data});

  AllProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<AllProfile>();
      json['data'].forEach((v) {
        data.add(new AllProfile.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllProfile {
  String profileNoId;
  String profileNo;

  AllProfile({this.profileNoId, this.profileNo});

  AllProfile.fromJson(Map<String, dynamic> json) {
    profileNoId = json['profile_no_id'];
    profileNo = json['profile_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_no_id'] = this.profileNoId;
    data['profile_no'] = this.profileNo;
    return data;
  }
}