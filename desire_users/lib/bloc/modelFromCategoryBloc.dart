import 'dart:async';
import 'package:desire_users/models/modelNumberFromCategoryModel.dart';
import 'package:desire_users/services/api_client.dart';

class ModelFromCategoryBloc {

  final _apiClient = ApiClient();

  final modelFromCategoryController = StreamController<ModelNoFromCategoryModel>.broadcast();

  Stream<ModelNoFromCategoryModel> get modelFromCategoryStream => modelFromCategoryController.stream;

  fetchModelFromCategories(String categoryId) async {
    try {
      final results = await _apiClient.getModelFromCategory(categoryId);
      modelFromCategoryController.sink.add(results);
      print("category bloc response ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      modelFromCategoryController.sink.addError("something went wrong ${e.toString()}");
    }
  }



  dispose() {
    modelFromCategoryController.close();
  }

}