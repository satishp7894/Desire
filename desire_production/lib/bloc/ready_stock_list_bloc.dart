import 'dart:async';
import 'package:desire_production/model/readyStockListModel.dart';
import 'package:desire_production/services/api_client.dart';

class ReadyStockListBloc {
  final _apiClient = ApiClient();

  final _readyStockController =
      StreamController<ReadyStockListModel>.broadcast();

  Stream<ReadyStockListModel> get readyStockStream =>
      _readyStockController.stream;

  fetchreadyStockList() async {
    try {
      final results = await _apiClient.getReadyStockList();
      _readyStockController.sink.add(results);
      print("readyStock bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _readyStockController.sink
          .addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _readyStockController.close();
  }
}
