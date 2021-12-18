class ConnectionSales{

  static String secretKey = "12!@34#\$5%";
  static String ip = 'http://loccon.in/desiremoulding/api/SalesApiController/';

  static String login = ip+"loginForSales";
  static String forgotPass = ip+"forgotPassword";
  static String updateProfile = ip+"updateprofile";
  static String changePass = ip+"changepassword";


  static String getCustomerList = ip+"salesCustomerList";
  static String addCustomer = ip+"registerUser";
  static String customerOrderList = ip+"customerorderlist";
  static String blockCustomer = ip+"blockcustomer";
  static String allCustomerOrders = ip+"orderList";


  static String setKycIdStats = ip+"kycApprovestatus";
  static String setCustKycStats = ip+"kycapprovecustomer";



  static String sendToProduction = ip+"sendtoprodution";
  static String productListByOrder = ip+"orderidBypoductdetails";
  static String editProduct = ip+"editorderdetails";
  static String editOrderAdding = ip+"editorderAdding";

  static String checkOut = ip+"addOrder";

  //credits
  static String creditList = ip+"creditlist";

  //customer pricing
  static String customerPriceList = ip +"customerPriceList";
  static String postCustomerPriceList = ip +"submitCustomerPriceList";


  //products
  static String productList = "http://loccon.in/desiremoulding/api/ProductionApiController/productList";


}