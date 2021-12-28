class InvoiceDetail {
  bool status;
  String message;
  DataInvoice data;

  InvoiceDetail({this.status, this.message, this.data});

  InvoiceDetail.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new DataInvoice.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class DataInvoice {
  List<DispatchResult> dispatchResult;
  List<InvoiceResult> invoiceResult;
  List<OrderDetails> orderDetails;

  DataInvoice({this.dispatchResult, this.invoiceResult, this.orderDetails});

  DataInvoice.fromJson(Map<String, dynamic> json) {
    if (json['dispatch_result'] != null) {
      dispatchResult = new List<DispatchResult>();
      json['dispatch_result'].forEach((v) {
        dispatchResult.add(new DispatchResult.fromJson(v));
      });
    }
    if (json['invoice_result'] != null) {
      invoiceResult = new List<InvoiceResult>();
      json['invoice_result'].forEach((v) {
        invoiceResult.add(new InvoiceResult.fromJson(v));
      });
    }
    if (json['order_details'] != null) {
      orderDetails = new List<OrderDetails>();
      json['order_details'].forEach((v) {
        orderDetails.add(new OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dispatchResult != null) {
      data['dispatch_result'] =
          this.dispatchResult.map((v) => v.toJson()).toList();
    }
    if (this.invoiceResult != null) {
      data['invoice_result'] =
          this.invoiceResult.map((v) => v.toJson()).toList();
    }
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<Map<String, dynamic>> toPostJson() {
    return this
        .orderDetails
        .where((v) => v.isSelected)
        .map((v) => v.toPostJson())
        .toList();
  }
}

class DispatchResult {
  String dispatchId;
  String orderId;
  String customerId;
  String dispatchInvoiceId;
  String lrNumber;
  String lrNumberImage;
  String ewayBill;
  String ewayBillImage;
  String createdAt;

  DispatchResult(
      {this.dispatchId,
      this.orderId,
      this.customerId,
      this.dispatchInvoiceId,
      this.lrNumber,
      this.lrNumberImage,
      this.ewayBill,
      this.ewayBillImage,
      this.createdAt});

  DispatchResult.fromJson(Map<String, dynamic> json) {
    dispatchId = json['dispatch_id'];
    orderId = json['order_id'];
    customerId = json['customer_id'];
    dispatchInvoiceId = json['dispatch_invoice_id'];
    lrNumber = json['lr_number'];
    lrNumberImage = json['lr_number_image'];
    ewayBill = json['eway_bill'];
    ewayBillImage = json['eway_bill_image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dispatch_id'] = this.dispatchId;
    data['order_id'] = this.orderId;
    data['customer_id'] = this.customerId;
    data['dispatch_invoice_id'] = this.dispatchInvoiceId;
    data['lr_number'] = this.lrNumber;
    data['lr_number_image'] = this.lrNumberImage;
    data['eway_bill'] = this.ewayBill;
    data['eway_bill_image'] = this.ewayBillImage;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class InvoiceResult {
  String dispatchInvoiceId;
  String orderId;
  String customerId;
  String clientInvoiceNumber;
  String invoiceNumber;
  String invoiceNo;
  String invoiceAmount;
  String invoiceDate;
  String invoiceFile;
  String createdAt;

  InvoiceResult(
      {this.dispatchInvoiceId,
      this.orderId,
      this.customerId,
      this.clientInvoiceNumber,
      this.invoiceNumber,
      this.invoiceNo,
      this.invoiceAmount,
      this.invoiceDate,
      this.invoiceFile,
      this.createdAt});

  InvoiceResult.fromJson(Map<String, dynamic> json) {
    dispatchInvoiceId = json['dispatch_invoice_id'];
    orderId = json['order_id'];
    customerId = json['customer_id'];
    clientInvoiceNumber = json['client_invoice_number'];
    invoiceNumber = json['invoice_number'];
    invoiceNo = json['invoiceNo'];
    invoiceAmount = json['invoice_amount'];
    invoiceDate = json['invoice_date'];
    invoiceFile = json['invoice_file'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dispatch_invoice_id'] = this.dispatchInvoiceId;
    data['order_id'] = this.orderId;
    data['customer_id'] = this.customerId;
    data['client_invoice_number'] = this.clientInvoiceNumber;
    data['invoice_number'] = this.invoiceNumber;
    data['invoiceNo'] = this.invoiceNo;
    data['invoice_amount'] = this.invoiceAmount;
    data['invoice_date'] = this.invoiceDate;
    data['invoice_file'] = this.invoiceFile;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class OrderDetails {
  String orderdetailId;
  String orderId;
  String customerId;
  String customerName;
  String productId;
  String productName;
  String hsnSac;
  String productQuantity;
  String mrpPrice;
  String invoiceQty;
  String invoiceBoxPerStick;
  String invoicePrice;
  String invoiceTotalStick;
  String invoiceTotalPrice;
  String modelNo;
  String perBoxStick;
  String customerPrice;
  bool isSelected = false;

  OrderDetails(
      {this.orderdetailId,
      this.orderId,
      this.customerId,
      this.customerName,
      this.productId,
      this.productName,
      this.hsnSac,
      this.productQuantity,
      this.mrpPrice,
      this.invoiceQty,
      this.invoiceBoxPerStick,
      this.invoicePrice,
      this.invoiceTotalStick,
      this.invoiceTotalPrice,
      this.modelNo,
      this.perBoxStick,
      this.customerPrice});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    orderdetailId = json['orderdetail_id'];
    orderId = json['order_id'];
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    productId = json['product_id'];
    productName = json['product_name'];
    hsnSac = json['hsn_sac'];
    productQuantity = json['product_quantity'];
    mrpPrice = json['mrp_price'];
    invoiceQty = json['invoice_qty'];
    invoiceBoxPerStick = json['invoice_box_per_stick'];
    invoicePrice = json['invoice_price'];
    invoiceTotalStick = json['invoice_total_stick'];
    invoiceTotalPrice = json['invoice_total_price'];
    modelNo = json['model_no'];
    perBoxStick = json['per_box_stick'];
    customerPrice = json['customer_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderdetail_id'] = this.orderdetailId;
    data['order_id'] = this.orderId;
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['hsn_sac'] = this.hsnSac;
    data['product_quantity'] = this.productQuantity;
    data['mrp_price'] = this.mrpPrice;
    data['invoice_qty'] = this.invoiceQty;
    data['invoice_box_per_stick'] = this.invoiceBoxPerStick;
    data['invoice_price'] = this.invoicePrice;
    data['invoice_total_stick'] = this.invoiceTotalStick;
    data['invoice_total_price'] = this.invoiceTotalPrice;
    data['model_no'] = this.modelNo;
    data['per_box_stick'] = this.perBoxStick;
    data['customer_price'] = this.customerPrice;
    return data;
  }

  Map<String, dynamic> toPostJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderdetail_id'] = this.orderdetailId;
    data['total_stick'] = this.invoiceTotalStick;
    data['total_price'] = this.invoiceTotalPrice;
    return data;
  }
}
