import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/accesory_bloc.dart';
import 'package:desire_users/bloc/all_model_bloc.dart';
import 'package:desire_users/bloc/category_bloc.dart';
import 'package:desire_users/bloc/product_bloc.dart';
import 'package:desire_users/models/allModel.dart';
import 'package:desire_users/models/cart_model.dart';
import 'package:desire_users/models/category_model.dart';
import 'package:desire_users/models/hold_orders_model.dart';
import 'package:desire_users/pages/cart/complete_order_list.dart';
import 'package:desire_users/pages/cart/cust_cart_page.dart';
import 'package:desire_users/pages/cart/hold_order_page.dart';
import 'package:desire_users/pages/cart/order_history_page.dart';
import 'package:desire_users/pages/cart/pending_order_list.dart';
import 'package:desire_users/pages/chatting/chat_list_page.dart';
import 'package:desire_users/pages/complaint/add_complaint.dart';
import 'package:desire_users/pages/home/customer_price_list.dart';
import 'package:desire_users/pages/home/modelFromCategoryPage.dart';
import 'package:desire_users/pages/home/model_list_page.dart';
import 'package:desire_users/pages/home/userSearchedPage.dart';
import 'package:desire_users/pages/intro/block_page.dart';
import 'package:desire_users/pages/invoice/invoice_list_page.dart';
import 'package:desire_users/pages/ledger/customerLedgerPage.dart';
import 'package:desire_users/pages/notifications/notifications.dart';
import 'package:desire_users/pages/product/productFromModelDetailPage.dart';
import 'package:desire_users/pages/product/productFromModelPage.dart';
import 'package:desire_users/pages/product/product_list_page.dart';
import 'package:desire_users/pages/profile/user_detail_page.dart';
import 'package:desire_users/pages/ready_stock/ready_stock_list.dart';
import 'package:desire_users/pages/today_production/today_production_page.dart';
import 'package:desire_users/pages/transport_details/transport_details_list.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/services/check_block.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;
import 'package:desire_users/models/product_model.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class HomePage extends StatefulWidget {

  final bool status;
  final customerId, customerName ,customerEmail,mobileNo;
  final salesmanId;

  const HomePage({@required this.status,this.customerEmail,this.customerName,this.customerId,this.mobileNo, this.salesmanId});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final ProductBloc productBloc = ProductBloc();
  final AllModelBloc allModelBloc = AllModelBloc();
  final CategoryBloc categoryBloc = CategoryBloc();
  final AccesoryBloc accessorBloc = AccesoryBloc();

  TextEditingController searchController =  TextEditingController();

  PackageInfo packageInfo ;
  String buildNumber;
  String versionNumber;
  String appName;
  String packageName;

  int cartItemCount = 0;

  getCartCount() async{
    var response = await http.post(Uri.parse(Connection.cartDetails), body: {
      "secretkey" : Connection.secretKey,
      "customer_id" : widget.customerId
    });

    var result = json.decode(response.body);
    CartModel cartModel;
    cartModel = CartModel.fromJson(result);

    setState(() {
      cartModel.data == null ? cartItemCount = 0 : cartItemCount = cartModel.data.length;
      print("cartItemCount : - " + cartItemCount.toString() + " Items");
    });
  }

  Widget cartItemCounter(String svgSrc, int numOfItem, Function() press,){
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      onTap: press,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 50,
            width: 45,
            child: SvgPicture.asset(svgSrc),
          ),
          if (numOfItem != 0)
            Positioned(
              top: -2,
              right: 0,
              child: Container(
                height: 22,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    "$numOfItem",
                    style: TextStyle(
                      fontSize: 10,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  getAppInfo() async{
    packageInfo = await PackageInfo.fromPlatform();
    buildNumber = packageInfo.buildNumber;
    versionNumber = packageInfo.version;
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;

    final checkBloc = CheckBlocked(widget.mobileNo);
    print("Mobile Number :" + widget.mobileNo);
    checkBloc.getDetails(context);
  }

  checkConnectivity() async{
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }

  String value = " ";
  _initOneSignal() async {
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    await OneSignal.shared.setAppId("37cabe91-f449-48f2-86ad-445ae883ad77");

    //OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);

    // Setting OneSignal External User Id
    if(widget.customerId != null){
      OneSignal.shared.setExternalUserId(widget.customerId);
    }

    OneSignal.shared.setNotificationOpenedHandler((openedResult) async {
      print("clicked happen in home page");

      print("object open result ${openedResult.notification.title} ${widget.customerId}");
      if(openedResult.notification.title == "Account Has Been Blocked"){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => BlockedPage(mob: widget.mobileNo)), (route) => false);
      } else if(openedResult.notification.title == "Order Update Successfully" || openedResult.notification.title == "Add Order Successfully Details"){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => OrderHistoryPage(status: false, customerId: widget.customerId,orderCount: cartItemCount)), (route) => false);

      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomePage(status: false,mobileNo: widget.mobileNo,customerName: widget.customerName,customerEmail: widget.customerEmail,customerId: widget.customerId,)), (route) => false);
      }
    });

    OneSignal.shared
        .setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: $event');
      /// Display Notification, send null to not display
      event.complete(null);

      this.setState(() {
        value =
        "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

  }

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    getCartCount();
    getAppInfo();
    productBloc.fetchNewProduct(widget.customerId);
    productBloc.fetchBestProduct(widget.customerId);
    allModelBloc.fetchAllModel(widget.customerId);
    categoryBloc.fetchCategories(widget.customerId);
   // accessorBloc.fetchAccessory(widget.customerId);

  }


  @override
  void dispose() {
    super.dispose();
    productBloc.dispose();
    allModelBloc.dispose();
    categoryBloc.dispose();
    accessorBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Alerts.showExit(context, "DESIRE MOULDING", "Are you sure you want to exit ?");
      },
      child: RefreshIndicator(
        onRefresh: (){
          return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
            return HomePage(status: true, customerId: widget.customerId,customerEmail: widget.customerEmail,
            customerName: widget.customerName,
              mobileNo: widget.mobileNo,
            );
          }));
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: kBlackColor),
            centerTitle: true,
            elevation: 0,
            backgroundColor:kWhiteColor,
            title: GestureDetector(
                onTap: (){
                  return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return HomePage(status: true, customerId: widget.customerId,customerEmail: widget.customerEmail,
                      customerName: widget.customerName,
                      mobileNo: widget.mobileNo,
                    );
                  }));
                },
                child: Image.asset("assets/images/logo.png",height: 30,)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 8),
                child: cartItemCounter(
                    "assets/icons/Cart Icon.svg",
                    cartItemCount,
                        ()async{
                      Navigator.push(context, MaterialPageRoute(builder: (builder) => CustCartPage(customerId: widget.customerId, customerName: widget.customerName,customerEmail: widget.customerEmail,customerMobile: widget.mobileNo,)));
                    }),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: _searchField(),
            ),
          ),
          drawer: _drawer(),
          body: _body(),

        ),
      ),
    );
  }
  Widget _drawer(){
    return Drawer(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(230),
          child: Container(
            height: 230,
            child: Stack(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      color: kPrimaryColor
                  ),
                  currentAccountPicture: Image.asset("assets/images/logo.png",height: 20,color: kWhiteColor,),
                  accountName: Text("Name: "+widget.customerName,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: kWhiteColor),),
                  accountEmail: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: "+widget.customerEmail,style: TextStyle(fontSize: 12,color: kWhiteColor),),
                      SizedBox(height: 5,),
                      Text("Mobile No.: "+widget.mobileNo,style: TextStyle(fontSize: 12,color: kWhiteColor),),
                    ],
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 250,
                  child: IconButton(
                      tooltip: "Notifications",
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerNotifications()));


                      }, icon: Icon(Icons.notifications,color: kWhiteColor,size: 30,)),
                )
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height:50,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0,right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey,height: 0.0,thickness: 1,),
                  SizedBox(height: 10,),
                  Text("Version: $versionNumber",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: kBlackColor),),
                  Text("Build Number: $buildNumber",style: TextStyle(fontSize: 12,color: kBlackColor,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,bottom: 5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => UserDetailPage(status: true, orderCount: 0,)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.person,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("My Profile",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),
              Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerPriceList(customerId: widget.customerId)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.price_change,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Price List",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ) ,
              Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (builder) => ReadyStockListView(customerId: widget.customerId,)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.event_available,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Ready Stock",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ) ,
              Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => OrderHistoryPage(customerId: widget.customerId,status: true,orderCount: 0)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_border,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("My Orders",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),
              Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (builder) => CompleteOrderList(customerId: widget.customerId)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Completed Orders",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),
              Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){

                     Navigator.push(context, MaterialPageRoute(builder: (builder) => PendingOrderList(customerId: widget.customerId)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.pending,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Pending Orders",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),
              Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => InvoiceListPage(customerId: widget.customerId,customerName: widget.customerName,)));

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.document_scanner,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Invoices",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),
              Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => HoldOrderPage(customerId: widget.customerId)));
                  //  Navigator.push(context, MaterialPageRoute(builder: (builder) => CustCartPage(customerId: widget.customerId,customerName: widget.customerName,customerEmail: widget.customerEmail,customerMobile: widget.mobileNo,)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.pause,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("On Hold Orders",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),
              Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => CustCartPage(customerId: widget.customerId,customerName: widget.customerName,customerEmail: widget.customerEmail,customerMobile: widget.mobileNo,)));

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_basket,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("My Basket",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => TodayProductionPage()));

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.production_quantity_limits,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Today's Production",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddComplaint()));

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.feedback,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Complaint",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),
              Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.contact_page,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Contact Us",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),
              Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomerLedgerPage(customerId: widget.customerId)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.list,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Ledger",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ), Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_return_outlined,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Return Material",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),
              Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => TransportDetailsList(customerId: widget.customerId,)));

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_transportation,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Transport Details",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),

              Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatListPage(customerId: widget.customerId,salesmanId: widget.salesmanId,)));

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.message,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Chats",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),
              Divider(color: kSecondaryColor,),
              Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                child: GestureDetector(
                  onTap: (){

                    Alerts.showCustomerLogOut(context, "Logout", "Are you sure want to logout");


                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.logout,color: kPrimaryColor,),
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text("Logout",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                          )),
                      Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),



                    ],
                  ),
                ),
              ),
              Divider(color: kSecondaryColor,),

            ],
          ),
        ),
      ),
    );
  }

  Widget _searchField(){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhiteColor,
      ),
      child: TextFormField(
        controller: searchController,
        textInputAction: TextInputAction.search,
        cursorColor: kBlackColor,
        onEditingComplete: (){
          print(searchController.text);
          searchController.text.isEmpty? print("Type Something"): Navigator.push(context, MaterialPageRoute(builder: (c) => UserSearchedPage(searchKeyword: searchController.text,customerId: widget.customerId,customerName: widget.customerName,customerEmail: widget.customerEmail,mobileNo: widget.mobileNo,)));
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Search model, product and category.....",
            hintStyle: TextStyle(fontSize: 14),
            prefixIcon: Icon(Icons.search,color: kPrimaryColor,size: 30,)),
      ),
    );
  }

  Widget _body(){
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          _categories(),
          allModelView(),
          _newProduct(),
          _bestProduct()

        ],
      ),
    );
  }
  Widget _sectionTile(String title, Function press){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            "See More",
            style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  AsyncSnapshot<CategoryModel> categorySnapshot;
  Widget _categories(){
    return StreamBuilder<CategoryModel>(
        stream: categoryBloc.catStream,
        builder: (c, s) {
          categorySnapshot = s;
          if (categorySnapshot.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50, child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),));
          }
         else if (categorySnapshot.hasError) {
            print("as3 error");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("Error Loading Data",),);
          }
         else  if (categorySnapshot.data.toString().isEmpty) {
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("No Data Found"),
            );
          }
         else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                categorySnapshot.data.data.length,
                    (index) => CategoryCard(
                  icon: "assets/icons/sweetbox.svg",
                  text: categorySnapshot.data.data[index].categoryName,
                  press: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ModelFromCategoryPage(categoryId:categorySnapshot.data.data[index].categoryId ,categoryName: categorySnapshot.data.data[index].categoryName,customerId: widget.customerId,)));

                  },
                ),
              ),
            );
          }

        }
    );
  }

  AsyncSnapshot<AllModel> allModelSnapshot;
  Widget allModelView(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10,bottom: 10),
          child: _sectionTile("All Model", () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => ModelListPage(customerId: widget.customerId,)));
          }),
        ),
        SizedBox(height: 10),
        StreamBuilder<AllModel>(
            stream: allModelBloc.allModelStream,
            builder: (c, s) {
              if (s.connectionState != ConnectionState.active) {
                print("all connection");
                return Container(height: 300,
                    alignment: Alignment.center,
                    child: Center(
                      heightFactor: 50, child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),));
              }
            else  if (s.hasError) {
                print("as3 error");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("Error Loading Data",),);
              }
           else if (s.data
                  .toString()
                  .isEmpty) {
                print("as3 empty");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("No Data Found",),);
              }
           else {
                allModelSnapshot = s;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      ...List.generate(
                        allModelSnapshot.data.data.length,
                            (index) {
                          return ModelCard(data: allModelSnapshot.data.data[index], cartItemCount: cartItemCount,customerId: widget.customerId,imagePath: allModelSnapshot.data.imagepath,customerName: widget.customerName,customerEmail: widget.customerEmail,customerMobile: widget.mobileNo,);
                        },
                      ),
                    ],
                  ),
                );
              }

            }
        )
      ],
    );


  }

  AsyncSnapshot<ProductModel> bestProductSnapshot;
  Widget _bestProduct(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 10,top: 20,bottom: 10),
          child: _sectionTile("Best Products", () {

          }),
        ),
        SizedBox(height: 10),
        StreamBuilder<ProductModel>(
            stream: productBloc.bestProductStream,
            builder: (c, s) {

              if (s.connectionState != ConnectionState.active) {
                print("all connection");
                return Container(height: 300,
                    alignment: Alignment.center,
                    child: Center(
                      heightFactor: 50, child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),));
              }
             else  if (s.hasError) {
                print("as3 error");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("Error Loading Data",),);
              }
             else if (s.data
                  .toString()
                  .isEmpty) {
                print("as3 empty");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("No Data Found",),);
              }
             else {
                bestProductSnapshot = s;
                print("object value for new arrival ${bestProductSnapshot.data.product.first.id}");
                return bestProductSnapshot.data.product == null ? Container(
                  height: 300,
                  child: Center(
                    child: Text("No New Products Available"),
                  ),
                ) :
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                        bestProductSnapshot.data.product.length,
                            (index) {
                          return ProductCard(product: bestProductSnapshot.data.product[index], orderCount: cartItemCount,productId: bestProductSnapshot.data.product[index].id,customerId: widget.customerId,
                            customerName: widget.customerName,
                            customerEmail: widget.customerEmail,
                            customerMobile: widget.mobileNo,
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
            }
        )
      ],
    );

  }

  AsyncSnapshot<ProductModel> newProductSnapshot;
  Widget _newProduct(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 10,top: 20,bottom: 10),
          child: _sectionTile("New Products", () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => ProductListPage(snapshot: newProductSnapshot.data.product, title: "New Products", refresh: false,status: true,)));
          }),
        ),
        SizedBox(height: 10),
        StreamBuilder<ProductModel>(
            stream: productBloc.newProductStream,
            builder: (c, s) {

              if (s.connectionState != ConnectionState.active) {
                print("all connection");
                return Container(height: 300,
                    alignment: Alignment.center,
                    child: Center(
                      heightFactor: 50, child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),));
              }
             else  if (s.hasError) {
                print("as3 error");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("Error Loading Data",),);
              }
             else if (s.data
                  .toString()
                  .isEmpty) {
                print("as3 empty");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("No Data Found",),);
              }
             else {
                newProductSnapshot = s;
                print("object value for new arrival ${newProductSnapshot.data.product.first.id}");
                return newProductSnapshot.data.product == null ? Container(
                  height: 300,
                  child: Center(
                    child: Text("No New Products Available"),
                  ),
                ) :
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(
                        newProductSnapshot.data.product.length,
                            (index) {
                          return ProductCard(product: newProductSnapshot.data.product[index], orderCount: cartItemCount,productId: newProductSnapshot.data.product[index].id,customerId: widget.customerId,
                            customerName: widget.customerName,
                            customerEmail: widget.customerEmail,
                            customerMobile: widget.mobileNo,
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
            }
        )
      ],
    );

  }

}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.press,  this.image,
  }) : super(key: key);

  final String icon, text, image;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10,bottom: 20,top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: kPrimaryColor)

              ),
              child: SvgPicture.asset(icon),
            ),
            SizedBox(height: 10),
            Text(text, textAlign: TextAlign.center,style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),)
          ],
        ),
      ),
    );
  }
}

