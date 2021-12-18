import 'dart:async';

import 'package:desire_users/models/customer_chat_list_model.dart';
import 'package:desire_users/services/api_client.dart';

class CustomerChatListBloc {

  final _apiClient = ApiClient();

  final _customerChatListController = StreamController<CustomerChatListModel>.broadcast();

  Stream<CustomerChatListModel> get catStream => _customerChatListController.stream;

  fetchCustomerChatList(String customerId) async {
    try {
      final results = await _apiClient.getCustomerChatList(customerId);
      _customerChatListController.sink.add(results);
      print("CustomerChatListBloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _customerChatListController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _customerChatListController.close();
  }

}