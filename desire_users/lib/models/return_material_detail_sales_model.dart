class ReturnMaterialDetailSalesModel {
  bool status;
  String message;
  List<ReturnMaterialDetails> returnMaterialDetails;
  List<ReturnMaterialProductDetails> returnMaterialProductDetails;

  ReturnMaterialDetailSalesModel(
      {this.status,
        this.message,
        this.returnMaterialDetails,
        this.returnMaterialProductDetails});

  ReturnMaterialDetailSalesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['returnMaterialDetails'] != null) {
      returnMaterialDetails = new List<ReturnMaterialDetails>();
      json['returnMaterialDetails'].forEach((v) {
        returnMaterialDetails.add(new ReturnMaterialDetails.fromJson(v));
      });
    }
    if (json['returnMaterialProductDetails'] != null) {
      returnMaterialProductDetails = new List<ReturnMaterialProductDetails>();
      json['returnMaterialProductDetails'].forEach((v) {
        returnMaterialProductDetails
            .add(new ReturnMaterialProductDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.returnMaterialDetails != null) {
      data['returnMaterialDetails'] =
          this.returnMaterialDetails.map((v) => v.toJson()).toList();
    }
    if (this.returnMaterialProductDetails != null) {
      data['returnMaterialProductDetails'] =
          this.returnMaterialProductDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReturnMaterialDetails {
  String returnMaterialId;
  String customerId;
  String customerName;
  String dispatchInvoiceId;
  String invoiceNumber;
  String returnDate;

  ReturnMaterialDetails(
      {this.returnMaterialId,
        this.customerId,
        this.customerName,
        this.dispatchInvoiceId,
        this.invoiceNumber,
        this.returnDate});

  ReturnMaterialDetails.fromJson(Map<String, dynamic> json) {
    returnMaterialId = json['return_material_id'];
    customerId = json['customer_id'];
    customerName = json['Customer_name'];
    dispatchInvoiceId = json['dispatch_invoice_id'];
    invoiceNumber = json['invoice_number'];
    returnDate = json['return_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['return_material_id'] = this.returnMaterialId;
    data['customer_id'] = this.customerId;
    data['Customer_name'] = this.customerName;
    data['dispatch_invoice_id'] = this.dispatchInvoiceId;
    data['invoice_number'] = this.invoiceNumber;
    data['return_date'] = this.returnDate;
    return data;
  }
}

class ReturnMaterialProductDetails {
  String orderdetailId;
  String productId;
  String productName;
  String modelNoId;
  String returnQty;

  ReturnMaterialProductDetails(
      {this.orderdetailId,
        this.productId,
        this.productName,
        this.modelNoId,
        this.returnQty});

  ReturnMaterialProductDetails.fromJson(Map<String, dynamic> json) {
    orderdetailId = json['orderdetail_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    modelNoId = json['model_no_id'];
    returnQty = json['return_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderdetail_id'] = this.orderdetailId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['model_no_id'] = this.modelNoId;
    data['return_qty'] = this.returnQty;
    return data;
  }
}