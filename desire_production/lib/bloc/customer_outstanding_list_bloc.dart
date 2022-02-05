import 'dart:async';

import 'package:desire_production/model/customer_complaint_list_model.dart';
import 'package:desire_production/model/customer_list_for_chat_model.dart';
import 'package:desire_production/model/customer_outstanding_list_model.dart';
import 'package:desire_production/services/api_client.dart';

class CustomerOutstandingListBloc {

  final _apiClient = ApiClient();

  final _customerOutstandingListModelController = StreamController<CustomerOutstandingListModel>.broadcast();

  Stream<CustomerOutstandingListModel> get customerOutstandingListStream => _customerOutstandingListModelController.stream;

  fetchCustomerOutstandingList(String usertype) async {
    try {
      final results = await _apiClient.getCustomerlistOutstanding(usertype);
      _customerOutstandingListModelController.sink.add(results);
    } on Exception catch (e) {
      print(e.toString());
      _customerOutstandingListModelController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _customerOutstandingListModelController.close();
  }

}