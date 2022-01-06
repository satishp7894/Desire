import 'dart:async';

import 'package:desire_users/models/category_model.dart';
import 'package:desire_users/models/pending_order_list_model.dart';
import 'package:desire_users/services/api_client.dart';


class PendingOrderListBloc {

  final _apiClient = ApiClient();

  final _pendingOrderController = StreamController<PendingOrderListModel>.broadcast();

  Stream<PendingOrderListModel> get pendingOrderStream => _pendingOrderController.stream;

  fetchPendingOrder(String customerId) async {
    try {
      final results = await _apiClient.getPendingOrderList(customerId);
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