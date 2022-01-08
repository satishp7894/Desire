class Connection{

  static String secretKey = r"12!@34#$5%";
 // http://loccon.in/desiremoulding/api/UserApiController/kycUpload
  static String ip = 'http://loccon.in/desiremoulding/api/UserApiController/';
  static String salesIp = 'http://loccon.in/desiremoulding/api/SalesApiController/';



  static String image = 'http://loccon.in/desiremoulding/upload/Image/Product/';

  //login
  static String login = ip+"checklogin";
  static String mobileCheck = ip+"customermobilecheck";
  static String emailCheck = ip+"customerEmailcheck";
  static String signUp = ip+"registerUser";
  static String forgetPassword = ip+"forgetpasswordUser";
  static String updateProfile = ip+"updateuserprofile";
  static String getAttributes = "https://api.postalpincode.in/pincode/";
  static String editAddress = ip+"EditAddress";

  //profile
  static String getKYC = ip+"kyc";
  static String getKYCDetails = ip+"kycuserdetails";
  static String uploadKYC = ip+"kycUpload";

 // model
static String categoryWiseModelNo = "http://loccon.in/desiremoulding/api/UserApiController/categoryWiseModelNo";

  //products
  static String newProduct = ip+"NewProduct";
  static String futureProduct = ip+"FutureProduct";
  static String bestProduct = ip+"BestsellerProduct";
  static String accessory = ip+"accessorieslist";
  static String searchProduct = ip+"searchProduct";
  static String searchAccessories = ip+"searchaccessories";
  static String productDetails = ip+"productDetails";
  static String allProductDetails = ip+"allproductDetails";

  //categories
  static String categoryWiseList = ip+"categoryWiseProduct";
  static String categoryList = ip+"category";

  //address
  static String addressList = ip+"getAddress";
  static String addAddress = ip+"addAddress";
  static String delAddress = ip+"deleteaddress";

  // Constants //cart
  static final String cartList = "cartlist";
  static final String addCart = ip+"addToCart";
  static final String cartDetails = ip+"getCartItems";
  static final String checkOut = ip+"addOrder";
  static final String removeCart = ip+"removeFromCart";
  static final String changeQty = ip+"changeCartProdQty";
  static final String emptyCart = ip+"emptyCart";
  static final String orderHistory = ip+"orderHistory";
  static final String orderTracking = ip+"orderTracking";

  //wishList
  static final String addWishList = ip+"addwishlist";
  static final String removeWishList = ip+"removewishlist";
  static final String getWishList = ip+"wishlist";

  //invoice
  static final String getInvoice = ip+"customerInvoiceList";
  static final String addCredits = ip+"addCredit";


  static final String verifyMobileNumber = ip+"customermobilecheck";

  //ledger

  static final String customerLedger = ip+"customerLedger";

  //ReadyStock
  static final String modelNoWiseReadyStockList = ip+"modelNoWiseReadyStockList";

  //invoice

  static final String customerInvoiceList = ip+"customerInvoiceList";

  //transport

  static final String customerTransportList = ip+"customerTransportList";

  //pendingOrder

  static final String pendingOrderList = ip+"pendingOrderList";
  static final String holdOrderList = ip+"holdOrderList";
  static final String completeOrderList = ip+"completeOrderList";

  static final String customerInvoiceProductList = ip+"customerInvoiceProductList";
  static final String submitReturnMaterial = ip+"submitReturnMaterial";


}