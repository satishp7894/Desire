import 'dart:async';
import 'package:desire_production/model/user_model.dart';
import 'package:desire_production/services/api_client.dart';




class SalesmanListBloc {

  final _apiClient = ApiClient();

  final _salesmanController = StreamController<UserModel>.broadcast();

  Stream<UserModel> get salesmanStream => _salesmanController.stream;

  fetchSalesmanList() async {
    try {
      final results = await _apiClient.getSalesmanList();
      _salesmanController.sink.add(results);
      print("new customer bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _salesmanController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _salesmanController.close();
  }

}