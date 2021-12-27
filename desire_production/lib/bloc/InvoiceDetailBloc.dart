import 'dart:async';

import 'package:desire_production/model/InvoiceDetail.dart';
import 'package:desire_production/model/invoices_list_Model.dart';
import 'package:desire_production/services/api_client.dart';

class InvoiceDetailBloc {
  final _apiClient = ApiClient();

  final _invoicesController = StreamController<InvoiceDetail>.broadcast();

  Stream<InvoiceDetail> get invoicesStream => _invoicesController.stream;

  fetchinvoicesDetail(String id) async {
    try {
      final results = await _apiClient.getInvoiceDetail(id);
      _invoicesController.sink.add(results);
      print("invoices bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _invoicesController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _invoicesController.close();
  }
}
