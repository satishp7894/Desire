import 'dart:async';

import 'package:desire_production/model/product_model.dart';
import 'package:desire_production/services/api_client.dart';

class ProductDetailBloc {

  final _apiClient = ApiClient();

  final _newProductDetailController = StreamController<ProductModel>.broadcast();

  Stream<ProductModel> get newProductDetailStream => _newProductDetailController.stream;

  fetchDetailProduct(String productId, String id) async {
    try {
      final results = await _apiClient.getProductDetails(productId, id);
      _newProductDetailController.sink.add(results);
      print("new productDetail bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _newProductDetailController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _newProductDetailController.close();
  }


}