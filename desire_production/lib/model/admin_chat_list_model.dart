
class AdminChatListModel {
  bool status;
  String message;
  List<AdminConversations> adminConversations;

  AdminChatListModel({this.status, this.message, this.adminConversations});

  AdminChatListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['adminConversations'] != null) {
      adminConversations = new List<AdminConversations>();
      json['adminConversations'].forEach((v) {
        adminConversations.add(new AdminConversations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.adminConversations != null) {
      data['adminConversations'] =
          this.adminConversations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdminConversations {
  String conversationId;
  int convWith;
  String convId;
  String convName;

  AdminConversations(
      {this.conversationId, this.convWith, this.convId, this.convName});

  AdminConversations.fromJson(Map<String, dynamic> json) {
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