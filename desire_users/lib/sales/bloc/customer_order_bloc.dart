import 'dart:async';

import 'package:desire_users/models/order_model.dart';
import 'package:desire_users/services/api_sales.dart';



class CustomerOrderBloc {

  final _apiClient = ApiSales();

  final _newCustomerOrderController = StreamController<OrderModel>.broadcast();

  Stream<OrderModel> get newCustomerOrderStream => _newCustomerOrderController.stream;

  fetchCustomerOrders(String customerId) async {
    try {
      final results = await _apiClient.getCustomerOrderDetails(customerId);
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