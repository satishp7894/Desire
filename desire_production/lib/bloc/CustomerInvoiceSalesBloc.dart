import 'dart:async';

import 'package:desire_production/model/InvoiceModel.dart';
import 'package:desire_production/services/api_client.dart';



class CustomerInvoiceSalesBloc {

  final _apiClient = ApiClient();

  final _invoicelistController = StreamController<InvoiceModel>.broadcast();

  Stream<InvoiceModel> get invoiceListStream => _invoicelistController.stream;

  fetchsaleInvoiceList(String salesId) async {
    try {
      final results = await _apiClient.getInvoiceListSales(salesId);
      _invoicelistController.sink.add(results);
      print("new customer bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _invoicelistController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _invoicelistController.close();
  }

}