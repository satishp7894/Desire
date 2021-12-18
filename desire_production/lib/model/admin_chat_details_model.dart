class AdminChatDetailsModel {
  bool status;
  String message;
  String conversationId;
  List<AdminChat> adminChat;

  AdminChatDetailsModel(
      {this.status, this.message, this.conversationId, this.adminChat});

  AdminChatDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    conversationId = json['conversation_id'];
    if (json['adminChat'] != null) {
      adminChat = new List<AdminChat>();
      json['adminChat'].forEach((v) {
        adminChat.add(new AdminChat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['conversation_id'] = this.conversationId;
    if (this.adminChat != null) {
      data['adminChat'] = this.adminChat.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdminChat {
  String chatId;
  String senderId;
  String senderName;
  String receiverId;
  String receiverName;
  String message;
  String date;

  AdminChat(
      {this.chatId,
        this.senderId,
        this.senderName,
        this.receiverId,
        this.receiverName,
        this.message,
        this.date});

  AdminChat.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'];
    senderId = json['sender_id'];
    senderName = json['sender_name'];
    receiverId = json['receiver_id'];
    receiverName = json['receiver_name'];
    message = json['message'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_id'] = this.chatId;
    data['sender_id'] = this.senderId;
    data['sender_name'] = this.senderName;
    data['receiver_id'] = this.receiverId;
    data['receiver_name'] = this.receiverName;
    data['message'] = this.message;
    data['date'] = this.date;
    return data;
  }
}
