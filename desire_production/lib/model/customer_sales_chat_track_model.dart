class CustomerSalesChatTrackModel {
  bool status;
  String message;
  List<SalesCustomerConversations> salesCustomerConversations;

  CustomerSalesChatTrackModel({this.status, this.message, this.salesCustomerConversations});

  CustomerSalesChatTrackModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['salesCustomerConversations'] != null) {
      salesCustomerConversations = new List<SalesCustomerConversations>();
      json['salesCustomerConversations'].forEach((v) {
        salesCustomerConversations
            .add(new SalesCustomerConversations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.salesCustomerConversations != null) {
      data['salesCustomerConversations'] =
          this.salesCustomerConversations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesCustomerConversations {
  String conversationId;
  String convWith;
  String salesId;
  String customerId;

  SalesCustomerConversations(
      {this.conversationId, this.convWith, this.salesId, this.customerId});

  SalesCustomerConversations.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversation_id'];
    convWith = json['conv_with'];
    salesId = json['sales_id'];
    customerId = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversation_id'] = this.conversationId;
    data['conv_with'] = this.convWith;
    data['sales_id'] = this.salesId;
    data['customer_id'] = this.customerId;
    return data;
  }
}