class CustomerComplaintListModel {
  bool status;
  String message;
  List<ComplaintList> complaintList;

  CustomerComplaintListModel({this.status, this.message, this.complaintList});

  CustomerComplaintListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['complaintList'] != null) {
      complaintList = <ComplaintList>[];
      json['complaintList'].forEach((v) {
        complaintList.add(new ComplaintList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.complaintList != null) {
      data['complaintList'] = this.complaintList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ComplaintList {
  String customerId;
  String customerName;
  String customerComplaintId;
  String dispatchInvoiceId;
  String invoiceNumber;
  String complaintDate;


  ComplaintList(
      {this.customerId,
        this.customerName,this.customerComplaintId, this.complaintDate, this.dispatchInvoiceId, this.invoiceNumber
      });

  ComplaintList.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    customerComplaintId = json['customer_complaint_id'];
    dispatchInvoiceId = json['dispatch_invoice_id'];
    invoiceNumber = json['invoice_number'];
    complaintDate = json['complaint_date'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['customer_complaint_id'] = this.customerComplaintId;
    data['dispatch_invoice_id'] = this.dispatchInvoiceId;
    data['invoice_number'] = this.invoiceNumber;
    data['complaint_date'] = this.complaintDate;
    return data;
  }
}
