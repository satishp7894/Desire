import 'dart:async';

import 'package:desire_users/models/product_model.dart';
import 'package:desire_users/services/api_client.dart';


class AccesoryBloc {

  final _apiClient = ApiClient();

  final _newAccesoryController = StreamController<ProductModel>.broadcast();

  Stream<ProductModel> get newAccessoryStream => _newAccesoryController.stream;

  fetchAccessory(String customerId) async {
    try {
      final results = await _apiClient.getAccessoryDetails(customerId);
      _newAccesoryController.sink.add(results);
      print("new accessory bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _newAccesoryController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _newAccesoryController.close();
  }

}