import 'dart:async';

import 'package:desire_users/models/product_list_order_model.dart';
import 'package:desire_users/services/api_sales.dart';


class ProductListBloc {

  final _apiClient = ApiSales();

  final _productController = StreamController<ProductListOrderModel>.broadcast();

  Stream<ProductListOrderModel> get productStream => _productController.stream;

  fetchProductList() async {
    try {
      final results = await _apiClient.getProductList();
      _productController.sink.add(results);
      print("product bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _productController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _productController.close();
  }

}