import 'dart:async';

import 'package:desire_production/model/dispatchOrderDetailsModel.dart';
import 'package:desire_production/services/api_client.dart';

class DispatchOrderDetailsListBloc {
  final _apiClient = ApiClient();

  final _dispatchOrderDetailsController = StreamController<DispatchOrderDetailsModel>.broadcast();

  Stream<DispatchOrderDetailsModel> get dispatchOrderDetailsStream => _dispatchOrderDetailsController.stream;

  fetchDispatchOrderDetailsList(var orderId) async {
    try {
      final results = await _apiClient.getDispatchOrderDetailsList(orderId);
      _dispatchOrderDetailsController.sink.add(results);
      print("ware bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _dispatchOrderDetailsController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _dispatchOrderDetailsController.close();
  }

}