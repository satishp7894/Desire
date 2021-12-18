import 'dart:async';

import 'package:desire_production/model/product_list_order_model.dart';
import 'package:desire_production/services/api_client.dart';



class ProductOrderIDBloc {

  final _apiClient = ApiClient();

  final _productOrderIdController = StreamController<ProductListOrderModel>.broadcast();

  Stream<ProductListOrderModel> get productOrderIdStream => _productOrderIdController.stream;

  fetchProductByOrderId(String orderId) async {
    try {
      final results = await _apiClient.getOrderDetailsIdWise(orderId);
      _productOrderIdController.sink.add(results);
      print("new product list order bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _productOrderIdController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _productOrderIdController.close();
  }

}