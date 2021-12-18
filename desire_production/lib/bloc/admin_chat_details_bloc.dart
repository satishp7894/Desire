import 'dart:async';

import 'package:desire_production/model/admin_chat_details_model.dart';
import 'package:desire_production/services/api_client.dart';

class AdminChatDetailsBloc {

  final _apiClient = ApiClient();

  final _adminChatDetailsController = StreamController<AdminChatDetailsModel>.broadcast();

  Stream<AdminChatDetailsModel> get adminChatDetailsStream => _adminChatDetailsController.stream;

  fetchAdminChatDetails(dynamic conversationId) async {
    try {
      final results = await _apiClient.getAdminChatDetails(conversationId);
      _adminChatDetailsController.sink.add(results);
      print("admin chat details ${results.adminChat}");
    } on Exception catch (e) {
      print(e.toString());
      _adminChatDetailsController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _adminChatDetailsController.close();
  }

}