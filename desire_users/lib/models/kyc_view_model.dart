class KycViewModel {
  KycViewModel({
    this.status,
    this.data,
    this.message,
  });

  bool status;
  List<Datum> data;
  String message;

  factory KycViewModel.fromJson(Map<String, dynamic> json) => KycViewModel(
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
    this.customerKycId,
    this.kycId,
    this.userId,
    this.number,
    this.photo,
    this.approveRejectStatus,
    this.createdAt,
    this.updatedAt,
  });

  String customerKycId;
  String kycId;
  String userId;
  String number;
  String photo;
  String approveRejectStatus;
  DateTime createdAt;
  dynamic updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    customerKycId: json["customer_kyc_id"],
    kycId: json["kyc_id"],
    userId: json["user_id"],
    number: json["number"],
    photo: json["photo"],
    approveRejectStatus: json["approve_reject_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "customer_kyc_id": customerKycId,
    "kyc_id": kycId,
    "user_id": userId,
    "number": number,
    "photo": photo,
    "approve_reject_status": approveRejectStatus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
  };
}
