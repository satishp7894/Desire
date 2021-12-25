import 'dart:async';

import 'package:desire_production/model/complaint_detail_model.dart';
import 'package:desire_production/model/customer_complaint_list_model.dart';
import 'package:desire_production/model/customer_list_for_chat_model.dart';
import 'package:desire_production/services/api_client.dart';

class ComplaintDetialBloc {

  final _apiClient = ApiClient();

  final _complaintDetailModelController = StreamController<ComplaintDetailModel>.broadcast();

  Stream<ComplaintDetailModel> get customerComplaintDetailStream => _complaintDetailModelController.stream;

  fetchComplaintDetail(String id) async {
    try {
      final results = await _apiClient.getCustomerComplaintDetail(id);
      _complaintDetailModelController.sink.add(results);
      print("customer chat list ${results.complaintDetails}");
    } on Exception catch (e) {
      print(e.toString());
      _complaintDetailModelController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _complaintDetailModelController.close();
  }

}