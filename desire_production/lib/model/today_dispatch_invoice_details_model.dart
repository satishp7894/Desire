class TodayDispatchInvoiceDetailsModel {
  bool status;
  String message;
  List<TodayDispatchInvoice> todayDispatchInvoice;

  TodayDispatchInvoiceDetailsModel(
      {this.status, this.message, this.todayDispatchInvoice});

  TodayDispatchInvoiceDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    if (this.todayDispatchInvoice != null) {
      data['todayDispatchInvoice'] =
          this.todayDispatchInvoice.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TodayDispatchInvoice {
  String dispatchInvoiceId;
  String customerId;
  String customerName;
  String clientInvoiceNumber;
  String invoiceNumber;
  Null invoiceAmount;

  TodayDispatchInvoice(
      {this.dispatchInvoiceId,
      this.customerId,
      this.customerName,
      this.clientInvoiceNumber,
      this.invoiceNumber,
      this.invoiceAmount});

  TodayDispatchInvoice.fromJson(Map<String, dynamic> json) {
    dispatchInvoiceId = json['dispatch_invoice_id'];
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    clientInvoiceNumber = json['client_invoice_number'];
    invoiceNumber = json['invoice_number'];
    invoiceAmount = json['invoice_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dispatch_invoice_id'] = this.dispatchInvoiceId;
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['client_invoice_number'] = this.clientInvoiceNumber;
    data['invoice_number'] = this.invoiceNumber;
    data['invoice_amount'] = this.invoiceAmount;
    return data;
  }
}
