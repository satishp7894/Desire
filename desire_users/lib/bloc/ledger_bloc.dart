import 'dart:async';

import 'package:desire_users/models/ledger_model.dart';
import 'package:desire_users/models/product_model.dart';
import 'package:desire_users/services/api_client.dart';


class LedgerBloc {

  final _apiClient = ApiClient();

  final _ledgerController = StreamController<LedgerModel>.broadcast();

  Stream<LedgerModel> get ledgerStream => _ledgerController.stream;

  fetchLedger(String customerId) async {
    try {
      final results = await _apiClient.getLedgerDetails(customerId);
      _ledgerController.sink.add(results);
      print("new accessory bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _ledgerController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _ledgerController.close();
  }

}