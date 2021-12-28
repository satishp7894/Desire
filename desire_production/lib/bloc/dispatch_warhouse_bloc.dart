import 'dart:async';

import 'package:desire_production/model/dispatchOrderDetailsModel.dart';
import 'package:desire_production/model/dispatch_order_warhouse_list_model.dart';
import 'package:desire_production/services/api_client.dart';

class DispatchWarhouseBloc {
  final _apiClient = ApiClient();

  final _dispatchOrderWarhouseListController = StreamController<DispatchOrderWarhouseListModel>.broadcast();

  Stream<DispatchOrderWarhouseListModel> get dispatchOrderWarhouseListStream => _dispatchOrderWarhouseListController.stream;

  fetchDispatchWarhouseLilst(var customerId) async {
    try {
      final results = await _apiClient.getDispatchList(customerId);
      _dispatchOrderWarhouseListController.sink.add(results);
      print("ware bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _dispatchOrderWarhouseListController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _dispatchOrderWarhouseListController.close();
  }

}