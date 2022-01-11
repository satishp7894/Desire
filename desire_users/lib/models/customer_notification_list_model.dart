class CustomerNotificationListModel {
  bool status;
  String message;
  List<CustomerNotification> customerNotification;

  CustomerNotificationListModel({this.status, this.message, this.customerNotification});

  CustomerNotificationListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['customerNotification'] != null) {
      customerNotification = new List<CustomerNotification>();
      json['customerNotification'].forEach((v) {
        customerNotification.add(new CustomerNotification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.customerNotification != null) {
      data['customerNotification'] =
          this.customerNotification.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerNotification {
  String notiUserId;
  String userId;
  Null salesmanID;
  String title;
  String description;
  String createAt;
  Null updateAt;

  CustomerNotification(
      {this.notiUserId,
        this.userId,
        this.salesmanID,
        this.title,
        this.description,
        this.createAt,
        this.updateAt});

  CustomerNotification.fromJson(Map<String, dynamic> json) {
    notiUserId = json['noti_user_id'];
    userId = json['user_id'];
    salesmanID = json['salesmanID'];
    title = json['title'];
    description = json['description'];
    createAt = json['create_at'];
    updateAt = json['update_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noti_user_id'] = this.notiUserId;
    data['user_id'] = this.userId;
    data['salesmanID'] = this.salesmanID;
    data['title'] = this.title;
    data['description'] = this.description;
    data['create_at'] = this.createAt;
    data['update_at'] = this.updateAt;
    return data;
  }
}