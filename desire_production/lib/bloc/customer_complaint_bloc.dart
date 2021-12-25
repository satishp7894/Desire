import 'dart:async';

import 'package:desire_production/model/customer_complaint_list_model.dart';
import 'package:desire_production/model/customer_list_for_chat_model.dart';
import 'package:desire_production/services/api_client.dart';

class CustomerComplaintListBloc {

  final _apiClient = ApiClient();

  final _customerComplaintListModelController = StreamController<CustomerComplaintListModel>.broadcast();

  Stream<CustomerComplaintListModel> get customerComplaintListStream => _customerComplaintListModelController.stream;

  fetchCustomerComplaintList() async {
    try {
      final results = await _apiClient.getCustomerComplaintList();
      _customerComplaintListModelController.sink.add(results);
      print("customer chat list ${results.complaintList}");
    } on Exception catch (e) {
      print(e.toString());
      _customerComplaintListModelController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _customerComplaintListModelController.close();
  }

}