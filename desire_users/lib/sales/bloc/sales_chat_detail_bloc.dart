import 'dart:async';

import 'package:desire_users/models/sales_chat_detail_model.dart';
import 'package:desire_users/services/api_sales.dart';

class SalesChatDetailsBloc {

  final _apiClient = ApiSales();

  final _salesChatDetailsController = StreamController<SalesChatDetailModel>.broadcast();

  Stream<SalesChatDetailModel> get salesChatDetailsStream => _salesChatDetailsController.stream;

  fetchSalesChatDetails(dynamic conversationId) async {
    try {
      final results = await _apiClient.getSalesChatDetails(conversationId);
      _salesChatDetailsController.sink.add(results);
      print("_salesChatDetailsController ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _salesChatDetailsController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _salesChatDetailsController.close();
  }

}