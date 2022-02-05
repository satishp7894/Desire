import 'dart:convert';

import 'package:desire_users/models/credit_list_model.dart';
import 'package:desire_users/models/customerOrdersModel.dart';
import 'package:desire_users/models/customer_price_listing_model.dart';
import 'package:desire_users/models/hold_orders_model.dart';
import 'package:desire_users/models/invoice_detail_model.dart';
import 'package:desire_users/models/invoice_model.dart';
import 'package:desire_users/models/invoice_sale_detail_model.dart';
import 'package:desire_users/models/modelList_model.dart';
import 'package:desire_users/models/new_customer_list_model.dart';
import 'package:desire_users/models/orderDetailsByIdModel.dart';
import 'package:desire_users/models/order_model.dart';
import 'package:desire_users/models/pending_order_list_model.dart';
import 'package:desire_users/models/product_list_order_model.dart';
import 'package:desire_users/models/return_material_detail_sales_model.dart';
import 'package:desire_users/models/return_material_sale_model.dart';
import 'package:desire_users/models/sales_chat_detail_model.dart';
import 'package:desire_users/models/sales_chat_list_model.dart';
import 'package:desire_users/models/sales_customer_credit_list_model.dart';
import 'package:desire_users/models/sales_customer_list_model.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/services/connection_sales.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiSales{

  String salesId;
  SharedPreferences sharedPreferences;


  Future<SalesCustomerModel> getCustomerListDetails() async {
    sharedPreferences = await SharedPreferences.getInstance();
    salesId = sharedPreferences.getString("sales_id");
    var response = await http.post(Uri.parse(ConnectionSales.getCustomerList), body: {
      "secretkey" : ConnectionSales.secretKey,
      "sales_user_id": salesId
    });
    var result = json.decode(response.body);
    print("customer lis† response $result ${result['status']}");


    SalesCustomerModel _userModel;
    _userModel = SalesCustomerModel.fromJson(result);
    print("_userModel $_userModel");

    return _userModel;
  }

  Future<CustomerListModel> getNewCustomerList(String salesId) async {
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/SalesApiController/customerListForChat"), body: {
      "secretkey" : ConnectionSales.secretKey,
      "sales_id": salesId
    });
    var result = json.decode(response.body);
    CustomerListModel customerListModel;
    customerListModel = CustomerListModel.fromJson(result);
    print("customerList ${customerListModel.customerList}");

    return customerListModel;
  }

  Future<SalesChatDetailModel> getSalesChatDetails(String conversationId) async {
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/SalesApiController/salesChatDetails"), body: {
      "secretkey" : r"12!@34#$5%",
      "conversation_id": conversationId,

    });
    var result = json.decode(response.body);
    print("salesChatDetailModel api  response $result");
    SalesChatDetailModel salesChatDetailModel;
    salesChatDetailModel = (SalesChatDetailModel.fromJson(result));
    print("salesChatDetailModel  api $salesChatDetailModel");
    if(response.statusCode == 200){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("conversationId", result["conversation_id"]);
    }
    else {

    }

    return salesChatDetailModel;
  }


  Future<ModelListModel> getModelList(String customerId) async {
    var response = await http.post(Uri.parse(ConnectionSales.customerPriceList), body: {
      "secretkey": Connection.secretKey,
      "customer_id":"$customerId"
    });
    var result = json.decode(response.body);
    print("model house response $result");


    ModelListModel modelListModel;
    modelListModel = (ModelListModel.fromJson(result));
    print("model $modelListModel");

    return modelListModel;
  }


  Future<SalesChatListModel> getSalesChatList(String salesId) async {
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/SalesApiController/salesChatList"),
        body: {
          "secretkey" : r"12!@34#$5%",
          "sales_id": salesId
        });
    var result = json.decode(response.body);
    print("customerChatList  response $result");
    SalesChatListModel salesChatListModel;
    salesChatListModel = (SalesChatListModel.fromJson(result));
    print("salesChatListModel api ${salesChatListModel.salesConversations}");

    return salesChatListModel;
  }


  Future<OrderModel> getCustomerOrderDetails(String customerId) async{
    print("object customer id $customerId");
    var response = await http.post(Uri.parse(ConnectionSales.customerOrderList), body: {
      "secretkey" : ConnectionSales.secretKey,
      "customerid":customerId
    });
    var result = json.decode(response.body);
    print("customer order† response $result ${result['status']}");


    OrderModel _orderModel;
    _orderModel = OrderModel.fromJson(result);
    print("_userModel $_orderModel");

    return _orderModel;
  }

  Future<OrderDetailsByIdModel> getOrderDetailsIdWise(String orderId) async {
    var response = await http.post(Uri.parse(ConnectionSales.productListByOrder), body: {
      "secretkey" : ConnectionSales.secretKey,
      "orderid":orderId
    });
    var result = json.decode(response.body);
    print("customer order† response $result ${result['status']}");


    OrderDetailsByIdModel orderDetailsByIdModel;
    orderDetailsByIdModel = OrderDetailsByIdModel.fromJson(result);
    print("_userModel $orderDetailsByIdModel");

    return orderDetailsByIdModel;
  }

  Future<CreditListModel> getCustomerCreditList() async {
    var response = await http.post(Uri.parse(ConnectionSales.creditList), body: {
      "secretkey" : ConnectionSales.secretKey,
    });
    var result = json.decode(response.body);
    print("customer credit response $result ${result['status']}");


    CreditListModel _listModel;
    _listModel = CreditListModel.fromJson(result);
    print("_userModel $_listModel");

    return _listModel;
  }

  Future<ProductListOrderModel> getProductList() async {
    var response = await http.post(Uri.parse(ConnectionSales.productList), body: {
      "secretkey": ConnectionSales.secretKey,

    });
    var result = json.decode(response.body);
    print("ware house response $result");


    ProductListOrderModel productListModel;
    productListModel = (ProductListOrderModel.fromJson(result));
    print("warhouseList $productListModel");

    return productListModel;
  }
  Future<CustomerPriceListModel> getCustomerPriceList(String customerId) async {

    print("object userid $customerId");

    var response = await http.post(Uri.parse(ConnectionSales.customerPriceList ), body: {
      "secretkey" : Connection.secretKey,
      "customer_id" : customerId
    });
    var result = json.decode(response.body);
    print("address response $result");


    CustomerPriceListModel customerPriceListModel;
    customerPriceListModel = (CustomerPriceListModel.fromJson(result));
    print("Customer Price List $customerPriceListModel");

    return customerPriceListModel;
  }



  Future<CustomerOrdersModel> getAllCustomerOrders(String salesManId) async {

    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/SalesApiController/orderList"),
        body: {
      "secretkey" : r"12!@34#$5%",
      "salesman_id" : salesManId
    });
    var result = json.decode(response.body);
    print("customer Orders List response $result");


    CustomerOrdersModel customerOrdersModel;
    customerOrdersModel = (CustomerOrdersModel.fromJson(result));
    print("Customer Orders List $customerOrdersModel");

    return customerOrdersModel;
  }

  Future<InvoiceModel> getInvoiceListSales(String salesManId) async {

    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/SalesApiController/customerInvoiceList"),
        body: {
          "secretkey" : r"12!@34#$5%",
          "salesman_id" : salesManId
        });
    var result = json.decode(response.body);
    print("customer Orders List response $result");


    InvoiceModel invoicemodel;
    invoicemodel = (InvoiceModel.fromJson(result));
    print("List $invoicemodel");

    return invoicemodel;
  }

  Future<PendingOrderListModel> getPendingOrderListSales(String salesManId) async {

    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/SalesApiController/customersPendingOrderList"),
        body: {
          "secretkey" : r"12!@34#$5%",
          "salesman_id" : salesManId
        });
    var result = json.decode(response.body);
    print("List response $result");


    PendingOrderListModel pendingorderlistmodel;
    pendingorderlistmodel = (PendingOrderListModel.fromJson(result));
    print("List $pendingorderlistmodel");

    return pendingorderlistmodel;
  }

  Future<HoldOrderModel> getHoldOrderListSales(String salesManId) async {

    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/SalesApiController/customersHoldOrderList"),
        body: {
          "secretkey" : r"12!@34#$5%",
          "salesman_id" : salesManId
        });
    var result = json.decode(response.body);
    print("List response $result");


    HoldOrderModel holdordermodel;
    holdordermodel = (HoldOrderModel.fromJson(result));
    print("List $holdordermodel");

    return holdordermodel;
  }

  Future<ReturnMaterialSaleModel> getretunmaterialList(String salesManId) async {

    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/SalesApiController/customersReturnMaterialList"),
        body: {
          "secretkey" : r"12!@34#$5%",
          "salesman_id" : salesManId
        });
    var result = json.decode(response.body);
    print("List response $result");


    ReturnMaterialSaleModel returnmaterialsalemodel;
    returnmaterialsalemodel = (ReturnMaterialSaleModel.fromJson(result));
    print("List $returnmaterialsalemodel");

    return returnmaterialsalemodel;
  }

  Future<ReturnMaterialDetailSalesModel> getretunmaterialDetail(String materialId) async {

    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/SalesApiController/customerReturnMaterialDetails"),
        body: {
          "secretkey" : r"12!@34#$5%",
          "return_material_id" : materialId
        });
    var result = json.decode(response.body);
    print("List response $result");


    ReturnMaterialDetailSalesModel returnmaterialdetailsalesmodel;
    returnmaterialdetailsalesmodel = (ReturnMaterialDetailSalesModel.fromJson(result));
    print("List $returnmaterialdetailsalesmodel");

    return returnmaterialdetailsalesmodel;
  }

  Future<InvoiceDetailModel> getInvoiceSalesDetail(String invoiceId) async {

    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/SalesApiController/customerInvoiceProductList"),
        body: {
          "secretkey" : r"12!@34#$5%",
          "invoice_id" : invoiceId
        });
    var result = json.decode(response.body);
    print("List response $result");


    InvoiceDetailModel invoicedetailmodel;
    invoicedetailmodel = (InvoiceDetailModel.fromJson(result));
    print("List $invoicedetailmodel");

    return invoicedetailmodel;
  }

  Future<SalesCustomerCredirListModel> getSalesCreditList(String salesman_id) async {

    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/SalesApiController/customerCreditList"),
        body: {
          "secretkey" : r"12!@34#$5%",
          "salesman_id" : salesman_id
        });
    var result = json.decode(response.body);
    print("List response $result");


    SalesCustomerCredirListModel salescustomercredirlistmodel;
    salescustomercredirlistmodel = (SalesCustomerCredirListModel.fromJson(result));
    print("List $salescustomercredirlistmodel");

    return salescustomercredirlistmodel;
  }




}