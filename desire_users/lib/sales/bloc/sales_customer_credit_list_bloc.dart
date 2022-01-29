import 'dart:async';

import 'package:desire_users/models/region_model.dart';
import 'package:desire_users/models/sales_customer_credit_list_model.dart';
import 'package:desire_users/services/api_client.dart';
import 'package:desire_users/services/api_sales.dart';

class SalesCustomerCreditListBloc {
  final _apisales = ApiSales();

  final _salesCreditController = StreamController<SalesCustomerCredirListModel>.broadcast();

  Stream<SalesCustomerCredirListModel> get salesCreditStream => _salesCreditController.stream;

  fetchSalesCredit(String salemanid) async {
    try {
      final results = await _apisales.getSalesCreditList(salemanid);
      _salesCreditController.sink.add(results);
    } on Exception catch (e) {
      print(e.toString());
      _salesCreditController.sink.addError("something went wrong ${e.toString()}");
    }
  }
  dispose() {
    _salesCreditController.close();
  }
}