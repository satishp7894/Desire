class TodaysListModel {
  bool status;
  String message;
  List<TodayOrder> todayOrder;
  List<TodayDispatchInvoice> todayDispatchInvoice;

  TodaysListModel(
      {this.status, this.message, this.todayOrder, this.todayDispatchInvoice});

  TodaysListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['todayOrder'] != null) {
      todayOrder = new List<TodayOrder>();
      json['todayOrder'].forEach((v) {
        todayOrder.add(new TodayOrder.fromJson(v));
      });
    }
    if (json['todayDispatchInvoice'] != null) {
      todayDispatchInvoice = new List<TodayDispatchInvoice>();
      json['todayDispatchInvoice'].forEach((v) {
        todayDispatchInvoice.add(new TodayDispatchInvoice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.todayOrder != null) {
      data['todayOrder'] = this.todayOrder.map((v) => v.toJson()).toList();
    }
    if (this.todayDispatchInvoice != null) {
      data['todayDispatchInvoice'] =
          this.todayDispatchInvoice.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TodayOrder {
  String totalOrder;
  String totalOrderQty;
  String totalOrderAmount;

  TodayOrder({this.totalOrder, this.totalOrderQty, this.totalOrderAmount});

  TodayOrder.fromJson(Map<String, dynamic> json) {
    totalOrder = json['total_order'];
    totalOrderQty = json['total_order_qty'];
    totalOrderAmount = json['total_order_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_order'] = this.totalOrder;
    data['total_order_qty'] = this.totalOrderQty;
    data['total_order_amount'] = this.totalOrderAmount;
    return data;
  }
}

class TodayDispatchInvoice {
  String totalDispatchInvoice;
  Null totalDispatchInvoiceAmount;

  TodayDispatchInvoice(
      {this.totalDispatchInvoice, this.totalDispatchInvoiceAmount});

  TodayDispatchInvoice.fromJson(Map<String, dynamic> json) {
    totalDispatchInvoice = json['total_dispatch_invoice'];
    totalDispatchInvoiceAmount = json['total_dispatch_invoice_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_dispatch_invoice'] = this.totalDispatchInvoice;
    data['total_dispatch_invoice_amount'] = this.totalDispatchInvoiceAmount;
    return data;
  }
}
