import 'dart:async';

import 'package:desire_production/model/InvoiceDetail.dart';
import 'package:desire_production/model/invoices_list_Model.dart';
import 'package:desire_production/model/kyc_pending_list_model.dart';
import 'package:desire_production/model/order_approve_pending_model.dart';
import 'package:desire_production/services/api_client.dart';

class OrderApprovePendingBloc {
  final _apiClient = ApiClient();

  final _ordeController = StreamController<OrderApprovePendingModel>.broadcast();

  Stream<OrderApprovePendingModel> get ordeStream => _ordeController.stream;

  fetchorderPendingList() async {
    try {
      final results = await _apiClient.getAllorderPending();
      _ordeController.sink.add(results);
      print("invoices bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _ordeController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _ordeController.close();
  }
}
