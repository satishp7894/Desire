import 'dart:async';

import 'package:desire_production/model/hold_orders_model.dart';
import 'package:desire_production/services/api_client.dart';


class HoldOrderListBloc {

  final _apiSales = ApiClient();

  final _pendingOrderController = StreamController<HoldOrderModel>.broadcast();

  Stream<HoldOrderModel> get holdOrderStream => _pendingOrderController.stream;

  fetchHoldOrder(String salesId) async {
    try {
      final results = await _apiSales.getHoldOrderListSales(salesId);
      _pendingOrderController.sink.add(results);
      print("hold bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _pendingOrderController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _pendingOrderController.close();
  }

}