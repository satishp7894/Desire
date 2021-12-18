import 'dart:async';

import 'package:desire_production/model/warehouse_list_model.dart';
import 'package:desire_production/services/api_client.dart';

class WarhouseListBloc {

  final _apiClient = ApiClient();

  final _warehouseController = StreamController<WareHouseListModel>.broadcast();

  Stream<WareHouseListModel> get warhouseStream => _warehouseController.stream;

  fetchWarehouseList() async {
    try {
      final results = await _apiClient.getWareHouseList();
      _warehouseController.sink.add(results);
      print("ware bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _warehouseController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _warehouseController.close();
  }

}