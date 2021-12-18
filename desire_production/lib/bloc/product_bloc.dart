import 'dart:async';
import 'package:desire_production/model/product_model.dart';
import 'package:desire_production/services/api_client.dart';

class ProductBloc {

  final _apiClient = ApiClient();

  final _newProductController = StreamController<ProductModel>.broadcast();

  Stream<ProductModel> get newProductStream => _newProductController.stream;

  fetchNewProduct(String id) async {
    try {
      final results = await _apiClient.getNewProductDetails(id);
      _newProductController.sink.add(results);
      print("new product bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _newProductController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  final _bestProductController = StreamController<ProductModel>.broadcast();

  Stream<ProductModel> get bestProductStream => _bestProductController.stream;

  fetchBestProduct(String id) async {
    try {
      final results = await _apiClient.getBestProductDetails(id);
      _bestProductController.sink.add(results);
      print("best product bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _bestProductController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  final _futureProductController = StreamController<ProductModel>.broadcast();

  Stream<ProductModel> get futureProductStream => _futureProductController.stream;

  fetchFutureProduct(String id) async {
    try {
      final results = await _apiClient.getFutureProductDetails(id);
      _futureProductController.sink.add(results);
      print("future product bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _futureProductController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  final _categoryProductController = StreamController<ProductModel>.broadcast();

  Stream<ProductModel> get categoryWiseProductStream => _categoryProductController.stream;

  fetchCategoryWiseProduct(String id) async {
    try {
      final results = await _apiClient.getCategoryWiseProductDetails(id);
      _categoryProductController.sink.add(results);
      print("category product bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _categoryProductController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  final _searchProductController = StreamController<ProductModel>.broadcast();

  Stream<ProductModel> get searchProductStream => _searchProductController.stream;

  fetchSearchProduct(String search, String id) async {
    try {
      final results = await _apiClient.getSearchProductDetails(search,id);
      _searchProductController.sink.add(results);
      print("search product bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _searchProductController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  final _searchAccessoriesController = StreamController<ProductModel>.broadcast();

  Stream<ProductModel> get searchAccessoriesStream => _searchAccessoriesController.stream;

  fetchSearchAccessories(String search, String id) async {
    try {
      final results = await _apiClient.getSearchAccessoriesDetails(search);
      _searchAccessoriesController.sink.add(results);
      print("search product bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _searchAccessoriesController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _newProductController.close();
    _bestProductController.close();
    _futureProductController.close();
    _categoryProductController.close();
    _searchProductController.close();
    _searchAccessoriesController.close();
  }

}