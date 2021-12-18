import 'dart:async';

import 'package:desire_users/models/credit_list_model.dart';
import 'package:desire_users/services/api_sales.dart';



class CustomerCreditListBloc {

  final _apiClient = ApiSales();

  final _newCustomerCreditListController = StreamController<CreditListModel>.broadcast();

  Stream<CreditListModel> get newCustomerCreditListStream => _newCustomerCreditListController.stream;

  fetchCustomerCredit() async {
    try {
      final results = await _apiClient.getCustomerCreditList();
      _newCustomerCreditListController.sink.add(results);
      print("new customer order bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _newCustomerCreditListController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _newCustomerCreditListController.close();
  }

}