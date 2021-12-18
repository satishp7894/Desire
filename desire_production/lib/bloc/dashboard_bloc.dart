import 'dart:async';

import 'package:desire_production/model/dashboard_count_model.dart';
import 'package:desire_production/services/api_client.dart';


class DashboardBloc {

  final _apiClient = ApiClient();

  final _dashController = StreamController<DashboardCountModel>.broadcast();

  Stream<DashboardCountModel> get dashStream => _dashController.stream;

  fetchDashboardCount() async {
    try {
      final results = await _apiClient.getDashboardCount();
      _dashController.sink.add(results);
      print("new accessory bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _dashController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _dashController.close();
  }

}