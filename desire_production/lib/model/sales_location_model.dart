class SalesLocationModel {
  bool status;
  String message;
  List<SalesmanLocation> salesmanLocation;

  SalesLocationModel({this.status, this.message, this.salesmanLocation});

  SalesLocationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['salesmanLocation'] != null) {
      salesmanLocation = new List<SalesmanLocation>();
      json['salesmanLocation'].forEach((v) {
        salesmanLocation.add(new SalesmanLocation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.salesmanLocation != null) {
      data['salesmanLocation'] =
          this.salesmanLocation.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesmanLocation {
  String locationId;
  String userId;
  String locationDatetime;
  String latitude;
  String longitude;

  SalesmanLocation(
      {this.locationId,
        this.userId,
        this.locationDatetime,
        this.latitude,
        this.longitude});

  SalesmanLocation.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    userId = json['user_id'];
    locationDatetime = json['location_datetime'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = this.locationId;
    data['user_id'] = this.userId;
    data['location_datetime'] = this.locationDatetime;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}