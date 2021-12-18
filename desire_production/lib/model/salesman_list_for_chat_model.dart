class SalesmanListForChatModel {
  bool status;
  String message;
  List<SalesList> salesList;

  SalesmanListForChatModel({this.status, this.message, this.salesList});

  SalesmanListForChatModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['salesList'] != null) {
      salesList = new List<SalesList>();
      json['salesList'].forEach((v) {
        salesList.add(new SalesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.salesList != null) {
      data['salesList'] = this.salesList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesList {
  String userId;
  String firstname;
  String lastname;

  SalesList({this.userId, this.firstname, this.lastname});

  SalesList.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    return data;
  }
}
