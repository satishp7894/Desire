import 'dart:async';

import 'package:desire_production/model/modelNoWiseListModel.dart';
import 'package:desire_production/services/api_client.dart';

class ModelWiseListBloc {
  final _apiClient = ApiClient();

  final modelWiseDailyOrdersListController =
      StreamController<ModelNoWiseListModel>.broadcast();

  Stream<ModelNoWiseListModel> get modelWiseDailyOrdersListStream =>
      modelWiseDailyOrdersListController.stream;

  fetchModelWiseDailyOrderList(var modelNoId) async {
    try {
      final results = await _apiClient.getModelWiseDailyOrdersList(modelNoId);
      modelWiseDailyOrdersListController.sink.add(results);
      print("model bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      modelWiseDailyOrdersListController.sink
          .addError("something went wrong ${e.toString()}");
    }
  }

  final modelWiseDailyProductionListController =
      StreamController<ModelNoWiseListModel>.broadcast();

  Stream<ModelNoWiseListModel> get modelWiseDailyProductionListStream =>
      modelWiseDailyOrdersListController.stream;

  fetchModelWiseProductionOrderList(var modelNoId) async {
    try {
      final results =
          await _apiClient.getModelWiseDailyProductionList(modelNoId);
      modelWiseDailyOrdersListController.sink.add(results);
      print("model bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      modelWiseDailyOrdersListController.sink
          .addError("something went wrong ${e.toString()}");
    }
  }

  final modelWiseDailyDetailsController =
      StreamController<ModelNoWiseListModel>.broadcast();

  Stream<ModelNoWiseListModel> get modelWiseDailyDetailsStream =>
      modelWiseDailyDetailsController.stream;

  fetchModelWiseDailyOrderDetails(var modelNoId) async {
    try {
      final results =
          await _apiClient.getModelWiseDailyProductionList(modelNoId);
      modelWiseDailyDetailsController.sink.add(results);
      print("model bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      modelWiseDailyDetailsController.sink
          .addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    modelWiseDailyOrdersListController.close();
    modelWiseDailyProductionListController.close();
    modelWiseDailyDetailsController.close();
  }
}
