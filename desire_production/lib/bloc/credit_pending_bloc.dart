import 'dart:async';

import 'package:desire_production/model/InvoiceDetail.dart';
import 'package:desire_production/model/invoices_list_Model.dart';
import 'package:desire_production/model/kyc_pending_list_model.dart';
import 'package:desire_production/services/api_client.dart';

class CreditPendingBloc {
  final _apiClient = ApiClient();

  final _creditController = StreamController<KycPendingListModel>.broadcast();

  Stream<KycPendingListModel> get creditStream => _creditController.stream;

  fetchcreditPendingList() async {
    try {
      final results = await _apiClient.getCreditPending();
      _creditController.sink.add(results);
      print("invoices bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _creditController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _creditController.close();
  }
}
