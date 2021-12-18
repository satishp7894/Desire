import 'dart:async';
import 'package:desire_production/model/product_model.dart';
import 'package:desire_production/services/api_client.dart';


class ProductListBloc {

  final _apiClient = ApiClient();

  final _productController = StreamController<ProductModel>.broadcast();

  Stream<ProductModel> get productStream => _productController.stream;

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