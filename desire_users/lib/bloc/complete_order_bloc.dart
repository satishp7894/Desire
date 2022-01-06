import 'dart:async';

import 'package:desire_users/models/category_model.dart';
import 'package:desire_users/models/complete_order_list_model.dart';
import 'package:desire_users/models/hold_orders_model.dart';
import 'package:desire_users/models/pending_order_list_model.dart';
import 'package:desire_users/services/api_client.dart';


class CompleteOrderBloc {

  final _apiClient = ApiClient();

  final _completedOrderListController = StreamController<CompleteOrderListModel>.broadcast();

  Stream<CompleteOrderListModel> get completeOrderStream => _completedOrderListController.stream;

  fetchCompleteOrder(String customerId) async {
    try {
      final results = await _apiClient.getCompleteOrderList(customerId);
      _completedOrderListController.sink.add(results);
      print("pending bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _completedOrderListController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _completedOrderListController.close();
  }

}