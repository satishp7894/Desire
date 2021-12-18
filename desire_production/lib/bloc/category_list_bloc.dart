import 'dart:async';

import 'package:desire_production/model/category_list_model.dart';
import 'package:desire_production/services/api_client.dart';


class CategoryListBloc {

  final _apiClient = ApiClient();

  final _catController = StreamController<CategoryListModel>.broadcast();

  Stream<CategoryListModel> get catStream => _catController.stream;

  fetchCategories() async {
    try {
      final results = await _apiClient.getCategoryList();
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