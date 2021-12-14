import 'dart:async';

import 'package:desire_users/models/orderDetailsByIdModel.dart';
import 'package:desire_users/models/product_list_order_model.dart';
import 'package:desire_users/services/api_sales.dart';



class OrderDetailsByIdBloc {

  final _apiClient = ApiSales();

  final _orderDetailsByIdController = StreamController<OrderDetailsByIdModel>.broadcast();

  Stream<OrderDetailsByIdModel> get orderDetailsByIdStream => _orderDetailsByIdController.stream;

  fetchOrderDetailsById(String orderId) async {
    try {
      final results = await _apiClient.getOrderDetailsIdWise(orderId);
      _orderDetailsByIdController.sink.add(results);
      print("new product list order bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _orderDetailsByIdController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _orderDetailsByIdController.close();
  }

}