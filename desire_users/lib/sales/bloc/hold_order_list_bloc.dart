import 'dart:async';

import 'package:desire_users/models/category_model.dart';
import 'package:desire_users/models/hold_orders_model.dart';
import 'package:desire_users/models/pending_order_list_model.dart';
import 'package:desire_users/services/api_client.dart';
import 'package:desire_users/services/api_sales.dart';


class HoldOrderListBloc {

  final _apiSales = ApiSales();

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