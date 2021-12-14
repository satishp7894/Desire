class TransportListModel {
  bool status;
  String message;
  List<CustomerTransport> customerTransport;

  TransportListModel({this.status, this.message, this.customerTransport});

  TransportListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['customerTransport'] != null) {
      customerTransport = new List<CustomerTransport>();
      json['customerTransport'].forEach((v) {
        customerTransport.add(new CustomerTransport.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.customerTransport != null) {
      data['customerTransport'] =
          this.customerTransport.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerTransport {
  String transportId;
  String customerId;
  String transportName;
  String mobileNo;
  String emailId;
  String gst;
  String address;
  String city;
  String pincode;
  String state;
  String createdBy;
  String modifiedBy;
  String created;
  String modified;
  String isActive;

  CustomerTransport(
      {this.transportId,
        this.customerId,
        this.transportName,
        this.mobileNo,
        this.emailId,
        this.gst,
        this.address,
        this.city,
        this.pincode,
        this.state,
        this.createdBy,
        this.modifiedBy,
        this.created,
        this.modified,
        this.isActive});

  CustomerTransport.fromJson(Map<String, dynamic> json) {
    transportId = json['transport_id'];
    customerId = json['customer_id'];
    transportName = json['transport_name'];
    mobileNo = json['mobile_no'];
    emailId = json['email_id'];
    gst = json['gst'];
    address = json['address'];
    city = json['city'];
    pincode = json['pincode'];
    state = json['state'];
    createdBy = json['created_by'];
    modifiedBy = json['modified_by'];
    created = json['created'];
    modified = json['modified'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transport_id'] = this.transportId;
    data['customer_id'] = this.customerId;
    data['transport_name'] = this.transportName;
    data['mobile_no'] = this.mobileNo;
    data['email_id'] = this.emailId;
    data['gst'] = this.gst;
    data['address'] = this.address;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['state'] = this.state;
    data['created_by'] = this.createdBy;
    data['modified_by'] = this.modifiedBy;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['is_active'] = this.isActive;
    return data;
  }
}
