import 'package:desire_production/bloc/dashboard_bloc.dart';
import 'package:desire_production/bloc/warehouse_list_bloc.dart';
import 'package:desire_production/model/dashboard_count_model.dart';
import 'package:desire_production/model/warehouse_list_model.dart';
import 'package:desire_production/pages/admin/admin_user_list_page.dart';
import 'package:desire_production/pages/admin/customer/add_customer_page.dart';
import 'package:desire_production/pages/admin/customer/customer_list_page.dart';
import 'package:desire_production/pages/admin/products/category_list_page.dart';
import 'package:desire_production/pages/admin/products/dimension_list_page.dart';
import 'package:desire_production/pages/admin/products/model_list_page.dart';
import 'package:desire_production/pages/admin/products/product_list_page.dart';
import 'package:desire_production/pages/admin/sales/brochure_page.dart';
import 'package:desire_production/pages/admin/sales/customer_credit_page.dart';
import 'package:desire_production/pages/production/pendingOrdersPage.dart';
import 'package:desire_production/pages/production/dailyProductionListPage.dart';
import 'package:desire_production/pages/production/production_planning_page.dart';
import 'package:desire_production/pages/warehouse/warehouse_list_page.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'production_dashboard_page.dart';

class DashboardPageAdmin extends StatefulWidget {

  @override
  _DashboardPageAdminState createState() => _DashboardPageAdminState();
}

class _DashboardPageAdminState extends State<DashboardPageAdmin> {

  Size deviceSize;

  final dashboardBloc = DashboardBloc();
  final warHouseBloc = WarhouseListBloc();

  List profileItems = [];

  String userId;

  WareHouseListModel model;

  @override
  void initState() {
    super.initState();
    dashboardBloc.fetchDashboardCount();
    warHouseBloc.fetchWarehouseList();
    getId();
  }

