

import 'dart:async';

import 'package:desire_users/models/ready_stock_list_model.dart';
import 'package:desire_users/services/api_client.dart';

class ReadyStockListBloc {

  final _apiClient = ApiClient();

  final _readyStockListController = StreamController<ReadyStockListModel>.broadcast();

  Stream<ReadyStockListModel> get readyStockListStream => _readyStockListController.stream;

  fetchReadyStockList() async {
    print("");
    try {
      final results = await _apiClient.getReadyStockList();
      _readyStockListController.sink.add(results);
    } on Exception catch (e) {
      print(e.toString());
      _readyStockListController.sink.addError("something went wrong ${e.toString()}");
    }
  }
  dispose() {
    _readyStockListController.close();
  }
}