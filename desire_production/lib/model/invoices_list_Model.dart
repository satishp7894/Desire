class InvoiceInfo {
  String dispatchInvoiceId;
  String clientInvoiceNumber;
  String invoiceNumber;
  String invoiceDate;
  String invoiceFile;
  String customerName;

  InvoiceInfo(
      {this.dispatchInvoiceId,
      this.clientInvoiceNumber,
      this.invoiceNumber,
      this.invoiceDate,
      this.invoiceFile,
      this.customerName});

  InvoiceInfo.fromJson(Map<String, dynamic> json) {
    dispatchInvoiceId = json['dispatch_invoice_id'];
    clientInvoiceNumber = json['client_invoice_number'];
    invoiceNumber = json['invoice_number'];
    invoiceDate = json['invoice_date'];
    invoiceFile = json['invoice_file'];
    customerName = json['Customer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dispatch_invoice_id'] = this.dispatchInvoiceId;
    data['client_invoice_number'] = this.clientInvoiceNumber;
    data['invoice_number'] = this.invoiceNumber;
    data['invoice_date'] = this.invoiceDate;
    data['invoice_file'] = this.invoiceFile;
    data['Customer_name'] = this.customerName;
    return data;
  }
}

class InvoicesListModel {
  bool status;
  String message;
  List<InvoiceInfo> data;
  String invoicePDFPath;

  InvoicesListModel(
      {this.status, this.message, this.data, this.invoicePDFPath}) {}

  InvoicesListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    invoicePDFPath = json['invoice_pdf_path'];
    if (json['data'] != null) {
      data = <InvoiceInfo>[];
      json['data'].forEach((v) {
        data.add(new InvoiceInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['readyStockList'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
