import 'dart:async';
import 'package:desire_production/model/product_list_model.dart';
import 'package:desire_production/services/api_client.dart';


class ProductionListBloc {

  final _apiClient = ApiClient();

  final _productController = StreamController<ProductListModel>.broadcast();

  Stream<ProductListModel> get productStream => _productController.stream;

  fetchProductList() async {
    try {
      final results = await _apiClient.getProductionPlanningList();
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