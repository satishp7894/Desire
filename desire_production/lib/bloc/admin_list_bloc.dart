import 'dart:async';
import 'package:desire_production/model/user_model.dart';
import 'package:desire_production/services/api_client.dart';




class AdminListBloc {

  final _apiClient = ApiClient();

  final _adminController = StreamController<UserModel>.broadcast();

  Stream<UserModel> get adminStream => _adminController.stream;

  fetchAdminList() async {
    try {
      final results = await _apiClient.getAdminUserList();
      _adminController.sink.add(results);
      print("admin bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _adminController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _adminController.close();
  }

}