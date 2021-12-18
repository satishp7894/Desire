 import 'dart:async';

import 'package:desire_users/models/customerOrdersModel.dart';
import 'package:desire_users/services/api_sales.dart';

class AllCustomerOrderBloc {


   final _apiClient = ApiSales();

   final allCustomerOrderController = StreamController<CustomerOrdersModel>.broadcast();

   Stream<CustomerOrdersModel> get allCustomerOrderStream => allCustomerOrderController.stream;

   fetchAllCustomerOrders(String salesManId) async {
     try {
       final results = await _apiClient.getAllCustomerOrders(salesManId);
       allCustomerOrderController.sink.add(results);
       print("all customer order bloc $results");
     } on Exception catch (e) {
       print(e.toString());
       allCustomerOrderController.sink.addError(
           "something went wrong ${e.toString()}");
     }
   }

   dispose() {
     allCustomerOrderController.close();
   }


 }