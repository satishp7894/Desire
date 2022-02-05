import 'dart:async';

import 'package:desire_production/model/category_list_model.dart';
import 'package:desire_production/model/customer_list_with_credit_model.dart';
import 'package:desire_production/services/api_client.dart';


class CustomerListWithCreditBloc {

  final _apiClient = ApiClient();

  final _listWithcreditController = StreamController<CustomerListWithCreditModel>.broadcast();

  Stream<CustomerListWithCreditModel> get withlistCreditStream => _listWithcreditController.stream;

  fetchlistWithCredit() async {
    try {
      final results = await _apiClient.getCustomerlistCredit();
      _listWithcreditController.sink.add(results);
      print("cat bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _listWithcreditController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _listWithcreditController.close();
  }

}