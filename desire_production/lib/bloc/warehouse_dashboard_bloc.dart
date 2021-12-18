import 'dart:async';

import 'package:desire_production/model/dashboard_production_model.dart';
import 'package:desire_production/model/warehouse_dashboard_model.dart';
import 'package:desire_production/services/api_client.dart';

class WarehuseDashboardBloc {

  final _apiClient = ApiClient();

  final warehouseDashboardController = StreamController<WarehouseDashBoardModel>.broadcast();

  Stream<WarehouseDashBoardModel> get warehouseDashboardStream => warehouseDashboardController.stream;

  fetchWarehouseDashboardCount() async {
    try {
      final results = await _apiClient.getWarehouseDashboardCount();
      warehouseDashboardController.sink.add(results);
      print("dashboard count $results");
    } on Exception catch (e) {
      print(e.toString());
      warehouseDashboardController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    warehouseDashboardController.close();
  }

}