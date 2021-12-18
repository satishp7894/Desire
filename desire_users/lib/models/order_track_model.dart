class OrderTrackModel {
  OrderTrackModel({
    this.status,
    this.data,
    this.message,
  });

  bool status;
  List<Datum> data;
  String message;

  factory OrderTrackModel.fromJson(Map<String, dynamic> json) => OrderTrackModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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
    this.message,
    this.trackTime
  });

  String message;
  String trackTime;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    message: json["message"],
    trackTime: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "time": trackTime,
  };

}
