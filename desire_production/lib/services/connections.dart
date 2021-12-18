class Connection {

  static final String secretKey = "12!@34#\$5%";

  static final String ip = 'http://loccon.in/desiremoulding/api/ProductionApiController/';
  static final String ipUsers = 'http://loccon.in/desiremoulding/api/UserApiController/';
  static final String ipSales = 'http://loccon.in/desiremoulding/api/SalesApiController/';
  static final String ipAdmin = 'http://loccon.in/desiremoulding/api/AdminApiController/';

  static final String allCustomerList = ipAdmin+"allcustomerlist";
  static final String adminChatList = ipAdmin+"adminChatList";
  static final String customerListForChat = ipAdmin+"customerListForChat";
  static final String salesmanListForChat = ipAdmin+"salesmanListForChat";
  static final String clearChat = ipAdmin+"clearChat";
  static final String sendMessage = ipAdmin+"sendMessage";
  static final String newConversation = ipAdmin+"newConversation";
  static final String adminChatDetails = ipAdmin+"adminChatDetails";
  static final String getCustomerList = ipSales+"salesCustomerList";
  static final String blockCustomer = ipSales+"blockcustomer";
  static final String addCustomer = ipAdmin+"registerUser2";
  static final String editOrderAdding = ipSales+"editorderAdding";
  static final String editProduct = ipSales+"editorderdetails";

  //login
  static final String login = ip + "loginForProduction";
  static final String forgotPass = ip + "forgotPassword";
  static final String getAttributes = "https://api.postalpincode.in/pincode/";

  static final String productionOrderList = ip + "productionOrderList";
  static final String dailyOrderList = ip + "dailyOrderList";
  static final String dailyProductionListByModel = ip+"modelNoWiseList";
  static final String sendToPlanning = ip + "SendtoProductionPlannig";
  static final String productionPlanningList = ip + "ProductionPlanningList";
  static final String sendToWarehouse = ip + "PlanningtoWarehouse";

  //Dashboard
  static final String dashboardCount = ip + "poductionDashoard";

  //Notification
  static final String productiontoNotificationSales = ip + "productiontoNotificationSales";
  static final String image = 'http://loccon.in/desiremoulding/upload/Image/Product/';

  //Warehouse
  static final String warehouseList = ip + "warehouselist";
  static final String dispatchProcessing = ip + "disptachprocessing";
  static final String dispatchData = ip + "dispatchdata";

  static final String wareLRimageUpload = ip + "wareLRimageUpload";
  static final String wareEVAimageUpload = ip + "wareEVAimageUpload";

  //products
  static final String newProduct = ipUsers+"NewProduct";
  static final String futureProduct = ipUsers+"FutureProduct";
  static final String bestProduct = ipUsers+"BestsellerProduct";
  static final String accessory = ipUsers+"accessorieslist";
  static final String searchProduct = ipUsers+"searchProduct";
  static final String searchAccessories = ipUsers+"searchaccessories";
  static final String productDetails = ipUsers+"productDetails";

  static final String productList = ipAdmin + "allproductDetails";
  static final String modelList = ipSales + "customerPriceList";
  static final String editmodelList = ipSales + "submitCustomerPriceList";

  //categories
  static final String categoryWiseList = ipUsers+"categoryWiseProduct";
  static final String categoryList = ipUsers+"category";

  //profile
  static final String getKYC = ipAdmin+"kyc";
  static final String getKYCDetails = ipAdmin+"kycuserdetails";
  static final String uploadKYC = ipAdmin+"kycUpload";

  static final String updateProfile = ipAdmin+"editcustomerlistAssignSales";
  static final String changePass = ipUsers+"changepassword";
  static final String setKycIdStats = ipSales+"kycApprovestatus";
  static final String setCustKycStats = ipSales+"kycapprovecustomer";

  //address
  static final String addressList = ipAdmin+"getAddress";
  static final String addAddress = ipAdmin+"addAddress";
  static final String delAddress = ipAdmin+"deleteaddress";
  static final String editAddress = ipAdmin+"EditAddress";

  //orders
  static final String sendToProduction = ipSales+"sendtoprodution";
  static final String productListByOrder = ipSales+"orderidBypoductdetails";

  // Constants //cart
  static final String cartList = "cartlist";
  static final String addCart = ipUsers+"addToCart";
  static final String cartDetails = ipUsers+"getCartItems";
  static final String checkOut = ipUsers+"addOrder";
  static final String removeCart = ipUsers+"removeFromCart";
  static final String changeQty = ipUsers+"changeCartProdQty";
  static final String emptyCart = ipUsers+"emptyCart";

  //credits
  static final String creditList = ipAdmin+"allcreditDetails";
  static final String addCredits = ipAdmin+"addCredit";
  static final String creditApprove = ipAdmin+"approveNreject";

  //orders
  static final String orderTracking = ipAdmin+"orderTracking";
  static final String customerOrderList = ipAdmin+"orderHistory";

  //salesman list
  static final String salesManList = ipAdmin+"allsalesdetails";
  static final String editSalesDetails = ipAdmin+"editSalesdetails";


  //admin userlist
  static final String adminUserList = ipAdmin+"allAdminUsers";
  static final String addAdminUser = ipAdmin+"addAdminUsers";
  static final String editAdminDetails = ipAdmin+"editAdminUsers";
  static final String deleteAdmin = ipAdmin+"deleteAdminUsers";

  static final String roleList = ipAdmin+"adminUserType";

  //products details
  static final String allProfile = ipAdmin+"allProfileNo";
  static final String addProfile = ipAdmin+"addProfileNo";
  static final String editProfile = ipAdmin+"editProfileNo";
  static final String deleteProfile = ipAdmin+"deleteProfileNo";

  static final String allModel = ipAdmin+"allModelNo";
  static final String addModel = ipAdmin+"addModelNo";
  static final String editModel = ipAdmin+"editModelNo";
  static final String deleteModel = ipAdmin+"deleteModelNo";

  static final String allDimension = ipAdmin+"allDimension";
  static final String addDimension = ipAdmin+"addDimension";
  static final String editDimension = ipAdmin+"editDimension";
  static final String deleteDimension = ipAdmin+"deleteDimension";

  static final String allCategory = ipAdmin+"allCategory";
  static final String addCategory = ipAdmin+"addCategory";
  static final String editCategory = ipAdmin+"editCategory";
  static final String deleteCategory = ipAdmin+"deleteCategory";





}