import 'dart:async';

import 'package:desire_users/models/return_material_sale_model.dart';
import 'package:desire_users/services/api_sales.dart';


class ReturnMaterialSaleBloc {

  final _apiSales = ApiSales();

  final _returnMaterialController = StreamController<ReturnMaterialSaleModel>.broadcast();

  Stream<ReturnMaterialSaleModel> get returnMaterialStream => _returnMaterialController.stream;

  fetchReturnmaterialList(String salesId) async {
    try {
      final results = await _apiSales.getretunmaterialList(salesId);
      _returnMaterialController.sink.add(results);
      print(" bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _returnMaterialController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _returnMaterialController.close();
  }

}