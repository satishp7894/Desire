class VerifyGSTModel {
  bool status;
  String message;
  Data data;

  VerifyGSTModel({this.status, this.message, this.data});

  VerifyGSTModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String gstNumber;
  String legalName;
  String buildingName;
  String doorNumber;
  String floorNbr;
  String location;
  String street;
  String pincode;
  String stateName;
  String taxpayerType;
  String natureOfBusinessActivity;
  String natureOfAdditionalPlaceOfBusiness;
  String gstnStatus;
  String responseStatusCode;
  String responseStatusStatus;
  String dateOfRegistration;

  Data(
      {this.gstNumber,
        this.legalName,
        this.buildingName,
        this.doorNumber,
        this.floorNbr,
        this.location,
        this.street,
        this.pincode,
        this.stateName,
        this.taxpayerType,
        this.natureOfBusinessActivity,
        this.natureOfAdditionalPlaceOfBusiness,
        this.gstnStatus,
        this.responseStatusCode,
        this.responseStatusStatus,
        this.dateOfRegistration});

  Data.fromJson(Map<String, dynamic> json) {
    gstNumber = json['gst_number'];
    legalName = json['legal_name'];
    buildingName = json['building_name'];
    doorNumber = json['door_number'];
    floorNbr = json['floor_nbr'];
    location = json['location'];
    street = json['street'];
    pincode = json['pincode'];
    stateName = json['state_name'];
    taxpayerType = json['taxpayer_type'];
    natureOfBusinessActivity = json['nature_of_business_activity'];
    natureOfAdditionalPlaceOfBusiness =
    json['nature_of_additional_place_of_business'];
    gstnStatus = json['gstn_status'];
    responseStatusCode = json['response_status_code'];
    responseStatusStatus = json['response_status_status'];
    dateOfRegistration = json['date_of_registration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gst_number'] = this.gstNumber;
    data['legal_name'] = this.legalName;
    data['building_name'] = this.buildingName;
    data['door_number'] = this.doorNumber;
    data['floor_nbr'] = this.floorNbr;
    data['location'] = this.location;
    data['street'] = this.street;
    data['pincode'] = this.pincode;
    data['state_name'] = this.stateName;
    data['taxpayer_type'] = this.taxpayerType;
    data['nature_of_business_activity'] = this.natureOfBusinessActivity;
    data['nature_of_additional_place_of_business'] =
        this.natureOfAdditionalPlaceOfBusiness;
    data['gstn_status'] = this.gstnStatus;
    data['response_status_code'] = this.responseStatusCode;
    data['response_status_status'] = this.responseStatusStatus;
    data['date_of_registration'] = this.dateOfRegistration;
    return data;
  }
}