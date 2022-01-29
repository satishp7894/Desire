import 'dart:async';

import 'package:desire_users/models/cart_model.dart';
import 'package:desire_users/models/customer_credit_details_model.dart';
import 'package:desire_users/services/api_client.dart';

class CustomerCreditDetailsBloc {

  final _apiClient = ApiClient();

  final _creditDetailController = StreamController<CustomerCreditDetailsModel>.broadcast();

  Stream<CustomerCreditDetailsModel> get creditDetailStream => _creditDetailController.stream;

  fetchCreditDetails(String id) async {
    try {
      final results = await _apiClient.getCustomerCreditDetails(id);
      _creditDetailController.sink.add(results);
      print("bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _creditDetailController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _creditDetailController.close();
  }

}