import 'dart:async';

import 'package:desire_users/models/cart_model.dart';
import 'package:desire_users/models/invoice_detail_model.dart';
import 'package:desire_users/services/api_client.dart';

class InvoiceDetailBloc {

  final _apiClient = ApiClient();

  final _invoiceDetailController = StreamController<InvoiceDetailModel>.broadcast();

  Stream<InvoiceDetailModel> get invoiceDetailStream => _invoiceDetailController.stream;

  fetchInvoiceDetails(String id) async {
    try {
      final results = await _apiClient.getInvoiceviseDetail(id);
      _invoiceDetailController.sink.add(results);
      print("new cart bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _invoiceDetailController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _invoiceDetailController.close();
  }

}