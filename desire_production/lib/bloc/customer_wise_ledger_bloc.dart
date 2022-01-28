import 'dart:async';

import 'package:desire_production/model/LedgerModel.dart';
import 'package:desire_production/model/customerwiseledger.dart';
import 'package:desire_production/services/api_client.dart';



class CustomerWiseLedgerBloc {

  final _apiClient = ApiClient();

  final _ledgerController = StreamController<CustomerWiseLedger>.broadcast();

  Stream<CustomerWiseLedger> get ledgerStream => _ledgerController.stream;

  fetchLedger(String customerId, String fromDateinput, String toDateinput) async {
    try {
      final results = await _apiClient.getCustomerWiseLedger(customerId, fromDateinput, toDateinput);
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