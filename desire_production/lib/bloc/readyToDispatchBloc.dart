import 'dart:async';

import 'package:desire_production/model/readyToDispatchListModel.dart';
import 'package:desire_production/model/warehouse_list_model.dart';
import 'package:desire_production/services/api_client.dart';

class ReadyToDispatchBloc {

  final _apiClient = ApiClient();

  final readyToDispatchController = StreamController<ReadyToDispatchListModel>.broadcast();

  Stream<ReadyToDispatchListModel> get readyToDispatchStream => readyToDispatchController.stream;

  fetchReadyToDispatchList() async {
    try {
      final results = await _apiClient.getReadyToDispatchList();
      readyToDispatchController.sink.add(results);
      print("ware bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      readyToDispatchController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    readyToDispatchController.close();
  }

}