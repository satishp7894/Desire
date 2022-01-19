import 'dart:async';

import 'package:desire_production/model/TodayProductionModel.dart';
import 'package:desire_production/services/api_client.dart';

class TodayProductionBloc {
  final _apiClient = ApiClient();

  final _todayProductionController =
      StreamController<TodayProductionModel>.broadcast();

  Stream<TodayProductionModel> get todayProductionStream =>
      _todayProductionController.stream;

  fetchTodayProduction() async {
    print("");
    try {
      final results = await _apiClient.getTodayProduction();
      _todayProductionController.sink.add(results);
    } on Exception catch (e) {
      print(e.toString());
      _todayProductionController.sink
          .addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _todayProductionController.close();
  }
}
