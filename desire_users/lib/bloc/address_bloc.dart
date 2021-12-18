import 'dart:async';

import 'package:desire_users/models/address_model.dart';
import 'package:desire_users/services/api_client.dart';


class AddressBloc {

  final _apiClient = ApiClient();

  final _newAddressController = StreamController<AddressModel>.broadcast();

  Stream<AddressModel> get newAddressStream => _newAddressController.stream;

  fetchAddress(String userId) async {
    try {
      final results = await _apiClient.getAddressDetails(userId);
      _newAddressController.sink.add(results);
      print("new accessory bloc ${results.status}");
    } on Exception catch (e) {
      print(e.toString());
      _newAddressController.sink.addError(
          "something went wrong ${e.toString()}");
    }
  }

  dispose() {
    _newAddressController.close();
  }

}