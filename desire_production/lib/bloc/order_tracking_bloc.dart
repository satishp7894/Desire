import 'dart:async';

import 'package:desire_production/model/order_track_model.dart';
import 'package:desire_production/services/api_client.dart';


class OrderTrackingBloc {

  final _apiClient = ApiClient();

  final _orderTrackingController = StreamController<OrderTrackModel>.broadcast();

  Stream<OrderTrackModel> get newOrderTrackStream => _orderTrackingController.stream;

  fetchOrderTrack(String orderId, String trackId) async {
    try {
      final results = await _apiClient.getOrderTracking(orderId, trackId);
      _orderTrackingController.sink.add(results);
      print("new order bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _orderTrackingController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _orderTrackingController.close();
  }

}