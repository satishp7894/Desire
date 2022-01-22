import 'dart:async';
import 'package:desire_production/model/product_model.dart';
import 'package:desire_production/model/role_list_model.dart';
import 'package:desire_production/services/api_client.dart';


class RoleListBloc {

  final _apiClient = ApiClient();

  final _roleController = StreamController<RoleListModel>.broadcast();

  Stream<RoleListModel> get roleStream => _roleController.stream;

  fetchRoleList() async {
    try {
      final results = await _apiClient.getRoleList();
      _roleController.sink.add(results);
      print("product bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _roleController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _roleController.close();
  }

}