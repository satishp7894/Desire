import 'dart:async';

import 'package:desire_users/models/product_details_model.dart';
import 'package:desire_users/services/api_client.dart';

class ProductDetailBloc {

  final _apiClient = ApiClient();

  final _newProductDetailController = StreamController<ProductDetailModel>.broadcast();

  Stream<ProductDetailModel> get newProductDetailStream => _newProductDetailController.stream;

  fetchDetailProduct(String productId,String customerId) async {
    try {
      final results = await _apiClient.getProductDetails(productId,customerId);
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