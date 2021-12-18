import 'dart:async';
import 'package:desire_users/models/productFromModelNoModel.dart';
import 'package:desire_users/services/api_client.dart';

class ProductFromModelBloc {

  final _apiClient = ApiClient();

  final productFromModelController = StreamController<ProductFromModelNoModel>.broadcast();

  Stream<ProductFromModelNoModel> get productFromModelStream => productFromModelController.stream;

  fetchProductFromModel(String modelNoId, String customerId) async {
    try {
      final results = await _apiClient.getProductFromModelNo(modelNoId,customerId);
      productFromModelController.sink.add(results);
      print("category bloc response ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      productFromModelController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    productFromModelController.close();
  }

}