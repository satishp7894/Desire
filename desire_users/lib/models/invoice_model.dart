class InvoiceModel {
  bool status;
  String message;
  String invoiceUrl;
  List<CustomerInvoice> customerInvoice;

  InvoiceModel(
      {this.status, this.message, this.invoiceUrl, this.customerInvoice});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    invoiceUrl = json['invoiceUrl'];
    if (json['customerInvoice'] != null) {
      customerInvoice = new List<CustomerInvoice>();
      json['customerInvoice'].forEach((v) {
        customerInvoice.add(new CustomerInvoice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['invoiceUrl'] = this.invoiceUrl;
    if (this.customerInvoice != null) {
      data['customerInvoice'] =
          this.customerInvoice.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerInvoice {
  String invoiceId;
  String orderId;
  String invoiceNumber;
  String invoiceDate;
  String invoiceFile;

  CustomerInvoice(
      {this.invoiceId,
        this.orderId,
        this.invoiceNumber,
        this.invoiceDate,
        this.invoiceFile});

  CustomerInvoice.fromJson(Map<String, dynamic> json) {
    invoiceId = json['invoice_id'];
    orderId = json['order_id'];
    invoiceNumber = json['invoice_number'];
    invoiceDate = json['invoice_date'];
    invoiceFile = json['invoice_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoice_id'] = this.invoiceId;
    data['order_id'] = this.orderId;
    data['invoice_number'] = this.invoiceNumber;
    data['invoice_date'] = this.invoiceDate;
    data['invoice_file'] = this.invoiceFile;
    return data;
  }
}
