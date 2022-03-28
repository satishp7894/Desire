import 'dart:async';

import 'package:desire_users/models/credit_details_model.dart';
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

  final _creditDetailController = StreamController<CreditDetailsModel>.broadcast();

  Stream<CreditDetailsModel> get creditDetailStream => _creditDetailController.stream;

  fetchCreditDetails(String customerId) async {
    try {
      final results = await _apiClient.getCreditDetails(customerId);
      _creditDetailController.sink.add(results);
      print("detail $results");
    } on Exception catch (e) {
      print(e.toString());
      _creditDetailController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }
  dispose() {
    _creditDetailController.close();
    _newCustomerController.close();
  }

}