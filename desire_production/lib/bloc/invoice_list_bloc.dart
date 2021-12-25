import 'dart:async';

import 'package:desire_production/model/invoices_list_Model.dart';
import 'package:desire_production/services/api_client.dart';

class InvoicesListBloc {
  final _apiClient = ApiClient();

  final _invoicesController = StreamController<InvoicesListModel>.broadcast();

  Stream<InvoicesListModel> get invoicesStream => _invoicesController.stream;

  fetchinvoicesList() async {
    try {
      final results = await _apiClient.getinvoicesList();
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
