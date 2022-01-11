import 'dart:async';

import 'package:desire_users/models/cart_model.dart';
import 'package:desire_users/models/customer_notification_list_model.dart';
import 'package:desire_users/services/api_client.dart';

class CustomerNotificationListBloc {

  final _apiClient = ApiClient();

  final _customerNotificationController = StreamController<CustomerNotificationListModel>.broadcast();

  Stream<CustomerNotificationListModel> get newNotificationStream => _customerNotificationController.stream;

  fetchCustomerNotification(String id) async {
    try {
      final results = await _apiClient.getCustomerNotificationList(id);
      _customerNotificationController.sink.add(results);
      print("new cart bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _customerNotificationController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _customerNotificationController.close();
  }

}