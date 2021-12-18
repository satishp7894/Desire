import 'dart:async';
import 'package:desire_users/models/customer_price_listing_model.dart';
import 'package:desire_users/services/api_sales.dart';



class CustomerPriceListingBloc {

  final _apiClient = ApiSales();

  final _customerPriceListController = StreamController<CustomerPriceListModel>.broadcast();

  Stream<CustomerPriceListModel> get customerPriceListStream => _customerPriceListController.stream;

  fetchCustomerPriceList(String customerId) async {
    try {
      final results = await _apiClient.getCustomerPriceList(customerId);
      _customerPriceListController.sink.add(results);
      print("new accessory bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _customerPriceListController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _customerPriceListController.close();
  }

}