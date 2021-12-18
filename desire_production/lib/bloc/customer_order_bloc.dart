import 'dart:async';

import 'package:desire_production/model/order_model.dart';
import 'package:desire_production/services/api_client.dart';



class CustomerOrderBloc {

  final _apiClient = ApiClient();

  final _newCustomerOrderController = StreamController<OrderModel>.broadcast();

  Stream<OrderModel> get newCustomerOrderStream => _newCustomerOrderController.stream;

  fetchCustomerOrders(String customerId) async {
    try {
      final results = await _apiClient.getCustomerOrderList(customerId);
      _newCustomerOrderController.sink.add(results);
      print("new customer order bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _newCustomerOrderController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _newCustomerOrderController.close();
  }

}