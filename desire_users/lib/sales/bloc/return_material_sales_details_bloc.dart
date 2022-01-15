import 'dart:async';

import 'package:desire_users/models/return_material_detail_sales_model.dart';
import 'package:desire_users/models/return_material_sale_model.dart';
import 'package:desire_users/services/api_sales.dart';


class ReturnMaterialSalesDetailsBloc {

  final _apiSales = ApiSales();

  final _returnMaterialDetailsController = StreamController<ReturnMaterialDetailSalesModel>.broadcast();

  Stream<ReturnMaterialDetailSalesModel> get returnMaterialDetailStream => _returnMaterialDetailsController.stream;

  fetchReturnmaterialList(String materialId) async {
    try {
      final results = await _apiSales.getretunmaterialDetail(materialId);
      _returnMaterialDetailsController.sink.add(results);
      print(" bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _returnMaterialDetailsController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _returnMaterialDetailsController.close();
  }

}