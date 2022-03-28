class ProductionDashBoardModel {
  bool status;
  String message;
  int totalDailyOrder;
  int totalPendingOrder;
  int totalProductionOrder;

  ProductionDashBoardModel(
      {this.status,
        this.message,
        this.totalDailyOrder,
        this.totalPendingOrder,
        this.totalProductionOrder});

  ProductionDashBoardModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalDailyOrder = json['totalDailyOrder'];
    totalPendingOrder = json['totalPendingOrder'];
    totalProductionOrder = json['totalProductionOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['totalDailyOrder'] = this.totalDailyOrder;
    data['totalPendingOrder'] = this.totalPendingOrder;
    data['totalProductionOrder'] = this.totalProductionOrder;
    return data;
  }
}
