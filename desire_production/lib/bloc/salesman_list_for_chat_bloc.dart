import 'dart:async';

import 'package:desire_production/model/salesman_list_for_chat_model.dart';
import 'package:desire_production/services/api_client.dart';

class SalesmanListForChatBloc {

  final _apiClient = ApiClient();

  final _salesmanListForChatController = StreamController<SalesmanListForChatModel>.broadcast();

  Stream<SalesmanListForChatModel> get salesmanListForChatStream => _salesmanListForChatController.stream;

  fetchSalesmanListForChat() async {
    try {
      final results = await _apiClient.getSalesmanListForChat();
      _salesmanListForChatController.sink.add(results);
      print("customer chat list ${results.salesList}");
    } on Exception catch (e) {
      print(e.toString());
      _salesmanListForChatController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _salesmanListForChatController.close();
  }

}