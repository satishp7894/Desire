class SalesChatListModel {
  bool status;
  String message;
  List<SalesConversations> salesConversations;

  SalesChatListModel({this.status, this.message, this.salesConversations});

  SalesChatListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['salesConversations'] != null) {
      salesConversations = new List<SalesConversations>();
      json['salesConversations'].forEach((v) {
        salesConversations.add(new SalesConversations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.salesConversations != null) {
      data['salesConversations'] =
          this.salesConversations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesConversations {
  String conversationId;
  int convWith;
  dynamic convId;
  String convName;

  SalesConversations(
      {this.conversationId, this.convWith, this.convId, this.convName});

  SalesConversations.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversation_id'];
    convWith = json['conv_with'];
    convId = json['conv_id'];
    convName = json['conv_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversation_id'] = this.conversationId;
    data['conv_with'] = this.convWith;
    data['conv_id'] = this.convId;
    data['conv_name'] = this.convName;
    return data;
  }
}
