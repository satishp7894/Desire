import 'dart:async';

import 'package:desire_users/models/customer_chat_details_model.dart';
import 'package:desire_users/services/api_client.dart';

class CustomerChatDetailsBloc {

  final _apiClient = ApiClient();

  final _customerChatDetailsController = StreamController<CustomerChatDetailsModel>.broadcast();

  Stream<CustomerChatDetailsModel> get customerChatDetailsStream => _customerChatDetailsController.stream;

  fetchCustomerChatDetails(String customerId,String receiverId) async {
    try {
      final results = await _apiClient.getCustomerChatDetails(customerId,receiverId);
      _customerChatDetailsController.sink.add(results);
      print("CustomerChatDetailsBloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _customerChatDetailsController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _customerChatDetailsController.close();
  }

}