import 'dart:async';

import 'package:desire_users/models/region_model.dart';
import 'package:desire_users/models/sales_report_list_model.dart';
import 'package:desire_users/models/sales_report_model.dart';
import 'package:desire_users/services/api_client.dart';
import 'package:desire_users/services/api_sales.dart';

class SalesReportBloc {
  final _apisales = ApiSales();

  final _salesReportController = StreamController<SalesReportModel>.broadcast();

  Stream<SalesReportModel> get reportStream => _salesReportController.stream;

  fetchSalesReport(String salesmn_id, String fromDate, String toDate) async {
    try {
      final results =
          await _apisales.getSalesReport(salesmn_id, fromDate, toDate);
      _salesReportController.sink.add(results);
    } on Exception catch (e) {
      print(e.toString());
      _salesReportController.sink
          .addError("something went wrong ${e.toString()}");
    }
  }

  final _salesReportListController = StreamController<SalesReportListModel>.broadcast();

  Stream<SalesReportListModel> get reportListStream => _salesReportListController.stream;
  fetchSalesReportList(String salesmn_id, String fromDate, String toDate) async {
    try {
      final results =
      await _apisales.getSalesReportList(salesmn_id, fromDate, toDate);
      _salesReportListController.sink.add(results);
    } on Exception catch (e) {
      print(e.toString());
      _salesReportListController.sink
          .addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _salesReportController.close();
    _salesReportListController.close();
  }
}
