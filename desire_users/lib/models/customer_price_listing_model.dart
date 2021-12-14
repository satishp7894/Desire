class CustomerPriceListModel {
  bool status;
  bool priceList;
  String message;
  List<Data> data;

  CustomerPriceListModel(
      {this.status, this.priceList, this.message, this.data});

  CustomerPriceListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    priceList = json['price_list'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['price_list'] = this.priceList;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String modelNoId;
  String modelNo;
  String customerPrice;
  String salesPrice;
  String listPrice;
  String listOldPrice;
  bool checked;

  Data(
      {this.modelNoId,
        this.modelNo,
        this.customerPrice,
        this.salesPrice,
        this.listPrice,
        this.listOldPrice,
        this.checked});

  Data.fromJson(Map<String, dynamic> json) {
    modelNoId = json['model_no_id'];
    modelNo = json['model_no'];
    customerPrice = json['customer_price'];
    salesPrice = json['sales_price'];
    listPrice = json['list_price'];
    listOldPrice = json['list_old_price'];
    checked = json['checked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model_no_id'] = this.modelNoId;
    data['model_no'] = this.modelNo;
    data['customer_price'] = this.customerPrice;
    data['sales_price'] = this.salesPrice;
    data['list_price'] = this.listPrice;
    data['list_old_price'] = this.listOldPrice;
    data['checked'] = this.checked;
    return data;
  }
}