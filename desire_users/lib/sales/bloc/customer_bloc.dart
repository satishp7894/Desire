import 'dart:async';

import 'package:desire_users/models/sales_customer_list_model.dart';
import 'package:desire_users/services/api_sales.dart';



class CustomerListBloc {

  final _apiClient = ApiSales();

  final _newCustomerController = StreamController<SalesCustomerModel>.broadcast();

  Stream<SalesCustomerModel> get newCustomerStream => _newCustomerController.stream;

  fetchCustomerList(String salesId) async {
    try {
      final results = await _apiClient.getCustomerListDetails();
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