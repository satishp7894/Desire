import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/models/sales_customer_list_model.dart';
import 'package:desire_users/sales/bloc/customer_bloc.dart';
import 'package:desire_users/sales/pages/brochure/brochure_page.dart';
import 'package:desire_users/sales/pages/chatting/sales_chat_list.dart';
import 'package:desire_users/sales/pages/customer/add_customer_page.dart';
import 'package:desire_users/sales/pages/customer/customer_list_page.dart';
import 'package:desire_users/sales/pages/customerCredit/customer_credit_page.dart';
import 'package:desire_users/sales/pages/orders/customerOrdersListPage.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile/sales_profile_page.dart';

class SalesHomePage extends StatefulWidget {
  final String salesManId;
  SalesHomePage({this.salesManId});

  @override
  _SalesHomePageState createState() => _SalesHomePageState();
}

class _SalesHomePageState extends State<SalesHomePage> {
  static String salesId;
  static String salesManId;
  static String salesEmail;
  static String salesName;

  // final customerBloc = CustomerListBloc();

  List<UserModel> customerList = [];
  final customerBloc = CustomerListBloc();

  File imageFile;
  String path;

  @override
  void initState() {
    super.initState();

    checkConnectivity();
    salesManId = widget.salesManId;
    print("SalesMan Id :" + salesManId);
    getSalesDetails();
  }

  checkConnectivity() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(
          context, "No Internet Connection", "Please check your internet");
    }
  }

  getSalesDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    salesId = prefs.getString("sales_id");
    print("SalesMan Id :" + salesId);
    salesEmail = prefs.getString("sales_email");
    salesName = prefs.getString("sales_name");
    //customerBloc.fetchCustomerList(salesId);

    print("object of image file ${prefs.getString("profilepath")}");
    if (prefs.getString("profilepath") != null) {
      path = prefs.getString("profilepath");
    }
  }

  @override
  void dispose() {
    super.dispose();
    //customerBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Alerts.showExit(context, "Exit", "Are you sure?");
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: kWhiteColor,
            title: Text(
              "Dashboard",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: kPrimaryColor),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    logoutDialog();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: kPrimaryColor,
                    size: 30,
                  ))
            ],
          ),
          body: dashBoardScreenView(),
        ),
      ),
    );
  }



  void logoutDialog() {
    return Alerts.showSalesLogOut(context, "LOGOUT", "Are you sure?");
  }




  Widget dashBoardScreenView() {
    return GridView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddCustomerPage(
                  salesId: salesManId, email: salesEmail, name: salesName);
            }));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                  color: kPrimaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/add_user.png",
                    height: 40,
                    width: 40,
                    color: kWhiteColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Add New Customer",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CustomerListPage(
                  salesId: salesManId, email: salesEmail, name: salesName);
            }));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                  color: kSecondaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/user_list.png",
                    height: 40,
                    width: 40,
                    color: kWhiteColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Customer List",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CustomerCreditPage(
                  salesId: salesManId, email: salesEmail, name: salesName);
            }));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                  color: kSecondaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/user_credit.png",
                    height: 40,
                    width: 40,
                    color: kWhiteColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Customer Credit List",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return BrochurePage(
                  salesId: salesManId, email: salesEmail, name: salesName);
            }));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                  color: kPrimaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/brochure.png",
                    height: 40,
                    width: 40,
                    color: kWhiteColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Create Brochure",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SalesProfilePage();
            }));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                  color: kPrimaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/profile.png",
                    height: 40,
                    width: 40,
                    color: kWhiteColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return CustomerOrdersListPage(
                  salesManId: widget.salesManId,salesManName: salesName,);
            }));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                  color: kSecondaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/production_order.png",
                    height: 40,
                    width: 40,
                    color: kWhiteColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Customer Orders",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return CustomerCreditPage(
            //       salesId: salesManId, email: salesEmail, name: salesName);
            // }));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                  color: kSecondaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/icons/Bell.svg",
                    height: 40,
                    width: 40,
                    color: kWhiteColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Notifications",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return CustomerOrdersListPage(
            //     salesManId: widget.salesManId,salesManName: salesName,);
            // }));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                  color: kPrimaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/production_order.png",
                    height: 40,
                    width: 40,
                    color: kWhiteColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Ready Stock",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SalesChatList(
                salesId: widget.salesManId);
            }));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                  color: kPrimaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Icon(
                    Icons.message,
                   size: 40,
                    color: kWhiteColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Chat",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kWhiteColor),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
