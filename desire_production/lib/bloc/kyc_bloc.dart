import 'dart:async';

import 'package:desire_production/model/kyc_model.dart';
import 'package:desire_production/model/kyc_view_model.dart';
import 'package:desire_production/services/api_client.dart';




class KYCBloc {

  final _apiClient1 = ApiClient();

  final _kycController = StreamController<KycModel>.broadcast();

  Stream<KycModel> get kycStream => _kycController.stream;

  fetchKyc() async {
    try {
      final results = await _apiClient1.getKYCDetails();
      _kycController.sink.add(results);
      print("kyc bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _kycController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  final _kycViewController = StreamController<KycViewModel>.broadcast();

  Stream<KycViewModel> get kycViewStream => _kycViewController.stream;

  fetchKycView(String userId) async {
    try {
      final results = await _apiClient1.getKYCViewDetails(userId);
      _kycViewController.sink.add(results);
      print("kyc bloc ${results.status}");

    } on Exception catch (e) {
      print(e.toString());
      _kycViewController.sink.addError("something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _kycController.close();
    _kycViewController.close();
  }

}