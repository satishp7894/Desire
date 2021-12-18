import 'dart:async';

import 'package:desire_production/model/admin_chat_list_model.dart';
import 'package:desire_production/services/api_client.dart';

class AdminChatListBloc {

  final _apiClient = ApiClient();

  final _adminChatListController = StreamController<AdminChatListModel>.broadcast();

  Stream<AdminChatListModel> get adminChatListStream => _adminChatListController.stream;

  fetchAdminChatList() async {
    try {
      final results = await _apiClient.getAdminChatList();
      _adminChatListController.sink.add(results);
      print("admin chat list ${results.adminConversations}");
    } on Exception catch (e) {
      print(e.toString());
      _adminChatListController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _adminChatListController.close();
  }

}