import 'dart:async';

import 'package:desire_users/models/cart_model.dart';
import 'package:desire_users/services/api_client.dart';

class CartBloc {

  final _apiClient = ApiClient();

  final _newCartController = StreamController<CartModel>.broadcast();

  Stream<CartModel> get newCartStream => _newCartController.stream;

  fetchCartDetails(String id) async {
    try {
      final results = await _apiClient.getCartDetails(id);
      _newCartController.sink.add(results);
      print("new cart bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _newCartController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _newCartController.close();
  }

}