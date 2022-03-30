import 'dart:async';

import 'package:desire_production/model/all_category.dart';
import 'package:desire_production/model/all_dimensions_model.dart';
import 'package:desire_production/model/all_model_list_model.dart';
import 'package:desire_production/model/product_model.dart';
import 'package:desire_production/services/api_client.dart';

class AddProductsBloc {

  final _apiClient = ApiClient();

  final _allDimensionsController = StreamController<AllDimensionsModel>.broadcast();

  Stream<AllDimensionsModel> get allDimensionStream => _allDimensionsController.stream;

  fetchAllDimensions() async {
    try {
      final results = await _apiClient.getAllDimensions();
      _allDimensionsController.sink.add(results);
      print("new accessory bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _allDimensionsController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  final _editDimensionsController = StreamController<AllDimensionsModel>.broadcast();

  Stream<AllDimensionsModel> get newAccessoryStream => _allDimensionsController.stream;

  EditDimensions() async {
    try {
      final results = await _apiClient.getAllDimensions();
      _editDimensionsController.sink.add(results);
      print("new accessory bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _editDimensionsController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  final _allModelssController = StreamController<AllModellistModel>.broadcast();

  Stream<AllModellistModel> get allModelStream => _allModelssController.stream;

  fetchAllModel() async {
    try {
      final results = await _apiClient.getAllModel();
      _allModelssController.sink.add(results);
      print("new accessory bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _allModelssController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  final _allCategoryController = StreamController<AllCategory>.broadcast();

  Stream<AllCategory> get allCategoryStream => _allCategoryController.stream;

  fetchAllCategory() async {
    try {
      final results = await _apiClient.getAllCategory();
      _allCategoryController.sink.add(results);
      print("new accessory bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _allCategoryController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _editDimensionsController.close();
    _allDimensionsController.close();
    _allModelssController.close();
    _allCategoryController.close();
  }

}