import 'dart:async';
import 'package:desire_users/models/transport_list_model.dart';
import 'package:desire_users/services/api_client.dart';

class TransportListBloc {

  final _apiClient = ApiClient();

  final _transportListController = StreamController<TransportListModel>.broadcast();

  Stream<TransportListModel> get transportListStream => _transportListController.stream;

  fetchTransportList(String customerId) async {
    print("");
    try {
      final results = await _apiClient.getTransportList(customerId);
      _transportListController.sink.add(results);
    } on Exception catch (e) {
      print(e.toString());
      _transportListController.sink.addError("something went wrong ${e.toString()}");
    }
  }
  dispose() {
    _transportListController.close();
  }
}