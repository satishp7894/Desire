import 'dart:async';

import 'package:desire_production/model/order_model.dart';
import 'package:desire_production/model/today_order_details_page_model.dart';
import 'package:desire_production/services/api_client.dart';



class TodayOrderDetailsPageBloc {

  final _apiClient = ApiClient();

  final _todayOrderDetailsController = StreamController<TodayOrderDetailsPageModel>.broadcast();

  Stream<TodayOrderDetailsPageModel> get todayOrderDetailsStream => _todayOrderDetailsController.stream;

  fetchTodayOrderDetails() async {
    try {
      final results = await _apiClient.getTodayOrderDetail();
      _todayOrderDetailsController.sink.add(results);
      print("new customer order bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _todayOrderDetailsController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _todayOrderDetailsController.close();
  }

}