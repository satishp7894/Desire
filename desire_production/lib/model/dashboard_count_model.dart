class DashboardCountModel {
  DashboardCountModel({
    this.status,
    this.count,
    this.message,
  });

  bool status;
  Count count;
  String message;

  factory DashboardCountModel.fromJson(Map<String, dynamic> json) => DashboardCountModel(
    status: json["status"],
    count: Count.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "count": count.toJson(),
    "message": message,
  };
}

class Count {
  Count({
    this.order,
    this.dailyproduction,
    this.productionplanning,
  });

  List<Dailyproduction> order;
  List<Dailyproduction> dailyproduction;
  List<Dailyproduction> productionplanning;

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    order: List<Dailyproduction>.from(json["order"].map((x) => Dailyproduction.fromJson(x))),
    dailyproduction: List<Dailyproduction>.from(json["dailyproduction"].map((x) => Dailyproduction.fromJson(x))),
    productionplanning: List<Dailyproduction>.from(json["productionplanning"].map((x) => Dailyproduction.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "order": List<dynamic>.from(order.map((x) => x.toJson())),
    "dailyproduction": List<dynamic>.from(dailyproduction.map((x) => x.toJson())),
    "productionplanning": List<dynamic>.from(productionplanning.map((x) => x.toJson())),
  };
}

class Dailyproduction {
  Dailyproduction({
    this.cnt,
  });

  String cnt;

  factory Dailyproduction.fromJson(Map<String, dynamic> json) => Dailyproduction(
    cnt: json["cnt"],
  );

  Map<String, dynamic> toJson() => {
    "cnt": cnt,
  };
}
