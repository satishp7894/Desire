import 'dart:async';

import 'package:desire_production/model/state_model.dart';
import 'package:desire_production/services/api_client.dart';

class SelectStateBloc {
  final _apiClient = ApiClient();

  final _stateController = StreamController<StateModel>.broadcast();

  Stream<StateModel> get stateStream => _stateController.stream;

  fetchState() async {
    try {
      final results = await _apiClient.getStateList();
      _stateController.sink.add(results);
      print("new accessory bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _stateController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _stateController.close();
  }
}
