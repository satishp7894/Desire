class CustomerChatListModel {
  bool status;
  String message;
  List<CustomerChat> customerChat;

  CustomerChatListModel({this.status, this.message, this.customerChat});

  CustomerChatListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    if (this.customerChat != null) {
      data['customerChat'] = this.customerChat.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerChat {
  dynamic convId;
  String convName;

  CustomerChat({this.convId, this.convName});

  CustomerChat.fromJson(Map<String, dynamic> json) {
    convId = json['conv_id'];
    convName = json['conv_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conv_id'] = this.convId;
    data['conv_name'] = this.convName;
    return data;
  }
}
