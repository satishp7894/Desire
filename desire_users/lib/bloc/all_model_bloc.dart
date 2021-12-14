import 'dart:async';
import 'package:desire_users/models/allModel.dart';
import 'package:desire_users/services/api_client.dart';

class AllModelBloc {

  final _apiClient = ApiClient();

  final allModelController = StreamController<AllModel>.broadcast();

  Stream<AllModel> get allModelStream => allModelController.stream;

   fetchAllModel(String customerId) async {
    try {
      final results = await _apiClient.getAllModel(customerId);
      allModelController.sink.add(results);
      print("al model response ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      allModelController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    allModelController.close();
  }

}