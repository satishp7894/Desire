import 'dart:async';
import 'package:desire_production/model/todays_list_model.dart';
import 'package:desire_production/model/user_model.dart';
import 'package:desire_production/services/api_client.dart';

class TodayListBloc {
  final _apiClient = ApiClient();

  final _todaysController = StreamController<TodaysListModel>.broadcast();

  Stream<TodaysListModel> get todaysStream => _todaysController.stream;

  fetchTodayList() async {
    try {
      final results = await _apiClient.getTodayList();
      _todaysController.sink.add(results);
      print("new customer bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _todaysController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _todaysController.close();
  }
}
