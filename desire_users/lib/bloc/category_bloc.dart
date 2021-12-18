import 'dart:async';

import 'package:desire_users/models/category_model.dart';
import 'package:desire_users/services/api_client.dart';


class CategoryBloc {

  final _apiClient = ApiClient();

  final _catController = StreamController<CategoryModel>.broadcast();

  Stream<CategoryModel> get catStream => _catController.stream;

  fetchCategories(String customerId) async {
    try {
      final results = await _apiClient.getCategoryDetails(customerId);
      _catController.sink.add(results);
      print("cat bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _catController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _catController.close();
  }

}