import 'dart:async';

import 'package:desire_users/models/wishlist_model.dart';
import 'package:desire_users/services/api_client.dart';

class WishListBloc {

  final _apiClient = ApiClient();

  final _newWishListController = StreamController<WishListModel>.broadcast();

  Stream<WishListModel> get newWishListStream => _newWishListController.stream;

  fetchWishList(String userId) async {
    try {
      final results = await _apiClient.getWishList(userId);
      _newWishListController.sink.add(results);
      print("new wishlist bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _newWishListController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _newWishListController.close();
  }

}