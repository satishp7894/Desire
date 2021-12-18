class KycModel {
  KycModel({
    this.status,
    this.data,
    this.message,
  });

  bool status;
  List<Datum> data;
  String message;

  factory KycModel.fromJson(Map<String, dynamic> json) => KycModel(
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
    this.kycId,
    this.kycName,
    this.createdAt,
    this.updateAt,
    this.length
  });

  String kycId;
  String kycName;
  String length;
  DateTime createdAt;
  dynamic updateAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    kycId: json["kyc_id"],
    kycName: json["kyc_name"],
    createdAt: DateTime.parse(json["created_at"]),
    updateAt: json["update_at"],
    length: json["length"]
  );

  Map<String, dynamic> toJson() => {
    "kyc_id": kycId,
    "kyc_name": kycName,
    "created_at": createdAt.toIso8601String(),
    "update_at": updateAt,
    "length": length,
  };
}