class ModelCard extends StatelessWidget {

  final Data data;
  final customerId,customerName ,customerMobile, customerEmail;
  final imagePath;
  final int cartItemCount;


  ModelCard(
      {this.data,
      this.customerId,
      this.customerName,
      this.customerMobile,
      this.customerEmail,
      this.imagePath,
      this.cartItemCount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductFromModelPage(
        customerId: customerId ,
        modelNo:data.modelNo ,
        modelNoId:  data.modelNoId,
        customerName: customerName,
      ))),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),],
                    color: kWhiteColor
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: data.image == null ? Image.asset("images/app_logo.png"):Image.network("$imagePath"+"${data.image}",height: 100,),
                )),
            const SizedBox(height: 10),
            Text(
              "Model No. " + data.modelNo.toUpperCase(),
              style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),
              //maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    @required this.product,
    @required this.orderCount, this.customerId, this.productId, this.customerEmail, this.customerMobile, this.customerName});

  final customerId , productId;
  final customerEmail , customerMobile, customerName;
  final Product product;
  final int orderCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>   Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductFromModelDetailPage(
        customerId: customerId,
        productId: productId,
        customerMobile: customerMobile,
        customerEmail: customerEmail,
        customerName: customerName,
      ))),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network("http://loccon.in/desiremoulding/upload/Image/Product/${product.image[0]}",height: 150),
            SizedBox(height: 10),
            Text(
              product.productName.toUpperCase(),
              style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),
              //maxLines: 1,
            ),
            SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MRP: " "₹${product.customerprice}",
                  style: TextStyle(
                    decoration:   product.customernewprice == "" ?TextDecoration.none: TextDecoration.lineThrough,
                    fontSize:  product.customernewprice == "" ? 14:12,
                    fontWeight: FontWeight.w600,
                    color: product.customernewprice == "" ? kPrimaryColor :kSecondaryColor,
                  ),
                ),
                Text(
                  product.customernewprice == "" ? "": "Your Price: "+"₹${product.customernewprice}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color:kPrimaryColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
