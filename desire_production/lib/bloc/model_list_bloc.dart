import 'dart:async';
import 'package:desire_production/model/modelList_model.dart';
import 'package:desire_production/model/model_listing_model.dart';
import 'package:desire_production/services/api_client.dart';


class ModelListBloc {

  final _apiClient = ApiClient();

  final _modelController = StreamController<ModelListModel>.broadcast();

  Stream<ModelListModel> get productStream => _modelController.stream;

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


  final _apiClient1 = ApiClient();

  final _modelController1 = StreamController<ModelListingModel>.broadcast();

  Stream<ModelListingModel> get productStream1 => _modelController1.stream;

  fetchModelList1() async {
    try {
      final results = await _apiClient1.getModelList1();
      _modelController1.sink.add(results);
      print("model bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _modelController1.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _modelController.close();
    _modelController1.close();
  }

}