import 'dart:async';

import 'package:desire_production/model/InvoiceDetail.dart';
import 'package:desire_production/model/invoices_list_Model.dart';
import 'package:desire_production/model/kyc_pending_list_model.dart';
import 'package:desire_production/services/api_client.dart';

class KYCPendingBloc {
  final _apiClient = ApiClient();

  final _kycController = StreamController<KycPendingListModel>.broadcast();

  Stream<KycPendingListModel> get kycStream => _kycController.stream;

  fetchkycPendingList() async {
    try {
      final results = await _apiClient.getKycPending();
      _kycController.sink.add(results);
      print("invoices bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _kycController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _kycController.close();
  }
}
