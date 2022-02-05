import 'dart:async';

import 'package:desire_production/model/order_model.dart';
import 'package:desire_production/model/today_dispatch_invoice_details_model.dart';
import 'package:desire_production/model/today_order_details_page_model.dart';
import 'package:desire_production/services/api_client.dart';



class TodayInvoiceDispatchDetailsBloc {

  final _apiClient = ApiClient();

  final _todaydispatchDetailsController = StreamController<TodayDispatchInvoiceDetailsModel>.broadcast();

  Stream<TodayDispatchInvoiceDetailsModel> get todayDispatchDetailsStream => _todaydispatchDetailsController.stream;

  fetchTodayDispatchDetails() async {
    try {
      final results = await _apiClient.getTodayDispatchInvoiceDetail();
      _todaydispatchDetailsController.sink.add(results);
      print("new customer order bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _todaydispatchDetailsController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _todaydispatchDetailsController.close();
  }

}