import 'dart:async';
import 'package:desire_production/model/productionUserProfile_model.dart';
import 'package:desire_production/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductioinUserProfileBLOC {
  final _apiClient = ApiClient();

  final _userController =
      StreamController<ProductionUserProfileModelListModel>.broadcast();

  Stream<ProductionUserProfileModelListModel> get userStream =>
      _userController.stream;

  fetchUserProfile() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String userID = preferences.getString("id");
      final results = await _apiClient.getProductionUserProfile(userID);
      _userController.sink.add(results);
      print("product bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _userController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _userController.close();
  }
}
