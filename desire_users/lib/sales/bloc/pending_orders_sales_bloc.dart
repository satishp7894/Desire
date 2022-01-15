import 'dart:async';

import 'package:desire_users/models/category_model.dart';
import 'package:desire_users/models/pending_order_list_model.dart';
import 'package:desire_users/services/api_client.dart';
import 'package:desire_users/services/api_sales.dart';


class PendingOrderSalesBloc {

  final _apiSales = ApiSales();

  final _pendingOrderController = StreamController<PendingOrderListModel>.broadcast();

  Stream<PendingOrderListModel> get pendingOrderStream => _pendingOrderController.stream;

  fetchPendingOrder(String salesId) async {
    try {
      final results = await _apiSales.getPendingOrderListSales(salesId);
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