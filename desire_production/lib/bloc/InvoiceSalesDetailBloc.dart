import 'dart:async';

import 'package:desire_production/model/InvoiceDetailModel.dart';
import 'package:desire_production/services/api_client.dart';

class InvoiceSalesDetailBloc {

  final _apiSales = ApiClient();

  final _invoiceDetailController = StreamController<InvoiceDetailModel>.broadcast();

  Stream<InvoiceDetailModel> get invoiceDetailStream => _invoiceDetailController.stream;

  fetchInvoiceDetails(String id) async {
    try {
      final results = await _apiSales.getInvoiceSalesDetail(id);
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