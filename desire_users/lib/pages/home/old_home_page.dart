// import 'dart:convert';
//
// import 'package:data_connection_checker/data_connection_checker.dart';
// import 'package:desire_users/bloc/accesory_bloc.dart';
// import 'package:desire_users/bloc/all_model_bloc.dart';
// import 'package:desire_users/bloc/category_bloc.dart';
// import 'package:desire_users/bloc/modelFromCategoryBloc.dart';
// import 'package:desire_users/bloc/order_bloc.dart';
// import 'package:desire_users/bloc/product_bloc.dart';
// import 'package:desire_users/models/allModel.dart';
// import 'package:desire_users/models/cart_model.dart';
// import 'package:desire_users/models/category_model.dart';
// import 'package:desire_users/models/modelNumberFromCategoryModel.dart';
// import 'package:desire_users/models/product_model.dart';
// import 'package:desire_users/pages/cart/cart_page.dart';
// import 'package:desire_users/pages/cart/cust_cart_page.dart';
// import 'package:desire_users/pages/cart/order_history_page.dart';
// import 'package:desire_users/pages/home/modelFromCategoryPage.dart';
// import 'package:desire_users/pages/home/model_list_page.dart';
// import 'package:desire_users/pages/home/userSearchedPage.dart';
// import 'package:desire_users/pages/intro/block_page.dart';
// import 'package:desire_users/pages/product/accessory_detail_page.dart';
// import 'package:desire_users/pages/product/accessory_list_page.dart';
// import 'package:desire_users/pages/product/productFromModelDetailPage.dart';
// import 'package:desire_users/pages/product/productFromModelPage.dart';
// import 'package:desire_users/pages/product/product_detail_page.dart';
// import 'package:desire_users/pages/product/product_list_page.dart';
// import 'package:desire_users/pages/product/product_searched_page.dart';
// import 'package:desire_users/pages/product_category/product_category_page.dart';
// import 'package:desire_users/pages/profile/profile_page.dart';
// import 'package:desire_users/pages/profile/user_detail_page.dart';
// import 'package:desire_users/services/check_block.dart';
// import 'package:desire_users/services/connection.dart';
// import 'package:desire_users/utils/alerts.dart';
// import 'package:desire_users/utils/constants.dart';
// import 'package:desire_users/utils/coustom_bottom_nav_bar.dart';
// import 'package:desire_users/utils/enums.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:http/http.dart' as http;
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
// import 'package:package_info/package_info.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// GoogleSignIn googleSignIn = GoogleSignIn(
//   scopes: <String>[
//     'email',
//   ],
// );
//
// class HomePage extends StatefulWidget {
//   final bool status;
//   final customerId, customerName ,customerEmail,mobileNo;
//
//   const HomePage({@required this.status,this.customerEmail,this.customerName,this.customerId,this.mobileNo});
//
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//
//
//
//   final newProductBloc = ProductBloc();
//   final allModelBloc = AllModelBloc();
//   final allProductBloc = ProductBloc();
//   final bestProductBloc = ProductBloc();
//   final futureProductBloc = ProductBloc();
//   final categoryBloc = CategoryBloc();
//   final accessorBloc = AccesoryBloc();
//   final orderBloc = OrderBloc();
//
//   TextEditingController searchController;
//
//   SharedPreferences prefs;
//   PackageInfo packageInfo ;
//   String buildNumber;
//   String versionNumber;
//   String appName;
//   String packageName;
//   String customerId;
//
//
//
//   @override
//   void initState() {
//     getCarCount();
//     super.initState();
//     checkConnectivity();
//     _initOneSignal();
//     signOut();
//     print("Status ${widget.status}");
//     if(widget.status) {
//       getDetails();
//     }
//     allModelBloc.fetchAllModel(widget.customerId);
//     allProductBloc.fetchAllProduct(widget.customerId);
//     newProductBloc.fetchNewProduct(widget.customerId);
//     bestProductBloc.fetchBestProduct(widget.customerId);
//     futureProductBloc.fetchFutureProduct(widget.customerId);
//     categoryBloc.fetchCategories(widget.customerId);
//     accessorBloc.fetchAccessory(widget.customerId);
//     searchController = TextEditingController();
//     SystemChannels.textInput.invokeMethod('TextInput.hide');
//   }
//
//   checkConnectivity() async{
//     bool result = await DataConnectionChecker().hasConnection;
//     if(result == true) {
//       print('YAY! Free cute dog pics!');
//     } else {
//       print('No internet :( Reason:');
//       print(DataConnectionChecker().lastTryResults);
//       Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     allModelBloc.dispose();
//     categoryBloc.dispose();
//     accessorBloc.dispose();
//     searchController.dispose();
//     newProductBloc.dispose();
//     bestProductBloc.dispose();
//
//   }
//
//   String value = "";
//   _initOneSignal() async {
//     // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
//     await OneSignal.shared.init("37cabe91-f449-48f2-86ad-445ae883ad77");
//
//     OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
//     //await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     // Setting OneSignal External User Id
//     if(prefs.getString("customer_id") != null){
//       OneSignal.shared.setExternalUserId(prefs.getString("customer_id"));
//     }
//
//     OneSignal.shared.setNotificationOpenedHandler((openedResult) async {
//       print("clicked happen in home page");
//
//       print("object open result ${openedResult.notification.payload.title} ${prefs.getString("customer_id")}");
//       if(openedResult.notification.payload.title == "Account Has Been Blocked"){
//         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => BlockedPage(mob: prefs.getString("Mobile_no"))), (route) => false);
//       } else if(openedResult.notification.payload.title == "Order Update Successfully" || openedResult.notification.payload.title == "Add Order Successfully Details"){
//         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (c) => OrderHistoryPage(status: false, customerId: prefs.getString("customer_id"),orderCount: orderCount)), (route) => false);
//
//       } else {
//         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomePage(status: false)), (route) => false);
//       }
//     });
//
//     OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
//       this.setState(() {
//         value = "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
//       });
//     });
//
//   }
//   getDetails() async{
//     packageInfo = await PackageInfo.fromPlatform();
//     buildNumber = packageInfo.buildNumber;
//     versionNumber = packageInfo.version;
//     appName = packageInfo.appName;
//     packageName = packageInfo.packageName;
//
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String mob = prefs.getString("Mobile_no");
//     customerId = prefs.getString("customer_id");
//     print("object $customerId");
//
//     print("object $mob");
//     final checkBloc = CheckBlocked(mob);
//     checkBloc.getDetails(context);
//   }
//
//   int orderCount = 0;
//   getCarCount() async{
//
//     prefs =await SharedPreferences.getInstance();
//     customerId = prefs.getString("customer_id");
//
//     print("object $customerId");
//
//     var response = await http.post(Uri.parse(Connection.cartDetails), body: {
//       "secretkey" : Connection.secretKey,
//       "customer_id" : customerId
//     });
//
//     var result = json.decode(response.body);
//     //pr.hide();
//     print("object value of order count $result");
//     CartModel cartModel;
//     cartModel = CartModel.fromJson(result);
//     print("order model length $result ${cartModel.data}");
//
//     setState(() {
//       cartModel.data == null ? orderCount = 0 : orderCount = cartModel.data.length;
//     });
//   }
//
//
//   signOut(){
//     print("object google sign out called");
//     googleSignIn.signOut();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         return Alerts.showExit(context, "Exit", "Are you sure you want to exit from App?");
//       },
//       child: RefreshIndicator(
//         color: kPrimaryColor,
//         onRefresh: () {
//           return Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => HomePage(status: true,customerId: widget.customerId,mobileNo: widget.mobileNo,customerEmail:widget.customerEmail,customerName: widget.customerName)),);
//         },
//         child: SafeArea(
//           child: Scaffold(
//             appBar: AppBar(
//               iconTheme: IconThemeData(
//                   color: kBlackColor
//               ),
//               centerTitle: true,
//               elevation: 0,
//               backgroundColor:kSecondaryColor.withOpacity(0),
//               titleTextStyle: headingStyle,
//               textTheme: Theme.of(context).textTheme,
//               title: Image.asset("assets/images/logo.png",height: 30,),
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 20, top: 8),
//                   child: iconBtnWithCounter(
//                       "assets/icons/Cart Icon.svg",
//                       orderCount,
//                           ()async{
//                         Navigator.push(context, MaterialPageRoute(builder: (builder) => CustCartPage(customerId: widget.customerId, customerName: widget.customerName,customerEmail: widget.customerEmail,customerMobile: widget.mobileNo,)));
//                       }),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.only(top: 10, bottom: 5, right: 20),
//                 //   child: iconBtnWithCounter("assets/icons/Bell.svg",3,() {},),
//                 // ),
//               ],
//               bottom: PreferredSize(
//                 preferredSize: Size.fromHeight(50),
//                 child: Container(
//                   child: _searchField(),
//                 ),
//               ),
//             ),
//             body:_body(),
//             drawer: _drawer(),
//
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _drawer(){
//     return Drawer(
//       child: Scaffold(
//         bottomNavigationBar: SafeArea(
//           child: Container(
//             height:55,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 10.0,right: 10),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Divider(color: Colors.grey,height: 0.0,thickness: 1,),
//                   SizedBox(height: 5,),
//                   Text("Version: $versionNumber",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: kBlackColor),),
//                   Text("Build Number: $buildNumber",style: TextStyle(fontSize: 12,color: kBlackColor,fontWeight: FontWeight.bold),),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               Container(
//                 height: 180,
//                 child: UserAccountsDrawerHeader(
//                   decoration: BoxDecoration(
//                       color: kPrimaryColor
//                   ),
//                   currentAccountPicture: CircleAvatar(
//                       backgroundColor: kWhiteColor,
//                       child: Image.asset("assets/images/logo.png",height: 30,)),
//                   accountName: Text("Name: "+widget.customerName,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: kWhiteColor),),
//                   accountEmail: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Email: "+widget.customerEmail,style: TextStyle(fontSize: 12,color: kWhiteColor),),
//                       SizedBox(height: 5,),
//                       Text("Mobile No.: "+widget.mobileNo,style: TextStyle(fontSize: 12,color: kWhiteColor),),
//                     ],
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10,bottom: 10),
//                 child: GestureDetector(
//                   onTap: (){
//                     Navigator.push(context, MaterialPageRoute(builder: (builder) => UserDetailPage(status: true, orderCount: orderCount,)));
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(Icons.person,color: kPrimaryColor,),
//                       Expanded(
//                           flex: 2,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 10.0),
//                             child: Text("My Profile",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
//                           )),
//                       Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),
//
//
//
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(color: kSecondaryColor,),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
//                 child: GestureDetector(
//                   onTap: (){
//                     Navigator.push(context, MaterialPageRoute(builder: (builder) => OrderHistoryPage(customerId: customerId,status: true,orderCount: orderCount)));
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(Icons.bookmark_border,color: kPrimaryColor,),
//                       Expanded(
//                           flex: 2,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 10.0),
//                             child: Text("My Orders",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
//                           )),
//                       Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),
//
//
//
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(color: kSecondaryColor,),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
//                 child: GestureDetector(
//                   onTap: (){
//                     Navigator.push(context, MaterialPageRoute(builder: (builder) => CustCartPage(customerId: customerId,customerName: widget.customerName,customerEmail: widget.customerEmail,customerMobile: widget.mobileNo,)));
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(Icons.shopping_basket,color: kPrimaryColor,),
//                       Expanded(
//                           flex: 2,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 10.0),
//                             child: Text("My Basket",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
//                           )),
//                       Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),
//
//
//
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(color: kSecondaryColor,),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
//                 child: GestureDetector(
//                   onTap: (){
//                     Alerts.showLogOut(context, "Logout", "Are you sure?");
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Icon(Icons.logout,color: kPrimaryColor,),
//                       Expanded(
//                           flex: 2,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 10.0),
//                             child: Text("Logout",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
//                           )),
//                       Icon(Icons.arrow_forward_ios,color: kPrimaryColor,),
//
//
//
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(color: kSecondaryColor,),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _body(){
//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       child: Column(
//         children: [
//           _categories(),
//           SizedBox(height: 10),
//           allModelView(),
//           SizedBox(height: 10),
//           _accessoryProduct(),
//           SizedBox(height: 10),
//           _newArrival(),
//           SizedBox(height: 10),
//           _bestProduct(),
//           SizedBox(height: 10),
//
//
//         ],
//       ),
//     );
//   }
//
//   Widget _searchField(){
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: kSecondaryColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: TextFormField(
//         controller: searchController,
//         textInputAction: TextInputAction.search,
//         cursorColor: kBlackColor,
//         onEditingComplete: (){
//           print(searchController.text);
//           searchController.text.isEmpty? print("Type Something"): Navigator.push(context, MaterialPageRoute(builder: (c) => UserSearchedPage(searchKeyword: searchController.text,customerId: widget.customerId,customerName: widget.customerName,)));
//         },
//         decoration: InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//             border: InputBorder.none,
//             focusedBorder: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             hintText: "Search model, product and category...",
//             hintStyle: TextStyle(fontSize: 14),
//             prefixIcon: Icon(Icons.search,color: kPrimaryColor,)),
//       ),
//     );
//   }
//
//   Widget iconBtnWithCounter(String svgSrc, int numOfItem, Function() press,){
//     return InkWell(
//       borderRadius: BorderRadius.circular(5),
//       onTap: press,
//       child: Stack(
//         children: [
//           Container(
//             padding: EdgeInsets.all(10),
//             height: 50,
//             width: 45,
//             child: SvgPicture.asset(svgSrc),
//           ),
//           if (numOfItem != 0)
//             Positioned(
//               top: -2,
//               right: 0,
//               child: Container(
//                 height: 22,
//                 width: 20,
//                 decoration: BoxDecoration(
//                   color: Color(0xFFFF4848),
//                   shape: BoxShape.circle,
//                   border: Border.all(width: 1.5, color: Colors.white),
//                 ),
//                 child: Center(
//                   child: Text(
//                     "$numOfItem",
//                     style: TextStyle(
//                       fontSize: 8,
//                       height: 1,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             )
//         ],
//       ),
//     );
//   }
//
//
//   AsyncSnapshot<AllModel> allModelSnapshot;
//   Widget allModelView(){
//     return Column(
//       children: [
//         Padding(
//           padding:
//           EdgeInsets.symmetric(horizontal: 20),
//           child: _sectionTile("All Model", () {
//             Navigator.push(context, MaterialPageRoute(builder: (c) => ModelListPage(customerId: widget.customerId,)));
//           }),
//         ),
//         SizedBox(height: 10),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           physics: BouncingScrollPhysics(),
//           child: StreamBuilder<AllModel>(
//               stream: allModelBloc.allModelStream,
//               builder: (c, s) {
//
//                 if (s.connectionState != ConnectionState.active) {
//                   print("all connection");
//                   return Container(height: 300,
//                       alignment: Alignment.center,
//                       child: Center(
//                         heightFactor: 50, child: CircularProgressIndicator(
//                         color: kPrimaryColor,
//                       ),));
//                 }
//                 if (s.hasError) {
//                   print("as3 error");
//                   return Container(height: 300,
//                     alignment: Alignment.center,
//                     child: Text("Error Loading Data",),);
//                 }
//                 if (s.data
//                     .toString()
//                     .isEmpty) {
//                   print("as3 empty");
//                   return Container(height: 300,
//                     alignment: Alignment.center,
//                     child: Text("No Data Found",),);
//                 }
//                 allModelSnapshot = s;
//                 print("object value for new arrival ${allModelSnapshot.data.data.first.modelNoId}");
//                 return Row(
//                   children: [
//                     ...List.generate(
//
//                       allModelSnapshot.data.data.length,
//                           (index) {
//                         return ModelCard(data: allModelSnapshot.data.data[index], snapshot: allModelSnapshot.data.data, orderCount: orderCount,customerId: widget.customerId,imagePath: allModelSnapshot.data.imagepath,customerName: widget.customerName,);
//                       },
//                     ),
//                     SizedBox(width: 20),
//                   ],
//                 );
//               }
//           ),
//         )
//       ],
//     );
//
//
//   }
//
//   Widget _categories(){
//     return StreamBuilder<CategoryModel>(
//         stream: categoryBloc.catStream,
//         builder: (c, s) {
//           if (s.connectionState != ConnectionState.active) {
//             print("all connection");
//             return Container(height: 300,
//                 alignment: Alignment.center,
//                 child: Center(
//                   heightFactor: 50, child: CircularProgressIndicator(
//                   color: kPrimaryColor,
//                 ),));
//           }
//           if (s.hasError) {
//             print("as3 error");
//             return Container(height: 300,
//               alignment: Alignment.center,
//               child: Text("Error Loading Data",),);
//           }
//           if (s.data
//               .toString()
//               .isEmpty) {
//             print("as3 empty");
//             return Container(height: 300,
//               alignment: Alignment.center,
//               child: Text("No Data Found",),);
//           }
//
//           return Padding(
//             padding: EdgeInsets.all(20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: List.generate(
//                 s.data.data.length,
//                     (index) => CategoryCard(
//                   icon: "assets/icons/sweetbox.svg",
//                   text: s.data.data[index].categoryName,
//                   press: () {
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>ModelFromCategoryPage(categoryId:s.data.data[index].categoryId ,categoryName: s.data.data[index].categoryName,customerId: widget.customerId,)));
//                     //Navigator.push(context, MaterialPageRoute(builder: (builder) => ProductCategoryPage(id: s.data.category[index].categoryId, name: s.data.category[index].categoryName,status: true,customerId: widget.customerId,)));
//                   },
//                 ),
//               ),
//             ),
//           );
//         }
//     );
//   }
//
//   AsyncSnapshot<ProductModel> news;
//   Widget _newArrival(){
//     return Column(
//       children: [
//         Padding(
//           padding:
//           EdgeInsets.symmetric(horizontal: 20),
//           child: _sectionTile("New Arrival Products", () {
//             Navigator.push(context, MaterialPageRoute(builder: (c) => ProductListPage(snapshot: news.data.product, title: "New Products", refresh: false,status: true,)));
//           }),
//         ),
//         SizedBox(height: 10),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           physics: BouncingScrollPhysics(),
//           child: StreamBuilder<ProductModel>(
//               stream: newProductBloc.newProductStream,
//               builder: (c, s) {
//
//                 if (s.connectionState != ConnectionState.active) {
//                   print("all connection");
//                   return Container(height: 300,
//                       alignment: Alignment.center,
//                       child: Center(
//                         heightFactor: 50, child: CircularProgressIndicator(
//                         color: kPrimaryColor,
//                       ),));
//                 }
//                 else if (s.hasError) {
//                   print("as3 error");
//                   return Container(height: 300,
//                     alignment: Alignment.center,
//                     child: Text("Error Loading Data",),);
//                 }
//                 else if (s.data
//                     .toString()
//                     .isEmpty) {
//                   print("as3 empty");
//                   return Container(height: 300,
//                     alignment: Alignment.center,
//                     child: Text("No Data Found",),);
//                 }
//                 else
//                   news = s;
//                 print("object value for new arrival ${news.data.product.first.id}");
//                 return news.data.product == [] ? Container(
//                   height: 300,
//                   child: Center(
//                     child: Text("No New Products Available"),
//                   ),
//                 ) :Row(
//                   children: [
//                     ...List.generate(
//
//                       news.data.product.length,
//                           (index) {
//                         return ProductCard(product: news.data.product[index], snapshot: news.data.product, orderCount: orderCount,customerId: widget.customerId,productId: news.data.product[index].id,);
//                       },
//                     ),
//                     SizedBox(width: 20),
//                   ],
//                 );
//               }
//           ),
//         )
//       ],
//     );
//   }
//
//   AsyncSnapshot<ProductModel> bests;
//   Widget _bestProduct(){
//     return Column(
//       children: [
//         Padding(
//           padding:
//           EdgeInsets.symmetric(horizontal: 20),
//           child: _sectionTile("Best Products", () {
//             Navigator.push(context, MaterialPageRoute(builder: (c) => ProductListPage(snapshot: bests.data.product, title: "New Products", refresh: false,status: true,)));
//           }),
//         ),
//         SizedBox(height: 10),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           physics: BouncingScrollPhysics(),
//           child: StreamBuilder<ProductModel>(
//               stream: bestProductBloc.bestProductStream,
//               builder: (c, s) {
//
//                 if (s.connectionState != ConnectionState.active) {
//                   print("all connection");
//                   return Container(height: 300,
//                       alignment: Alignment.center,
//                       child: Center(
//                         heightFactor: 50, child: CircularProgressIndicator(
//                         color: kPrimaryColor,
//                       ),));
//                 }
//                 if (s.hasError) {
//                   print("as3 error");
//                   return Container(height: 300,
//                     alignment: Alignment.center,
//                     child: Text("Error Loading Data",),);
//                 }
//                 if (s.data
//                     .toString()
//                     .isEmpty) {
//                   print("as3 empty");
//                   return Container(height: 300,
//                     alignment: Alignment.center,
//                     child: Text("No Data Found",),);
//                 }
//                 bests = s;
//                 print("object value for new arrival ${bests.data.product.first.id}");
//                 return bests.data.product == [] ? Container(
//                   height: 300,
//                   child: Center(
//                     child: Text("No New Products Available"),
//                   ),
//                 ) : Row(
//                   children: [
//                     ...List.generate(
//
//                       bests.data.product.length,
//                           (index) {
//                         return ProductCard(product: bests.data.product[index], snapshot: bests.data.product, orderCount: orderCount,productId: bests.data.product[index].id,customerId: widget.customerId,);
//                       },
//                     ),
//                     SizedBox(width: 20),
//                   ],
//                 );
//               }
//           ),
//         )
//       ],
//     );
//
//   }
//
//   AsyncSnapshot<ProductModel> accessories;
//   Widget _accessoryProduct(){
//     return Column(
//       children: [
//         Padding(
//           padding:
//           EdgeInsets.symmetric(horizontal: 20),
//           child: _sectionTile("Accessories", () {
//             Navigator.push(context, MaterialPageRoute(builder: (c) => AccessoryListPage( title: "Accessories List",snapshot: accessories.data.product,refresh: false,status: true,customerId: widget.customerId,)));
//           }),
//         ),
//         SizedBox(height: 10),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: StreamBuilder<ProductModel>(
//               stream: accessorBloc.newAccessoryStream,
//               builder: (c, s) {
//                 if (s.connectionState != ConnectionState.active) {
//                   print("all connection");
//                   return Container(height: 300,
//                       alignment: Alignment.center,
//                       child: Center(
//                         heightFactor: 50, child: CircularProgressIndicator(
//                         color: kPrimaryColor,
//                       ),));
//                 }
//                 if (s.hasError) {
//                   print("as3 error");
//                   return Container(height: 300,
//                     alignment: Alignment.center,
//                     child: Text("Error Loading Data",),);
//                 }
//                 if (s.data
//                     .toString()
//                     .isEmpty) {
//                   print("as3 empty");
//                   return Container(height: 300,
//                     alignment: Alignment.center,
//                     child: Text("No Data Found",),);
//                 }
//                 accessories = s;
//                 print("object value for new arrival ${accessories.data.product.first.id}");
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ...List.generate(
//                       accessories.data.product.length,
//                           (index) {
//                         return GestureDetector(
//                             onTap: (){
//                               //Navigator.push(context, MaterialPageRoute(builder: (c) => ProductDetailPage()));
//                             },
//                             child: AccessoryCard(product: accessories.data.product[index], snapshot: accessories.data.product, orderCount: orderCount,
//                               customerId: widget.customerId,
//                               productId: accessories.data.product[index].id,
//                             ));
//                       },
//                     ),
//                     SizedBox(width: 20),
//                   ],
//                 );
//               }
//           ),
//         )
//       ],
//     );
//   }
//
//   Widget _sectionTile(String title, Function press){
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: 18,
//             color: Colors.black,
//           ),
//         ),
//         GestureDetector(
//           onTap: press,
//           child: Text(
//             "See More",
//             style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//   AsyncSnapshot<ProductModel> all;
//   Widget _allProducts(){
//     return Column(
//       children: [
//         Padding(
//           padding:
//           EdgeInsets.symmetric(horizontal: 10),
//           child: _sectionTile("All Products", () {
//             Navigator.push(context, MaterialPageRoute(builder: (c) => ProductListPage(snapshot: all.data.product, title: "All Products", refresh: false,status: true,)));
//           }),
//         ),
//         SizedBox(height: 10),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           physics: BouncingScrollPhysics(),
//           child: StreamBuilder<ProductModel>(
//               stream: allProductBloc.allProductStream,
//               builder: (c, s) {
//
//                 if (s.connectionState != ConnectionState.active) {
//                   print("all connection");
//                   return Container(height: 300,
//                       alignment: Alignment.center,
//                       child: Center(
//                         heightFactor: 50, child: CircularProgressIndicator(
//                         color: kPrimaryColor,
//                       ),));
//                 }
//                 if (s.hasError) {
//                   print("as3 error");
//                   return Container(height: 300,
//                     alignment: Alignment.center,
//                     child: Text("Error Loading Data",),);
//                 }
//                 if (s.data
//                     .toString()
//                     .isEmpty) {
//                   print("as3 empty");
//                   return Container(height: 300,
//                     alignment: Alignment.center,
//                     child: Text("No Data Found",),);
//                 }
//                 all = s;
//                 print("object value for new arrival ${all.data.product.first.id}");
//                 return Row(
//                   children: [
//                     ...List.generate(
//
//                       all.data.product.length,
//                           (index) {
//                         return ProductCard(product: all.data.product[index], snapshot: all.data.product, orderCount: orderCount,);
//                       },
//                     ),
//                     SizedBox(width: 20),
//                   ],
//                 );
//               }
//           ),
//         ),
//       ],
//     );
//   }
//   AsyncSnapshot<ProductModel> futures;
//   Widget _futureProduct(){
//     return Column(
//       children: [
//         Padding(
//           padding:
//           EdgeInsets.symmetric(horizontal: 20),
//           child: _sectionTile("Upcoming Products", () {
//             Navigator.push(context, MaterialPageRoute(builder: (c) => ProductListPage(snapshot: futures.data.product, title: "UpComing Products", refresh: false,status: true,)));
//           }),
//         ),
//         SizedBox(height: 10),
//         SingleChildScrollView(
//           physics: BouncingScrollPhysics(),
//           scrollDirection: Axis.horizontal,
//           child: StreamBuilder<ProductModel>(
//               stream: futureProductBloc.futureProductStream,
//               builder: (c, s) {
//
//                 if (s.connectionState != ConnectionState.active) {
//                   print("all connection");
//                   return Container(height: 300,
//                       alignment: Alignment.center,
//                       child: Center(
//                         heightFactor: 50, child: CircularProgressIndicator(
//                         color: kPrimaryColor,
//                       ),));
//                 }
//                 if (s.hasError) {
//                   print("as3 error");
//                   return Container(height: 300,
//                     alignment: Alignment.center,
//                     child: Text("Error Loading Data",),);
//                 }
//                 if (s.data.product == null) {
//                   print("as3 empty");
//                   return Container(height: 300,
//                     alignment: Alignment.center,
//                     child: Text("No Data Found",),);
//                 }
//                 futures = s;
//                 print("object value for new arrival ${futures.data.product.first.id}");
//                 return Row(
//                   children: [
//                     ...List.generate(
//                       futures.data.product.length,
//                           (index) {
//                         return ProductCard(product: futures.data.product[index],snapshot: futures.data.product, orderCount: orderCount,);
//                       },
//                     ),
//                     SizedBox(width: 20),
//                   ],
//                 );
//               }
//           ),
//         )
//       ],
//     );
//   }
//
// }
//
// class CategoryCard extends StatelessWidget {
//   const CategoryCard({
//     Key key,
//     @required this.icon,
//     @required this.text,
//     @required this.press,  this.image,
//   }) : super(key: key);
//
//   final String icon, text, image;
//   final GestureTapCallback press;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: press,
//       child: SizedBox(
//         width: 60,
//         child: Column(
//           children: [
//             Container(
//               padding: EdgeInsets.all(15),
//               height: 60,
//               width: 60,
//               decoration: BoxDecoration(
//                 color: Color(0xFFFFECDF),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: SvgPicture.asset(icon),
//             ),
//             SizedBox(height: 5),
//             Text(text, textAlign: TextAlign.center)
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ProductCard extends StatelessWidget {
//   const ProductCard({
//     this.width = 150,
//     this.aspectRatio = 1.02,
//     @required this.product,
//     @required this.snapshot,
//     @required this.orderCount, this.customerId, this.productId});
//
//   final double width, aspectRatio;
//   final customerId , productId;
//   final Product product;
//   final List<Product> snapshot;
//   final int orderCount;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(left: 20),
//       child: SizedBox(
//         width: width,
//         child: GestureDetector(
//           onTap: () =>   Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductFromModelDetailPage(
//             customerId: customerId,
//             productId: productId,
//           ))),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(height: 10,),
//               Container(
//                 child: AspectRatio(
//                   aspectRatio: 5/5,
//                   child: Hero(
//                     tag: product.id.toString(),
//                     child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [BoxShadow(
//                               color: Colors.grey,
//                               blurRadius: 5.0,
//                             ),],
//                             color: kWhiteColor
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child:Image.network("http://loccon.in/desiremoulding/upload/Image/Product/${product.image[0]}"),
//                         )),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Flexible(
//                 child: Text(
//                   product.productName.toUpperCase(),
//                   style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),
//                   //maxLines: 1,
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "MRP: " "₹${product.customerprice}",
//                     style: TextStyle(
//                       decoration:   product.customernewprice == "" ?TextDecoration.none: TextDecoration.lineThrough,
//                       fontSize:  product.customernewprice == "" ? 14:12,
//                       fontWeight: FontWeight.w600,
//                       color: product.customernewprice == "" ? kPrimaryColor :kSecondaryColor,
//                     ),
//                   ),
//                   Text(
//                     product.customernewprice == "" ? "": "Your Price: "+"₹${product.customernewprice}",
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color:kPrimaryColor,
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// class AccessoryCard extends StatelessWidget {
//   const AccessoryCard({
//     this.width = 140,
//     this.aspectRatio = 1.02,
//     @required this.product,
//     @required this.snapshot,
//     @required this.orderCount,
//     @required this.productModel,
//     this.customerId,
//     this.productId
//   });
//
//   final double width, aspectRatio;
//   final customerId,productId;
//   final Product product;
//   final ProductModel productModel;
//   final List<Product> snapshot;
//   final int orderCount;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Padding(
//       padding: EdgeInsets.only(left: 20,right: 10),
//       child: SizedBox(
//         width: width,
//         child: GestureDetector(
//           onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductFromModelDetailPage(
//             customerId: customerId,
//             productId: productId,
//           ))),
//           child:  Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(height: 10,),
//               Container(
//                 child: AspectRatio(
//                   aspectRatio: 5/5,
//                   child: Hero(
//                     tag: product.id.toString(),
//                     child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [BoxShadow(
//                               color: Colors.grey,
//                               blurRadius: 5.0,
//                             ),],
//                             color: kWhiteColor
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Image.network("${productModel.imagepath}"+"${product.image[0]}"),
//                         )),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 height: 30,
//                 child: Text(
//                   product.productName,
//                   style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),
//                   //maxLines: 1,
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "MRP: " "₹${product.customerprice}",
//                     style: TextStyle(
//                       decoration:   product.customernewprice == "" ?TextDecoration.none: TextDecoration.lineThrough,
//                       fontSize: product.customernewprice == "" ? 14:12,
//                       fontWeight: FontWeight.w600,
//                       color: product.customernewprice == "" ? kPrimaryColor :kSecondaryColor,
//                     ),
//                   ),
//                   Text(
//                     product.customernewprice == "" ? "": "Your Price "+"₹${product.customernewprice}",
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.w600,
//                       color:kPrimaryColor,
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
// class ModelCard extends StatelessWidget {
//   const ModelCard({
//     this.width = 150,
//     this.aspectRatio = 1.02,
//     @required this.data,
//     @required this.snapshot,
//     @required this.orderCount, this.allModel, this.customerId,this.imagePath,this.customerName
//   });
//
//
//   final Data data;
//   final AllModel allModel;
//   final List<Data> snapshot;
//   final double width, aspectRatio;
//   final customerId,customerName;
//   final imagePath;
//   final int orderCount;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(left: 20),
//       child: SizedBox(
//         width: width,
//         child: GestureDetector(
//           onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductFromModelPage(
//             customerId: customerId ,
//             modelNo:data.modelNo ,
//             modelNoId:  data.modelNoId,
//             customerName: customerName,
//           ))),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(height: 10,),
//               Container(
//                 child: AspectRatio(
//                   aspectRatio: 5/5,
//                   child: Hero(
//                     tag: data.modelNoId.toString(),
//                     child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [BoxShadow(
//                               color: Colors.grey,
//                               blurRadius: 5.0,
//                             ),],
//                             color: kWhiteColor
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Image.network("$imagePath"+"${data.image}"),
//                         )),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Flexible(
//                 child: Text(
//                   "Model No." + data.modelNo.toUpperCase(),
//                   style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),
//                   //maxLines: 1,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