  getId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("id");
    print("object user id $userId");
  }

  @override
  void dispose() {
    super.dispose();
    dashboardBloc.dispose();
    warHouseBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Alerts.showAlertExit(context, "Exit", "Are you sure?");
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            toolbarHeight: 20,
            titleSpacing: 0.0,
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: _body(),
        ),
      ),
    );
  }

  Widget _body(){
    deviceSize = MediaQuery.of(context).size;
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: (){
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (b) => DashboardPageAdmin()), (route) => false);
      },
      child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(left: 20.0, right: 20.0,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              profileDetail(),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (b) => AdminUserListPage(adminUserId: userId,)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/user_list.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'User List Page',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Add/Update/Delete User',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (b) => ModelListPage(userId: userId,)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/model_list.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Model List Page',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Add/Update/Delete Model',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (b) => CategoryListPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/category.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Category List Page',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Add/Update/Delete Category',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (b) => DimensionListPage()));
                },
                child: Container(

                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/dimensions.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Dimension List Page',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Add/Update/Delete Size',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (b) => ProductListPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/product_list.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Product List Page',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Add/Update/Delete Products',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              // GestureDetector(
              //   onTap: (){
              //     Navigator.push(context, MaterialPageRoute(builder: (b) => SalesManListPage()));
              //   },
              //   child: Container(
              //     height: deviceSize.height * 0.1,
              //     margin: EdgeInsets.only(top: 10, bottom: 10),
              //     decoration: BoxDecoration(
              //       boxShadow: [
              //         BoxShadow(
              //           color: kPrimaryLightColor,
              //           blurRadius: 5, // has the effect of softening the shadow
              //           spreadRadius: 0, // has the effect of extending the shadow
              //         ),
              //       ],
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(
              //         20.0,
              //       ),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: <Widget>[
              //           Row(
              //             crossAxisAlignment: CrossAxisAlignment.center,
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: <Widget>[
              //               SvgPicture.asset(
              //                 "assets/icons/User.svg",
              //                 color: kPrimaryColor,
              //                 width: 30,
              //               ),
              //               Container(
              //                 margin: EdgeInsets.only(left: 30),
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: <Widget>[
              //                     Text(
              //                       'Salesman',
              //                       style: TextStyle(
              //                         fontSize: 18.0,
              //                         color: Colors.black,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                     Text(
              //                       'List of Salesman',
              //                       style: TextStyle(
              //                         fontSize: 14.0,
              //                         color: profile_item_color,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               )
              //             ],
              //           ),
              //           Icon(
              //             Icons.chevron_right,
              //             color: profile_item_color,
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (b) => AddCustomerPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/add_user.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'New Customer',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Add New Customer',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (b) => CustomerListPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/user_icon.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Customers',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'List of Customers',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (b) => CustomerCreditPage()));
                },
                child: Container(

                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/user_credit.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Customer Credit',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'List of Customer Credit',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BrochurePage(page: 'admin',)), (route) => false);
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/brochure.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Brochure',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Create Brochure',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (b) => DailyProductionListPage(page: "admin",)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/production_order.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Production Order',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'List of Orders',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (b) => PendingOrdersPage(page: "admin",)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/daily_production.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Daily Production',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'List of Products with Quantity',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (b) => ProductionPlanningPage(page: "admin",)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/production_planning.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Production Planning',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'List Products for Planning',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  showDialog(context: context, builder: (builder) => SendNotificationDialog(context: context));
                },
                child: Container(

                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/notifications.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Product Notification',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Send notification for products',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (b) => WarehouseListPage(page: "admin",)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/warehouse.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Warehouse List',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Product ready to Dispatch',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  //Navigator.push(context, MaterialPageRoute(builder: (b) => ProductionOrderPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/profile.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'My Profile',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Your Details',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  Alerts.showLogOut(context, "Log Out", "Are you sure?");
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryLightColor,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius: 0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              "assets/images/logout.png",
                              color: kPrimaryColor,
                              height: 40,
                              width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30),
                              alignment: Alignment.center,
                              child: Text(
                                'Log Out',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: profile_item_color,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),
      ),
    );
  }

  Widget profileDetail(){
    deviceSize = MediaQuery.of(context).size;
    return Material(
      borderRadius: BorderRadius.all(
        Radius.circular(20.0),
      ),
      elevation: 10.0,
      child: Container(
        alignment: Alignment.center,
        height: deviceSize.height * 0.25,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: kPrimaryColor,
        //  gradient: kPrimaryGradientColor,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Admin Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<DashboardCountModel>(
                  stream: dashboardBloc.dashStream,
                  builder: (c, s) {

                    return StreamBuilder<WareHouseListModel>(
                        stream: warHouseBloc.warhouseStream,
                        builder: (c, sw) {

                          if (sw.connectionState != ConnectionState.active || s.connectionState != ConnectionState.active) {
                            print("all connection");
                            return Container(height: 50,
                                alignment: Alignment.center,
                                child: Center(
                                  heightFactor: 50, child: CircularProgressIndicator(
                                  color: kPrimaryColor,
                                ),));
                          }
                          if (s.hasError || sw.hasError) {
                            print("as3 error");
                            return Container(height: 30,
                              alignment: Alignment.center,
                              child: Text("Error Loading Data",),);
                          }
                          if (s.data.count == null || sw.data.status == false) {
                            print("as3 empty");
                            return Container(height: 30,
                              alignment: Alignment.center,
                              child: Text("No Orders Found",),);
                          }

                          profileItems = [
                            {'count': '${s.data.count.order[0].cnt}', 'name': 'Total\nOrders'},
                            {'count': '${s.data.count.dailyproduction[0].cnt}', 'name': 'Daily\nProduction'},
                            {'count': '${s.data.count.productionplanning[0].cnt}', 'name': 'Production\nPlanning'},
                            {'count': '${sw.data.status}', 'name': 'Warehouse\nList'},
                          ];

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              for (var item in profileItems)
                                Column(
                                  children: <Widget>[
                                    Text(
                                      item['count'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      item['name'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          );
                        }
                    );
                  }
              )
            ],
          ),
        ),
      ),
    );
  }

}
