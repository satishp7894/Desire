import 'dart:async';
import 'package:desire_users/models/productFromModelNoModel.dart';
import 'package:desire_users/models/readyStockModel.dart';
import 'package:desire_users/services/api_client.dart';

class ReadyStockModelBloc {

  final _apiClient = ApiClient();

  final readyproductFromModelController = StreamController<ReadyStockModel>.broadcast();

  Stream<ReadyStockModel> get readyproductFromModelStream => readyproductFromModelController.stream;

  fetchReadyProductFromModel(String modelNoId, String customerId) async {
    try {
      final results = await _apiClient.getReadyProductFromModelNo(modelNoId,customerId);
      readyproductFromModelController.sink.add(results);
      print("category bloc response ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      readyproductFromModelController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    readyproductFromModelController.close();
  }

}