class CustomerChatDetailsModel {
  bool status;
  String message;
  String conversationId;
  List<CustomerChat> customerChat;

  CustomerChatDetailsModel(
      {this.status, this.message, this.conversationId, this.customerChat});

  CustomerChatDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    conversationId = json['conversation_id'];
    if (json['customerChat'] != null) {
      customerChat = new List<CustomerChat>();
      json['customerChat'].forEach((v) {
        customerChat.add(new CustomerChat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['conversation_id'] = this.conversationId;
    if (this.customerChat != null) {
      data['customerChat'] = this.customerChat.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerChat {
  String chatId;
  String senderId;
  String senderName;
  String receiverId;
  String receiverName;
  String message;
  String date;

  CustomerChat(
      {this.chatId,
        this.senderId,
        this.senderName,
        this.receiverId,
        this.receiverName,
        this.message,
        this.date});

  CustomerChat.fromJson(Map<String, dynamic> json) {
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
