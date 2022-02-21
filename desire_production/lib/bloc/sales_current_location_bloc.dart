import 'dart:async';

import 'package:desire_production/model/product_list_order_model.dart';
import 'package:desire_production/model/sales_location_model.dart';
import 'package:desire_production/services/api_client.dart';



class SalesCurrentLocationBloc {

  final _apiClient = ApiClient();

  final _locaionController = StreamController<SalesLocationModel>.broadcast();

  Stream<SalesLocationModel> get locationStream => _locaionController.stream;

  fetchLocation(String salesId) async {
    try {
      final results = await _apiClient.getSalesLocation(salesId);
      _locaionController.sink.add(results);
      print("location bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _locaionController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _locaionController.close();
  }

}