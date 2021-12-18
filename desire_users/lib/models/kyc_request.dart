
import 'dart:convert';

String requestModelToJson(RequestModel data) => json.encode(data.toJson());

class RequestModel {
  RequestModel({
    this.data,
  });

  List<DatumRequest> data;

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class DatumRequest {
  DatumRequest({
    this.kycId,
    this.kycNumber,
    this.kycPhoto,
    this.userId,
  });

  String kycId;
  String kycNumber;
  var kycPhoto;
  String userId;

  Map<String, dynamic> toJson() => {
    "kyc_id": kycId,
    "kyc_number": kycNumber,
    "kyc_photo": kycPhoto,
    "user_id": userId,
  };
}
