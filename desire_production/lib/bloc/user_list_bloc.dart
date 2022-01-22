
import 'dart:async';

import 'package:desire_production/model/user_list_model.dart';
import 'package:desire_production/services/api_client.dart';

class UserListBloc {

  final _apiClient = ApiClient();

  final _newCustomerController = StreamController<UserListModel>.broadcast();

  Stream<UserListModel> get newUserStream => _newCustomerController.stream;

  fetchUserList() async {
    try {
      final results = await _apiClient.getAllUserList();
      _newCustomerController.sink.add(results);
      print("new customer bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _newCustomerController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _newCustomerController.close();
  }

}