import 'dart:async';

import 'package:desire_users/models/invoice_model.dart';
import 'package:desire_users/models/sales_customer_list_model.dart';
import 'package:desire_users/services/api_sales.dart';



class CustomerInvoiceSalesBloc {

  final _apiClient = ApiSales();

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