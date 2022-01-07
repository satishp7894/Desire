class InvoiceDetailModel {
  bool status;
  String message;
  List<InvoiceProducts> invoiceProducts;

  InvoiceDetailModel({this.status, this.message, this.invoiceProducts});

  InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['invoiceProducts'] != null) {
      invoiceProducts = new List<InvoiceProducts>();
      json['invoiceProducts'].forEach((v) {
        invoiceProducts.add(new InvoiceProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.invoiceProducts != null) {
      data['invoiceProducts'] =
          this.invoiceProducts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InvoiceProducts {
  String dispatchInvoiceId;
  String orderId;
  String customerId;
  String orderdetailId;
  String productId;
  String productName;
  String modelNoId;
  String productQuantity;

  InvoiceProducts(
      {this.dispatchInvoiceId,
      this.orderId,
      this.customerId,
      this.orderdetailId,
      this.productId,
      this.productName,
      this.modelNoId,
      this.productQuantity});

  InvoiceProducts.fromJson(Map<String, dynamic> json) {
    dispatchInvoiceId = json['dispatch_invoice_id'];
    orderId = json['order_id'];
    customerId = json['customer_id'];
    orderdetailId = json['orderdetail_id'];
    productId = json['product_id'];
    productName = json['product_name'];
    modelNoId = json['model_no_id'];
    productQuantity = json['product_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dispatch_invoice_id'] = this.dispatchInvoiceId;
    data['order_id'] = this.orderId;
    data['customer_id'] = this.customerId;
    data['orderdetail_id'] = this.orderdetailId;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['model_no_id'] = this.modelNoId;
    data['product_quantity'] = this.productQuantity;
    return data;
  }
}