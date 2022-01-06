import 'dart:async';

import 'package:desire_users/models/category_model.dart';
import 'package:desire_users/models/hold_orders_model.dart';
import 'package:desire_users/models/pending_order_list_model.dart';
import 'package:desire_users/services/api_client.dart';


class HoldOrderBloc {

  final _apiClient = ApiClient();

  final _HoldOrderModelController = StreamController<HoldOrderModel>.broadcast();

  Stream<HoldOrderModel> get holdOrderStream => _HoldOrderModelController.stream;

  fetchHoldOrder(String customerId) async {
    try {
      final results = await _apiClient.getHoldOrderList(customerId);
      _HoldOrderModelController.sink.add(results);
      print("pending bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _HoldOrderModelController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _HoldOrderModelController.close();
  }

}