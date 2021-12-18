import 'dart:async';

import 'package:desire_users/models/new_customer_list_model.dart';
import 'package:desire_users/services/api_sales.dart';

class NewCustomerListBloc {

  final _apiClient = ApiSales();

  final _newCustomerListController = StreamController<CustomerListModel>.broadcast();

  Stream<CustomerListModel> get newCustomerListStream => _newCustomerListController.stream;

  fetchNewCustomerList(String salesId) async {
    try {
      final results = await _apiClient.getNewCustomerList(salesId);
      _newCustomerListController.sink.add(results);
      print("fetchNewCustomerList ${results.customerList}");

    } on Exception catch (e) {
      print(e.toString());
      _newCustomerListController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _newCustomerListController.close();
  }

}