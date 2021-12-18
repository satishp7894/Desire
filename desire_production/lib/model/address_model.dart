class AddressModel {
  AddressModel({
    this.status,
    this.data,
    this.message,
  });

  bool status;
  List<Datum> data;
  String message;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    status: json["status"],
    data: json["data"] == "null" ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  Datum({
    this.addressId,
    this.customerId,
    this.name,
    this.address,
    this.locality,
    this.landmark,
    this.city,
    this.district,
    this.pincode,
    this.state,
    this.addressType,
    this.mobileNo,
    this.altMobileNo,
    this.addressAddDate,
    this.addressUpdateDate,
    this.addressStatus,
  });

  String addressId;
  String customerId;
  String name;
  String address;
  String locality;
  String landmark;
  String city;
  String district;
  String pincode;
  String state;
  String addressType;
  String mobileNo;
  String altMobileNo;
  String addressAddDate;
  String addressUpdateDate;
  String addressStatus;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    addressId: json["address_id"],
    customerId: json["customer_id"],
    name: json["name"],
    address: json["address"],
    locality: json["locality"],
    landmark: json["landmark"],
    city: json["city"],
    district: json["district"],
    pincode: json["pincode"],
    state: json["state"],
    addressType: json["address_type"],
    mobileNo: json["mobile_no"],
    altMobileNo: json["alt_mobile_no"],
    addressAddDate: json["address_add_date"],
    addressUpdateDate: json["address_update_date"],
    addressStatus: json["address_status"],
  );

  Map<String, dynamic> toJson() => {
    "address_id": addressId,
    "customer_id": customerId,
    "name": name,
    "address": address,
    "locality": locality,
    "landmark": landmark,
    "city": city,
    "district": district,
    "pincode": pincode,
    "state": state,
    "address_type": addressType,
    "mobile_no": mobileNo,
    "alt_mobile_no": altMobileNo,
    "address_add_date": addressAddDate,
    "address_update_date": addressUpdateDate,
    "address_status": addressStatus,
  };
}
