class SalesChatDetailModel {
  bool status;
  String message;
  String conversationId;
  List<SalesChat> salesChat;

  SalesChatDetailModel(
      {this.status, this.message, this.conversationId, this.salesChat});

  SalesChatDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    conversationId = json['conversation_id'];
    if (json['salesChat'] != null) {
      salesChat = new List<SalesChat>();
      json['salesChat'].forEach((v) {
        salesChat.add(new SalesChat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['conversation_id'] = this.conversationId;
    if (this.salesChat != null) {
      data['salesChat'] = this.salesChat.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SalesChat {
  String chatId;
  String senderId;
  String senderName;
  String receiverId;
  String receiverName;
  String message;
  String date;

  SalesChat(
      {this.chatId,
        this.senderId,
        this.senderName,
        this.receiverId,
        this.receiverName,
        this.message,
        this.date});

  SalesChat.fromJson(Map<String, dynamic> json) {
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
