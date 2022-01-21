class CustomerChatListModel {
  bool status;
  String message;
  List<CustomerConversations> customerConversations;

  CustomerChatListModel({this.status, this.message, this.customerConversations});

  CustomerChatListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['customerConversations'] != null) {
      customerConversations = new List<CustomerConversations>();
      json['customerConversations'].forEach((v) {
        customerConversations.add(new CustomerConversations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.customerConversations != null) {
      data['customerConversations'] =
          this.customerConversations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerConversations {
  String conversationId;
  int convWith;
  String convId;
  String convName;

  CustomerConversations(
      {this.conversationId, this.convWith, this.convId, this.convName});

  CustomerConversations.fromJson(Map<String, dynamic> json) {
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