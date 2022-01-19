import 'dart:async';

import 'package:desire_production/model/orderDetailsByIdModel.dart';
import 'package:desire_production/model/product_list_order_model.dart';
import 'package:desire_production/services/api_client.dart';



class OrderDetailsByIdBloc {

  final _apiClient = ApiClient();

  final _orderDetailsByIdController = StreamController<OrderDetailsByIdModel>.broadcast();

  Stream<OrderDetailsByIdModel> get orderDetailsByIdStream => _orderDetailsByIdController.stream;

  fetchOrderDetailsById(String orderId) async {
    try {
      final results = await _apiClient.getOrderdetailsbyId(orderId);
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