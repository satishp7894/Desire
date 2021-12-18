import 'dart:async';

import 'package:desire_production/model/sales_customer_list_model.dart';
import 'package:desire_production/services/api_client.dart';




class CustomerListBloc {

  final _apiClient = ApiClient();

  final _newCustomerController = StreamController<SalesCustomerModel>.broadcast();

  Stream<SalesCustomerModel> get newCustomerStream => _newCustomerController.stream;

  fetchCustomerList() async {
    try {
      final results = await _apiClient.getAllCustomerListDetails();
      _newCustomerController.sink.add(results);
      print("new customer bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _newCustomerController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _newCustomerController.close();
  }

}