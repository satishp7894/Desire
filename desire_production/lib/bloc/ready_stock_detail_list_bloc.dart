import 'dart:async';

import 'package:desire_production/model/readyStockDetailListModel.dart';
import 'package:desire_production/services/api_client.dart';

class ReadyStockDetailListBloc {
  final _apiClient = ApiClient();

  final _readyStockDetailController =
      StreamController<ReadyStockDetailListModel>.broadcast();

  Stream<ReadyStockDetailListModel> get readyStockDetailStream =>
      _readyStockDetailController.stream;

  fetchreadyStockDetailList(String modelNoId) async {
    try {
      final results = await _apiClient.getReadyStockDetailList(modelNoId);
      _readyStockDetailController.sink.add(results);
      print("readyStock bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _readyStockDetailController.sink
          .addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _readyStockDetailController.close();
  }
}
