class ComplaintDetailModel {
  bool status;
  String message;
  String complaint_photo_url;
  String complaint_video_url;
  List<ComplaintDetails> complaintDetails;

  ComplaintDetailModel({this.status, this.message, this.complaint_photo_url,this.complaint_video_url,this.complaintDetails});

  ComplaintDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    complaint_photo_url = json['complaint_photo_url'];
    complaint_video_url = json['complaint_video_url'];
    if (json['complaintDetails'] != null) {
      complaintDetails = <ComplaintDetails>[];
      json['complaintDetails'].forEach((v) {
        complaintDetails.add(new ComplaintDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['complaint_photo_url'] = this.complaint_photo_url;
    data['complaint_video_url'] = this.complaint_video_url;
    if (this.complaintDetails != null) {
      data['complaintList'] = this.complaintDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ComplaintDetails {
  String customerId;
  String customerName;
  String customerComplaintId;
  String dispatchInvoiceId;
  String invoiceNumber;
  String complaintDate;
  String description;
  String photo;
  String video;



  ComplaintDetails(
      {this.customerId,
        this.customerName,this.customerComplaintId,
        this.complaintDate, this.dispatchInvoiceId, this.invoiceNumber,
        this.description, this.photo, this.video
      });

  ComplaintDetails.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    customerComplaintId = json['customer_complaint_id'];
    dispatchInvoiceId = json['dispatch_invoice_id'];
    invoiceNumber = json['invoice_number'];
    complaintDate = json['complaint_date'];
    description = json['description'];
    photo = json['photo'];
    video = json['video'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['customer_complaint_id'] = this.customerComplaintId;
    data['dispatch_invoice_id'] = this.dispatchInvoiceId;
    data['invoice_number'] = this.invoiceNumber;
    data['complaint_date'] = this.complaintDate;
    data['description'] = this.description;
    data['photo'] = this.photo;
    data['video'] = this.video;
    return data;
  }
}
