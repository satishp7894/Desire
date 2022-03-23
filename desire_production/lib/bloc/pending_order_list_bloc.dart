import 'dart:async';
import 'package:desire_production/model/dailyOrderListModel.dart';
import 'package:desire_production/model/product_list_model.dart';
import 'package:desire_production/services/api_client.dart';


class PendingOrderListBloc {

  final _apiClient = ApiClient();

  final _dailyOrderListController = StreamController<DailyOrdersListModel>.broadcast();

  Stream<DailyOrdersListModel> get dailyOrderListStream => _dailyOrderListController.stream;

  fetchPendingOrderList() async {
    try {
      final results = await _apiClient.getProductionPendingOrderList();
      _dailyOrderListController.sink.add(results);
      print("daily production list bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _dailyOrderListController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _dailyOrderListController.close();
  }

}