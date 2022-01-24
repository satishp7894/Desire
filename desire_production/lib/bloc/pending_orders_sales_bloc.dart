import 'dart:async';

import 'package:desire_production/model/pending_order_list_model.dart';
import 'package:desire_production/services/api_client.dart';


class PendingOrderSalesBloc {

  final _apiSales = ApiClient();

  final _pendingOrderController = StreamController<PendingOrderListModel>.broadcast();

  Stream<PendingOrderListModel> get pendingOrderStream => _pendingOrderController.stream;

  fetchPendingOrder() async {
    try {
      final results = await _apiSales.getPendingOrderListSales();
      _pendingOrderController.sink.add(results);
      print("pending bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _pendingOrderController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _pendingOrderController.close();
  }

}