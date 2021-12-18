import 'dart:async';

import 'package:desire_users/models/userSearchingModel.dart';
import 'package:desire_users/services/api_client.dart';

class UserSearchingBloc {


  final _apiClient = ApiClient();

  final userSearchingController = StreamController<UserSearchingModel>.broadcast();

  Stream<UserSearchingModel> get userSearchingStream => userSearchingController.stream;

  fetchSearchResults(String searchKeyword, String customerId) async {
    try {
      final results = await _apiClient.getSearch(customerId,searchKeyword);
      userSearchingController.sink.add(results);
      print("user search bloc response ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      userSearchingController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    userSearchingController.close();
  }

}