import 'dart:async';

import 'package:desire_production/model/customer_sale_chat_details.dart';
import 'package:desire_production/model/customer_sales_chat_track_model.dart';
import 'package:desire_production/model/order_model.dart';
import 'package:desire_production/pages/admin/chat/customer_sales_chat_details_page.dart';
import 'package:desire_production/services/api_client.dart';



class CustomerSalesChatBloc {

  final _apiClient = ApiClient();

  final _customerSalesChatController = StreamController<CustomerSalesChatTrackModel>.broadcast();

  Stream<CustomerSalesChatTrackModel> get customerSalesChatStream => _customerSalesChatController.stream;

  fetchCustomerSalesChatList() async {
    try {
      final results = await _apiClient.getchatlistcustomerSales();
      _customerSalesChatController.sink.add(results);
      print("new customer order bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _customerSalesChatController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  final _customerSalesChatDetailsController = StreamController<CustomerSaleChatDetailsModel>.broadcast();

  Stream<CustomerSaleChatDetailsModel> get customerSalesChatDetailsStream => _customerSalesChatDetailsController.stream;

  fetchCustomerSalesChatDetails(String convId) async {
    try {
      final results = await _apiClient.getchatDetailscustomerSales(convId);
      _customerSalesChatDetailsController.sink.add(results);
      print("new customer order bloc $results");
    } on Exception catch (e) {
      print(e.toString());
      _customerSalesChatDetailsController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _customerSalesChatController.close();
  }

}