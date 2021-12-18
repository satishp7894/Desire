import 'dart:async';

import 'package:desire_production/model/dashboard_production_model.dart';
import 'package:desire_production/services/api_client.dart';

class ProductionDashboardBloc {

  final _apiClient = ApiClient();

  final productionDashboardController = StreamController<ProductionDashBoardModel>.broadcast();

  Stream<ProductionDashBoardModel> get productionDashboardStream => productionDashboardController.stream;

  fetchProductionDashboardCount() async {
    try {
      final results = await _apiClient.getProductionDashboardCount();
      productionDashboardController.sink.add(results);
      print("dashboard count $results");
    } on Exception catch (e) {
      print(e.toString());
      productionDashboardController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    productionDashboardController.close();
  }

}