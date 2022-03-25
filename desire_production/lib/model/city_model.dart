class CityModel {
  bool status;
  String message;
  List<CityData> cityData;

  CityModel({this.status, this.message, this.cityData});

  CityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['cityData'] != null) {
      cityData = <CityData>[];
      json['cityData'].forEach((v) {
        cityData.add(new CityData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.cityData != null) {
      data['cityData'] = this.cityData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityData {
  String cityId;
  String cityName;
  String stateId;
  bool isCheck = false;

  CityData({this.cityId, this.cityName, this.stateId});

  CityData.fromJson(Map<String, dynamic> json) {
    cityId = json['city_id'];
    cityName = json['city_name'];
    stateId = json['state_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['state_id'] = this.stateId;
    return data;
  }
}