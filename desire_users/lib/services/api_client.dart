import 'dart:convert';
import 'dart:io';
import 'package:desire_users/models/address_model.dart';
import 'package:desire_users/models/allModel.dart';
import 'package:desire_users/models/cart_model.dart';
import 'package:desire_users/models/category_model.dart';
import 'package:desire_users/models/customer_chat_details_model.dart';
import 'package:desire_users/models/customer_chat_list_model.dart';
import 'package:desire_users/models/invoice_model.dart';
import 'package:desire_users/models/kyc_view_model.dart';
import 'package:desire_users/models/modelNumberFromCategoryModel.dart';
import 'package:desire_users/models/orderDetailsByIdModel.dart';
import 'package:desire_users/models/order_model.dart';
import 'package:desire_users/models/order_track_model.dart';
import 'package:desire_users/models/productFromModelNoModel.dart';
import 'package:desire_users/models/product_details_model.dart';
import 'package:desire_users/models/product_model.dart';
import 'package:desire_users/models/ready_stock_list_model.dart';
import 'package:desire_users/models/today_production_model.dart';
import 'package:desire_users/models/transport_list_model.dart';
import 'package:desire_users/models/userSearchingModel.dart';
import 'package:desire_users/models/wishlist_model.dart';
import 'package:desire_users/services/connection_sales.dart';
import 'package:http_parser/http_parser.dart';
import 'package:desire_users/models/kyc_model.dart';
import 'package:desire_users/models/region_model.dart';
import 'package:desire_users/services/connection.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {



  Future<RegionModel> getRegions(String url) async {
    var response = await http.get(Uri.parse(url));
    var result = json.decode(response.body);

    RegionModel regionModel;

    regionModel = (RegionModel.fromJson(result));
    print("object ${regionModel.message}");
    return regionModel;
  }

  Future<KycModel> getKYCDetails() async {
    var response = await http.post(Uri.parse(Connection.getKYC), body: {
      "secretkey" : Connection.secretKey
    });
    var result = json.decode(response.body);
    print("kyc response $result");


    KycModel _cfsPerformance;
    _cfsPerformance = (KycModel.fromJson(result));
    print("ifc Performance $_cfsPerformance");

    return _cfsPerformance;
  }

  Future<String> updateProfilePhoto(File photo, String user, String kycId, String kycNo) async {
    print("object inside upload ${photo.path}");
    var request = http.MultipartRequest(
        "POST", Uri.parse(Connection.uploadKYC));
    request.fields['secretkey'] = '${Connection.secretKey}';
    request.fields['user_id'] = user;
    request.fields['kyc_id'] = kycId;
    request.fields['number'] = kycNo;
    request.files.add(await http.MultipartFile.fromPath('image', photo.path,
        filename: 'photo$kycId.jpg', contentType: MediaType('image', 'jpeg')));
    final streamResponse = await request.send();
    print("object ${streamResponse.statusCode}");
    print("object response ${streamResponse.statusCode} ${streamResponse.request}");
    if (streamResponse.statusCode >= 200 && streamResponse.statusCode <= 299) {
      final http.Response response = await http.Response.fromStream(streamResponse);
      final results = json.decode(response.body);
      if (results['status'] == true) {
        return results['data'];
      } else {
        return null;
      }
    } else {
      return "false";
      //Alerts.showAlertAndBack(context, "Error uploading data", "try again");
    }
  }

  Future<ProductDetailModel> getProductDetails(String productID,String customerId) async {
    var response = await http.post(Uri.parse(Connection.productDetails), body: {
      "secretkey" : Connection.secretKey,
      "product_id" : productID,
      "customer_id": customerId,
    });
    var result = json.decode(response.body);
    print("new product response $result");


    ProductDetailModel productDetailModel;
    productDetailModel = (ProductDetailModel.fromJson(result));
    print("new product api $productDetailModel");

    return productDetailModel;
  }

  Future<ProductModel> getNewProductDetails(String customerId) async {
    var response = await http.post(Uri.parse(Connection.newProduct), body: {
      "secretkey" : Connection.secretKey,
      "customer_id":customerId
    });
    var result = json.decode(response.body);
    print("new product response $result");


    ProductModel _productModel;
    _productModel = (ProductModel.fromJson(result));
    print("new product api $_productModel");

    return _productModel;
  }



  Future<ModelNoFromCategoryModel> getModelFromCategory(String categoryId) async {
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/UserApiController/categoryWiseModelNo"), body: {
      "secretkey" : r"12!@34#$5%",
      "category_id": categoryId
    });
    var result = json.decode(response.body);
    print("model from category  response $result");


    ModelNoFromCategoryModel modelNoFromCategoryModel;
    modelNoFromCategoryModel = (ModelNoFromCategoryModel.fromJson(result));
    print("model from category api $modelNoFromCategoryModel");

    return modelNoFromCategoryModel;
  }

  Future<AllModel> getAllModel(String customerId) async {
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/UserApiController/allModelNo"), body: {
      "secretkey" : r"12!@34#$5%",
      "customer_id": customerId
    });
    var result = json.decode(response.body);
    print("all  model api  response $result");
    AllModel allModel;
    allModel = (AllModel.fromJson(result));
    print("all model api $allModel");

    return allModel;
  }

  Future<CustomerChatDetailsModel> getCustomerChatDetails(String customerId , String receiverId) async {
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/UserApiController/customerChatDetails"), body: {
      "secretkey" : r"12!@34#$5%",
      "customer_id": customerId,
      "receiver_id": receiverId,

    });
    var result = json.decode(response.body);
    print("all  model api  response $result");
    CustomerChatDetailsModel customerChatDetailsModel;
    customerChatDetailsModel = (CustomerChatDetailsModel.fromJson(result));
    print("customerChatDetailsModel  api $customerChatDetailsModel");
    if(response.statusCode == 200){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("conversationId", result["conversation_id"]);
    }
    else {

    }

    return customerChatDetailsModel;
  }


  Future<CustomerChatListModel> getCustomerChatList(String customerId) async {
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/UserApiController/customerChatList"),
        body: {
      "secretkey" : r"12!@34#$5%",
      "customer_id": customerId
    });
    var result = json.decode(response.body);
    print("customerChatList  response $result");
    CustomerChatListModel customerChatListModel;
    customerChatListModel = (CustomerChatListModel.fromJson(result));
    print("customerChatListModel api $customerChatListModel");

    return customerChatListModel;
  }

  Future<ReadyStockListModel> getReadyStockList() async {
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/UserApiController/readyStockList"),
    body: {
      "secretkey" : r"12!@34#$5%",
    }
    );
    var result = json.decode(response.body);
    print("all  ready stock api  response $result");
    ReadyStockListModel readyStockListModel;
    readyStockListModel = (ReadyStockListModel.fromJson(result));
    print("readyStockListModel api $readyStockListModel");

    return readyStockListModel;
  }

  Future<TodayProductionModel> getTodayProduction() async {
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/UserApiController/todaysProduction"),
    body: {
      "secretkey" : r"12!@34#$5%",
    }
    );
    var result = json.decode(response.body);
    print("today production api  response $result");
    TodayProductionModel todayProductionModel;
    todayProductionModel = (TodayProductionModel.fromJson(result));
    print("todayProductionModel api $todayProductionModel");

    return todayProductionModel;
  }


  Future<UserSearchingModel> getSearch(String customerId,String searchKeyword) async {
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/UserApiController/searching"), body: {
      "secretkey" : r"12!@34#$5%",
      "customer_id": customerId,
      "search_keyword": searchKeyword
    });
    var result = json.decode(response.body);
    print("all  model api  response $result");
    UserSearchingModel userSearchingModel;
    userSearchingModel = (UserSearchingModel.fromJson(result));
    print("user searching  api $userSearchingModel");

    return userSearchingModel;
  }

  Future<ProductFromModelNoModel> getProductFromModelNo(String modelNoId,String customerId) async {
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/UserApiController/modelNoWiseProductList"), body: {
      "secretkey" : r"12!@34#$5%",
      "model_no_id": modelNoId,
      "customer_id": customerId
    });
    var result = json.decode(response.body);
    print("product from model  response $result");


    ProductFromModelNoModel productFromModelNoModel;
    productFromModelNoModel = (ProductFromModelNoModel.fromJson(result));
    print("product from model api $productFromModelNoModel");

    return productFromModelNoModel;
  }

  Future<ProductModel> getAllProductDetails(String customerId) async {
    var response = await http.post(Uri.parse(Connection.allProductDetails), body: {
      "secretkey" : Connection.secretKey,
      "customer_id": customerId
    });
    var result = json.decode(response.body);
    print("new product response $result");


    ProductModel _productModel;
    _productModel = (ProductModel.fromJson(result));
    print("new product api $_productModel");

    return _productModel;
  }

  Future<ProductModel> getBestProductDetails( String customerId ) async {
    var response = await http.post(Uri.parse(Connection.bestProduct), body: {
      "secretkey" : Connection.secretKey,
      "customer_id": customerId

    });
    var result = json.decode(response.body);
    print("best product response $result");


    ProductModel _productModel;
    _productModel = (ProductModel.fromJson(result));
    print("best product api $_productModel");

    return _productModel;
  }

  Future<ProductModel> getFutureProductDetails(String customerId ) async {
    var response = await http.post(Uri.parse(Connection.futureProduct), body: {
      "secretkey" : Connection.secretKey,
      "customer_id": customerId

    });
    var result = json.decode(response.body);
    print("future product response $result");


    ProductModel _productModel;
    _productModel = (ProductModel.fromJson(result));
    print("future product api $_productModel");

    return _productModel;
  }

  Future<ProductModel> getAccessoryDetails(String customerId )async {
    var response = await http.post(Uri.parse(Connection.accessory), body: {
      "secretkey" : Connection.secretKey,
      "customer_id": customerId

    });
    var result = json.decode(response.body);
    print("AccessoryModel product response $result");


    ProductModel _accessModel;
    _accessModel = (ProductModel.fromJson(result));
    print("future product api $_accessModel");

    return _accessModel;
  }

  Future<ProductModel> getCategoryWiseProductDetails(String id, String customerId) async {

    print("object string $id");
    var response = await http.post(Uri.parse(Connection.categoryWiseList), body: {
      "secretkey" : Connection.secretKey,
      "category_id" : id,
      "customer_id": customerId

    });
    var result = json.decode(response.body);
    print("category product response $result");


    ProductModel _productModel;
    _productModel = (ProductModel.fromJson(result));
    print("category product api ${_productModel.status}");

    return _productModel;
  }

  Future<ProductModel> getSearchProductDetails(String search,String customerId) async {
    print("object string $search");
    var response = await http.post(Uri.parse(Connection.searchProduct), body: {
      "secretkey" : Connection.secretKey,
      "search_keyword" : search,
      "customer_id": customerId
    });
    var result = json.decode(response.body);
    print("search product response $result");


    ProductModel _productModel;
    _productModel = (ProductModel.fromJson(result));
    print("search product api ${_productModel.status}");

    return _productModel;
  }

  Future<ProductModel> getSearchAccessoriesDetails(String search,String customerId) async {
    print("object string $search");
    var response = await http.post(Uri.parse(Connection.searchAccessories), body: {
      "secretkey" : Connection.secretKey,
      "search_keyword" : search,
      "customer_id": customerId
    });
    var result = json.decode(response.body);
    print("search product response $result");


    ProductModel _accModel;
    _accModel = (ProductModel.fromJson(result));
    print("search product api ${_accModel.status}");

    return _accModel;
  }

  Future<CategoryModel> getCategoryDetails(String customerId) async {
    var response = await http.post(Uri.parse(Connection.categoryList), body: {
      "secretkey" : Connection.secretKey,
      "customer_id": customerId
    });
    var result = json.decode(response.body);
    print("category  response $result");


    CategoryModel _catModel;
    _catModel = (CategoryModel.fromJson(result));
    print("category api $_catModel");

    return _catModel;
  }

  Future<KycViewModel> getKYCViewDetails(String userId) async {
    var response = await http.post(Uri.parse(Connection.getKYCDetails), body: {
      "secretkey" : Connection.secretKey,
      "user_id" : userId
    });
    var result = json.decode(response.body);
    print("kyc view response $result");


    KycViewModel kycViewModel;
    kycViewModel = (KycViewModel.fromJson(result));
    print("kycViewModel Performance $kycViewModel");

    return kycViewModel;
  }

  Future<AddressModel> getAddressDetails(String userId) async {

    print("object userid $userId");

    var response = await http.post(Uri.parse(Connection.addressList ), body: {
      "secretkey" : Connection.secretKey,
      "customer_id" : userId
    });
    var result = json.decode(response.body);
    print("address response $result");


    AddressModel addressModel;
    addressModel = (AddressModel.fromJson(result));
    print("kycViewModel Performance $addressModel");

    return addressModel;
  }





  Future<CartModel> getCartDetails(String userId) async {

    print("object userid $userId");

    var response = await http.post(Uri.parse(Connection.cartDetails ), body: {
      "secretkey" : Connection.secretKey,
      "customer_id" : userId
    });

    var result = json.decode(response.body);
    print("cart list response $result");
    print("cart list response ${result['message']}");



    CartModel cartModel;
    cartModel = CartModel.fromJson(result);
    print("cartmodel Performance $cartModel");

    return cartModel;
  }

  Future<OrderModel> getOrderDetails(String customerId) async {

    var response = await http.post(Uri.parse(Connection.orderHistory ), body: {
      "secretkey" : Connection.secretKey,
      "customer_id" : customerId
    });

    var result = json.decode(response.body);
    print("order list response $result");
    print("order list response ${result['message']}");



    OrderModel orderModel;
    orderModel = OrderModel.fromJson(result);
    print("order model Performance $orderModel");

    return orderModel;
  }

  Future<OrderDetailsByIdModel> getOrderDetailsById(String orderId) async {

    var response = await http.post(Uri.parse(ConnectionSales.productListByOrder ), body: {
      "secretkey" : Connection.secretKey,
      "orderid" : orderId
    });

    var result = json.decode(response.body);
    print("order list response $result");
    print("order list response ${result['message']}");



    OrderDetailsByIdModel orderDetailsByIdModel;
    orderDetailsByIdModel = OrderDetailsByIdModel.fromJson(result);
    print("order model Performance $orderDetailsByIdModel");

    return orderDetailsByIdModel;
  }

  Future<WishListModel> getWishList(String userId) async {

    print("object userid $userId");

    var response = await http.post(Uri.parse(Connection.getWishList ), body: {
      "secretkey" : Connection.secretKey,
      "customerid" : userId
    });

    var result = json.decode(response.body);
    print("order list response $result");
    print("order list response ${result['message']}");



    WishListModel wishListModel;
    wishListModel = WishListModel.fromJson(result);
    print("wishlist model Performance $wishListModel");

    return wishListModel;
  }


  Future<InvoiceModel> getInvoiceDetails(String customerId) async {

    print("object userid $customerId");

    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/UserApiController/customerInvoiceList"), body: {
      "secretkey" : r"12!@34#$5%",
      "customer_id" : customerId
    });

    var result = json.decode(response.body);
    print("order list response $result");
    print("order list response ${result['message']}");



    InvoiceModel invoiceModel;
    invoiceModel = InvoiceModel.fromJson(result);
    print("wishlist model Performance $invoiceModel");

    return invoiceModel;
  }

  Future<TransportListModel> getTransportList(String customerId) async {

    print("customer id : $customerId");

    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/UserApiController/customerTransportList"), body: {
      "secretkey" : r"12!@34#$5%",
      "customer_id" : customerId
    });

    var result = json.decode(response.body);
    print("order list response $result");
    print("order list response ${result['message']}");



    TransportListModel transportListModel;
    transportListModel = TransportListModel.fromJson(result);
    print("transportListModel $transportListModel");

    return transportListModel;
  }
  
  Future<OrderTrackModel> getOrderTracking(String orderId, String trackId) async {

    print("object userid $orderId");

    var response = await http.post(Uri.parse(Connection.orderTracking), body: {
      "secretkey" : Connection.secretKey,
      "orderdetail_id" : orderId,
      "tracknumber" : trackId,
    });

    var result = json.decode(response.body);
    print("order list response $result");

    OrderTrackModel orderTrackModel;
    orderTrackModel = OrderTrackModel.fromJson(result);
    print("wishlist model Performance $orderTrackModel");

    return orderTrackModel;
  }

}