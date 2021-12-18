class RegionModel {
  RegionModel({
    this.message,
    this.status,
    this.postOffice,
  });

  String message;
  String status;
  List<PostOffice> postOffice;

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
    message: json["Message"],
    status: json["Status"],
    postOffice: List<PostOffice>.from(json["PostOffice"].map((x) => PostOffice.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Message": message,
    "Status": status,
    "PostOffice": List<dynamic>.from(postOffice.map((x) => x.toJson())),
  };
}

class PostOffice {
  PostOffice({
    this.name,
    this.description,
    this.branchType,
    this.deliveryStatus,
    this.circle,
    this.district,
    this.division,
    this.region,
    this.block,
    this.state,
    this.country,
    this.pincode,
  });

  String name;
  dynamic description;
  BranchType branchType;
  DeliveryStatus deliveryStatus;
  Circle circle;
  District district;
  District division;
  RegionEnum region;
  Block block;
  Circle state;
  Country country;
  String pincode;

  factory PostOffice.fromJson(Map<String, dynamic> json) => PostOffice(
    name: json["Name"],
    description: json["Description"],
    branchType: branchTypeValues.map[json["BranchType"]],
    deliveryStatus: deliveryStatusValues.map[json["DeliveryStatus"]],
    circle: circleValues.map[json["Circle"]],
    district: districtValues.map[json["District"]],
    division: districtValues.map[json["Division"]],
    region: regionEnumValues.map[json["Region"]],
    block: blockValues.map[json["Block"]],
    state: circleValues.map[json["State"]],
    country: countryValues.map[json["Country"]],
    pincode: json["Pincode"],
  );

  Map<String, dynamic> toJson() => {
    "Name": name,
    "Description": description,
    "BranchType": branchTypeValues.reverse[branchType],
    "DeliveryStatus": deliveryStatusValues.reverse[deliveryStatus],
    "Circle": circleValues.reverse[circle],
    "District": districtValues.reverse[district],
    "Division": districtValues.reverse[division],
    "Region": regionEnumValues.reverse[region],
    "Block": blockValues.reverse[block],
    "State": circleValues.reverse[state],
    "Country": countryValues.reverse[country],
    "Pincode": pincode,
  };
}

enum Block { PARDI, KAPRADA }

final blockValues = EnumValues({
  "Kaprada": Block.KAPRADA,
  "Pardi": Block.PARDI
});

enum BranchType { BRANCH_POST_OFFICE, SUB_POST_OFFICE }

final branchTypeValues = EnumValues({
  "Branch Post Office": BranchType.BRANCH_POST_OFFICE,
  "Sub Post Office": BranchType.SUB_POST_OFFICE
});

enum Circle { GUJARAT }

final circleValues = EnumValues({
  "Gujarat": Circle.GUJARAT
});

enum Country { INDIA }

final countryValues = EnumValues({
  "India": Country.INDIA
});

enum DeliveryStatus { DELIVERY }

final deliveryStatusValues = EnumValues({
  "Delivery": DeliveryStatus.DELIVERY
});

enum District { VALSAD }

final districtValues = EnumValues({
  "Valsad": District.VALSAD
});

enum RegionEnum { VADODARA }

final regionEnumValues = EnumValues({
  "Vadodara": RegionEnum.VADODARA
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
