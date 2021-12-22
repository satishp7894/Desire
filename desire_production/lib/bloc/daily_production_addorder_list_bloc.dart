import 'dart:async';

import 'package:desire_production/model/dailyProductionAddlistModel.dart';
import 'package:desire_production/services/api_client.dart';

class DailyProductionAddOrderListBloc {

  final _apiClient = ApiClient();

  final _dailyProductionaddListController = StreamController<DailyProductionAddlistModel>.broadcast();

  Stream<DailyProductionAddlistModel> get dailyProductionAddListStream => _dailyProductionaddListController.stream;

  fetchDailyProductionAddList() async {
    try {
      final results = await _apiClient.getDailyProductionaddmodelList();
      _dailyProductionaddListController.sink.add(results);
      print("daily production list bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _dailyProductionaddListController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _dailyProductionaddListController.close();
  }

}