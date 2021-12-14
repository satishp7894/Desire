import 'dart:async';

import 'package:desire_users/models/order_model.dart';
import 'package:desire_users/services/api_client.dart';


class OrderBloc {

  final _apiClient = ApiClient();

  final _newOrderController = StreamController<OrderModel>.broadcast();

  Stream<OrderModel> get newOrderStream => _newOrderController.stream;

  fetchOrder(String customerId) async {
    try {
      final results = await _apiClient.getOrderDetails(customerId);
      _newOrderController.sink.add(results);
      print("new order bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _newOrderController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _newOrderController.close();
  }

}