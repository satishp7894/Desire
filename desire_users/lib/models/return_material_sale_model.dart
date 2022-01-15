class ReturnMaterialSaleModel {
  bool status;
  String message;
  List<ReturnMaterialList> returnMaterialList;

  ReturnMaterialSaleModel({this.status, this.message, this.returnMaterialList});

  ReturnMaterialSaleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['returnMaterialList'] != null) {
      returnMaterialList = new List<ReturnMaterialList>();
      json['returnMaterialList'].forEach((v) {
        returnMaterialList.add(new ReturnMaterialList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.returnMaterialList != null) {
      data['returnMaterialList'] =
          this.returnMaterialList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReturnMaterialList {
  String returnMaterialId;
  String customerId;
  String customerName;
  String dispatchInvoiceId;
  String invoiceNumber;
  String returnDate;

  ReturnMaterialList(
      {this.returnMaterialId,
        this.customerId,
        this.customerName,
        this.dispatchInvoiceId,
        this.invoiceNumber,
        this.returnDate});

  ReturnMaterialList.fromJson(Map<String, dynamic> json) {
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