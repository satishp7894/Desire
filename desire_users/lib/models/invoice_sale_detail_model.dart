class InvoiceSaleDetailModel {
  bool status;
  String message;
  String invoiceUrl;
  List<CustomerInvoice> customerInvoice;

  InvoiceSaleDetailModel(
      {this.status, this.message, this.invoiceUrl, this.customerInvoice});

  InvoiceSaleDetailModel.fromJson(Map<String, dynamic> json) {
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
  String dispatchInvoiceId;
  String invoiceNumber;
  String invoiceAmount;
  String invoiceDate;
  String invoiceFile;
  String customerName;

  CustomerInvoice(
      {this.dispatchInvoiceId,
        this.invoiceNumber,
        this.invoiceAmount,
        this.invoiceDate,
        this.invoiceFile,
        this.customerName});

  CustomerInvoice.fromJson(Map<String, dynamic> json) {
    dispatchInvoiceId = json['dispatch_invoice_id'];
    invoiceNumber = json['invoice_number'];
    invoiceAmount = json['invoice_amount'];
    invoiceDate = json['invoice_date'];
    invoiceFile = json['invoice_file'];
    customerName = json['Customer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dispatch_invoice_id'] = this.dispatchInvoiceId;
    data['invoice_number'] = this.invoiceNumber;
    data['invoice_amount'] = this.invoiceAmount;
    data['invoice_date'] = this.invoiceDate;
    data['invoice_file'] = this.invoiceFile;
    data['Customer_name'] = this.customerName;
    return data;
  }
}