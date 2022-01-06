import 'dart:async';

import 'package:desire_users/models/order_model.dart';
import 'package:desire_users/models/verify_gst_model.dart';
import 'package:desire_users/services/api_client.dart';


class VerifyGSTBloc {

  final _apiClient = ApiClient();

  final _verifyGSTModelController = StreamController<VerifyGSTModel>.broadcast();

  Stream<VerifyGSTModel> get verifygstStream => _verifyGSTModelController.stream;

  fetchgstDetail(String gst) async {
    try {
      final results = await _apiClient.getVerifyGST(gst);
      _verifyGSTModelController.sink.add(results);
      print("new order bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _verifyGSTModelController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _verifyGSTModelController.close();
  }

}