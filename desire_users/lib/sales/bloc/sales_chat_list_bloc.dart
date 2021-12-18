import 'dart:async';

import 'package:desire_users/models/customer_chat_list_model.dart';
import 'package:desire_users/models/sales_chat_list_model.dart';
import 'package:desire_users/services/api_sales.dart';

class SalesChatListBloc {

  final _apiClient = ApiSales();

  final _salesChatListController = StreamController<SalesChatListModel>.broadcast();

  Stream<SalesChatListModel> get salesChatListStream => _salesChatListController.stream;

  fetchSalesChatList(String salesId) async {
    try {
      final results = await _apiClient.getSalesChatList(salesId);
      _salesChatListController.sink.add(results);
      print("_salesChatListController ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _salesChatListController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _salesChatListController.close();
  }

}