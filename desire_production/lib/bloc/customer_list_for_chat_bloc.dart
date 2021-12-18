import 'dart:async';

import 'package:desire_production/model/customer_list_for_chat_model.dart';
import 'package:desire_production/services/api_client.dart';

class CustomerListForChatBloc {

  final _apiClient = ApiClient();

  final _customerListForChatController = StreamController<CustomerListForChatModel>.broadcast();

  Stream<CustomerListForChatModel> get customerListForChatStream => _customerListForChatController.stream;

  fetchCustomerListForChat() async {
    try {
      final results = await _apiClient.getCustomerListForChat();
      _customerListForChatController.sink.add(results);
      print("customer chat list ${results.customerList}");
    } on Exception catch (e) {
      print(e.toString());
      _customerListForChatController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _customerListForChatController.close();
  }

}