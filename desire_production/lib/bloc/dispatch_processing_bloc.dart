import 'dart:async';
import 'package:desire_production/model/dispatch_processing_model.dart';
import 'package:desire_production/services/api_client.dart';


class DispatchProcessingBloc {

  final _apiClient = ApiClient();

  final _dispatchProcessingController = StreamController<DispatchProcessingModel>.broadcast();

  Stream<DispatchProcessingModel> get dispatchProcessStream => _dispatchProcessingController.stream;

  fetchDispatchProcessing(String warehouseKey, String productId, String warehouseId) async {
    try {
      final results = await _apiClient.getDispatchProcessing(warehouseKey, productId, warehouseId);
      _dispatchProcessingController.sink.add(results);
      print("dispatch bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _dispatchProcessingController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _dispatchProcessingController.close();
  }

}