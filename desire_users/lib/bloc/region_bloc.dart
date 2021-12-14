import 'dart:async';

import 'package:desire_users/models/region_model.dart';
import 'package:desire_users/services/api_client.dart';

class RegionBloc {
  final _apiclient = ApiClient();

  final _regionController = StreamController<RegionModel>.broadcast();

  Stream<RegionModel> get regionStream => _regionController.stream;

  fetchRegions(String url) async {
    print("object url $url");
    try {
      final results = await _apiclient.getRegions(url);
      _regionController.sink.add(results);
    } on Exception catch (e) {
      print(e.toString());
      _regionController.sink.addError("something went wrong ${e.toString()}");
    }
  }
  dispose() {
    _regionController.close();
  }
}