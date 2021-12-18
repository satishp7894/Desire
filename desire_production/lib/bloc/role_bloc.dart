import 'dart:async';
import 'package:desire_production/model/role_model.dart';
import 'package:desire_production/services/api_client.dart';




class AdminRoleBloc {

  final _apiClient = ApiClient();

  final _adminController = StreamController<RoleModel>.broadcast();

  Stream<RoleModel> get adminRoleStream => _adminController.stream;

  fetchAdminRoleList() async {
    try {
      final results = await _apiClient.getAdminRoleList();
      _adminController.sink.add(results);
      print("admin role bloc $results");
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