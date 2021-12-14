import 'dart:async';
import 'package:desire_users/models/modelList_model.dart';
import 'package:desire_users/services/api_client.dart';
import 'package:desire_users/services/api_sales.dart';


class ModelListBloc {

  final _apiClient = ApiSales();

  final _modelController = StreamController<ModelListModel>.broadcast();

  Stream<ModelListModel> get modelListStream => _modelController.stream;

  fetchModelList(String customerId) async {
    try {
      final results = await _apiClient.getModelList(customerId);
      _modelController.sink.add(results);
      print("model bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _modelController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _modelController.close();
  }

}