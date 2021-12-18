import 'dart:async';

import 'package:desire_users/models/invoice_model.dart';
import 'package:desire_users/services/api_client.dart';

class InvoiceBloc {

  final _apiClient = ApiClient();

  final _invoiceController = StreamController<InvoiceModel>.broadcast();

  Stream<InvoiceModel> get invoiceStream => _invoiceController.stream;

  fetchInvoiceDetails(String customerId) async {
    try {
      final results = await _apiClient.getInvoiceDetails(customerId);
      _invoiceController.sink.add(results);
      print("invoice $results");
    } on Exception catch (e) {
      print(e.toString());
      _invoiceController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _invoiceController.close();
  }

}