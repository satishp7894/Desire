import 'dart:async';
import 'package:desire_production/model/dailyProductionListModel.dart';
import 'package:desire_production/model/production_order_model.dart';
import 'package:desire_production/services/api_client.dart';


class DailyProductionListBloc {

  final _apiClient = ApiClient();

  final _dailyProductionListController = StreamController<DailyProductionListModel>.broadcast();

  Stream<DailyProductionListModel> get dailyProductionListStream => _dailyProductionListController.stream;

  fetchDailyProductionList() async {
    try {
      final results = await _apiClient.getDailyProductionList();
      _dailyProductionListController.sink.add(results);
      print("product bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _dailyProductionListController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _dailyProductionListController.close();
  }

}