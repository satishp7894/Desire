class OrderDetailsByIdModel {
  bool status;
  String message;
  String imagepath;
  String orderNumber;
  String orderQuantity;
  String orderAmount;
  String orderDate;
  List<Data> data;
  List<Address> address;

  OrderDetailsByIdModel(
      {this.status,
        this.message,
        this.imagepath,
        this.orderNumber,
        this.orderQuantity,
        this.orderAmount,
        this.orderDate,
        this.data,
        this.address});

  OrderDetailsByIdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    imagepath = json['imagepath'];
    orderNumber = json['orderNumber'];
    orderQuantity = json['orderQuantity'];
    orderAmount = json['orderAmount'];
    orderDate = json['orderDate'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    if (json['address'] != null) {
      address = new List<Address>();
      json['address'].forEach((v) {
        address.add(new Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['imagepath'] = this.imagepath;
    data['orderNumber'] = this.orderNumber;
    data['orderQuantity'] = this.orderQuantity;
    data['orderAmount'] = this.orderAmount;
    data['orderDate'] = this.orderDate;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.address != null) {
      data['address'] = this.address.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String orderdetailId;
  String approxDate;
  String orderTrackingDetails;
  String productId;
  String productName;
  String profileNo;
  String modelNo;
  String size;
  String image;
  String productQuantity;
  String mrpPrice;
  String netRate;
  String totalAmount;
  String bill;

  Data(
      {this.orderdetailId,
        this.approxDate,
        this.orderTrackingDetails,
        this.productId,
        this.productName,
        this.profileNo,
        this.modelNo,
        this.size,
        this.image,
        this.productQuantity,
        this.mrpPrice,
        this.netRate,
        this.totalAmount,
        this.bill});

  Data.fromJson(Map<String, dynamic> json) {
    orderdetailId = json['orderdetail_id'];
    approxDate = json['approxDate'];
    orderTrackingDetails = json['order_tracking_details'];
    productId = json['product_id'];
    productName = json['product_name'];
    profileNo = json['profile_no'];
    modelNo = json['model_no'];
    size = json['size'];
    image = json['image'];
    productQuantity = json['product_quantity'];
    mrpPrice = json['mrp_price'];
    netRate = json['net_rate'];
    totalAmount = json['total_amount'];
    bill = json['bill'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderdetail_id'] = this.orderdetailId;
    data['approxDate'] = this.approxDate;
    data['order_tracking_details'] = this.orderTrackingDetails;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['profile_no'] = this.profileNo;
    data['model_no'] = this.modelNo;
    data['size'] = this.size;
    data['image'] = this.image;
    data['product_quantity'] = this.productQuantity;
    data['mrp_price'] = this.mrpPrice;
    data['net_rate'] = this.netRate;
    data['total_amount'] = this.totalAmount;
    data['bill'] = this.bill;
    return data;
  }
}

class Address {
  String addressId;
  String customerId;
  String name;
  String address;
  String locality;
  String landmark;
  String area;
  String city;
  String district;
  String pincode;
  String state;
  String addressType;
  String mobileNo;
  String altMobileNo;
  String addressAddDate;
  String addressUpdateDate;
  String addressStatus;

  Address(
      {this.addressId,
        this.customerId,
        this.name,
        this.address,
        this.locality,
        this.landmark,
        this.area,
        this.city,
        this.district,
        this.pincode,
        this.state,
        this.addressType,
        this.mobileNo,
        this.altMobileNo,
        this.addressAddDate,
        this.addressUpdateDate,
        this.addressStatus});

  Address.fromJson(Map<String, dynamic> json) {
    addressId = json['address_id'];
    customerId = json['customer_id'];
    name = json['name'];
    address = json['address'];
    locality = json['locality'];
    landmark = json['landmark'];
    area = json['area'];
    city = json['city'];
    district = json['district'];
    pincode = json['pincode'];
    state = json['state'];
    addressType = json['address_type'];
    mobileNo = json['mobile_no'];
    altMobileNo = json['alt_mobile_no'];
    addressAddDate = json['address_add_date'];
    addressUpdateDate = json['address_update_date'];
    addressStatus = json['address_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_id'] = this.addressId;
    data['customer_id'] = this.customerId;
    data['name'] = this.name;
    data['address'] = this.address;
    data['locality'] = this.locality;
    data['landmark'] = this.landmark;
    data['area'] = this.area;
    data['city'] = this.city;
    data['district'] = this.district;
    data['pincode'] = this.pincode;
    data['state'] = this.state;
    data['address_type'] = this.addressType;
    data['mobile_no'] = this.mobileNo;
    data['alt_mobile_no'] = this.altMobileNo;
    data['address_add_date'] = this.addressAddDate;
    data['address_update_date'] = this.addressUpdateDate;
    data['address_status'] = this.addressStatus;
    return data;
  }
}
