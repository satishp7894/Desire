import 'dart:convert';
import 'dart:io';
import 'package:desire_production/bloc/production_dashboard_bloc.dart';
import 'package:desire_production/model/dashboard_production_model.dart';
import 'package:desire_production/model/product_model.dart';
import 'package:desire_production/pages/dashboards/admin_dashboard_page.dart';
import 'package:desire_production/pages/production/customer_complaint_page.dart';
import 'package:desire_production/pages/production/productionUserProfile.dart';
import 'package:desire_production/pages/warehouse/dispatch_to_warehouse.dart';
import 'package:http/http.dart' as http;

import 'package:desire_production/bloc/dashboard_bloc.dart';
import 'package:desire_production/bloc/product_list.dart';
import 'package:desire_production/model/dashboard_count_model.dart';
import 'package:desire_production/pages/production/pendingOrdersPage.dart';
import 'package:desire_production/pages/production/dailyProductionListPage.dart';
import 'package:desire_production/pages/production/production_planning_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DashboardPageProduction extends StatefulWidget {
  final page;

  DashboardPageProduction({this.page});

  @override
  _DashboardPageProductionState createState() =>
      _DashboardPageProductionState();
}

class _DashboardPageProductionState extends State<DashboardPageProduction> {
  final dashboardBloc = ProductionDashboardBloc();

  List profileItems = [];

  Size deviceSize;

  @override
  void initState() {
    super.initState();
    dashboardBloc.fetchProductionDashboardCount();
  }

  @override
  void dispose() {
    super.dispose();
    dashboardBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return widget.page == "production"
            ? Alerts.showAlertExit(context, "Exit", "Are you sure?")
            : Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
                return AdminDashboardPage();
              }));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "DASHBOARD",
            style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    deviceSize = MediaQuery.of(context).size;
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () {
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (b) => DashboardPageProduction(
                      page: widget.page,
                    )),
            (route) => false);
      },
      child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              profileDetail(),
              SizedBox(
                height: 20,
              ),
              /*GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (b) => ProductionUserProfile(
                                page: widget.page,
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius:
                            0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/user.png",
                          color: kPrimaryColor,
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Profile',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Production User Profile',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: profile_item_color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),*/
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (b) => PendingOrdersPage(
                                page: widget.page,
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius:
                            0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/production_order.png",
                          color: kPrimaryColor,
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Pending Orders',
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
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (b) => PendingOrdersPage(
                            page: "daily",
                          )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius:
                        0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/production_order.png",
                          color: kPrimaryColor,
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Daily Orders',
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
                      ],
                    ),
                  ),
                ),
              ), SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (b) => DailyProductionListPage(
                                page: widget.page,
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius:
                            0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/daily_production.png",
                          color: kPrimaryColor,
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              'List of Production',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: profile_item_color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (b) => DispatchtoWarehouse()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius:
                            0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/warehouse.png",
                          color: kPrimaryColor,
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Dispatch to Warehouse',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Dispatch to Warehouse',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: profile_item_color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (b) => ProductionPlanningPage(
                                page: widget.page,
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius:
                            0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/production_planning.png",
                          color: kPrimaryColor,
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                              'List of Production Planning',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: profile_item_color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              /* GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius:
                            0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/notifications.png",
                          color: kPrimaryColor,
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Notifications',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Send Notifications',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: profile_item_color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),*/
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (b) => CustomerComplaintPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5, // has the effect of softening the shadow
                        spreadRadius:
                            0, // has the effect of extending the shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      5.0,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/user.png",
                          color: kPrimaryColor,
                          height: 40,
                          width: 40,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Customer Complaint',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'List of customer complaint',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: profile_item_color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              widget.page == "admin"
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        Alerts.showLogOut(context, "Logout",
                            "Are you sure you want to logout");
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius:
                                  5, // has the effect of softening the shadow
                              spreadRadius:
                                  0, // has the effect of extending the shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            5.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "assets/images/logout.png",
                                color: kPrimaryColor,
                                height: 40,
                                width: 40,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Production Logout',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: profile_item_color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
            ],
          )),
    );
  }

  Widget profileDetail() {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Production & Planning',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            StreamBuilder<ProductionDashBoardModel>(
                stream: dashboardBloc.productionDashboardStream,
                builder: (c, s) {
                  if (s.connectionState != ConnectionState.active) {
                    print("all connection");
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Daily Orders",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Daily Production",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Pending Orders",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (s.hasError) {
                    print("as3 error");
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Daily Orders",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Daily Production",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Pending Orders",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (s.data == null) {
                    print("as3 empty");
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Daily Orders",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Daily Production",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Pending Orders",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "0",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Daily Orders",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${s.data.totalDailyOrder}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Daily Production",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${s.data.totalProductionOrder}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Pending Orders",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${s.data.totalPendingOrder}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}

class SendNotificationDialog extends StatefulWidget {
  final BuildContext context;

  const SendNotificationDialog({@required this.context});

  @override
  _SendNotificationDialogState createState() => _SendNotificationDialogState();
}

class _SendNotificationDialogState extends State<SendNotificationDialog> {
  final productBloc = ProductListBloc();

  BuildContext contextDialog;

  List<String> productList = [];
  List<Product> product1 = [];

  String product;

  @override
  void initState() {
    super.initState();
    contextDialog = widget.context;
    productBloc.fetchProductList();
  }

  @override
  void dispose() {
    super.dispose();
    productBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: Text(
              'Send Product Notification to Sales',
              textAlign: TextAlign.center,
            ),
            content: Container(
              height: 200,
              margin: EdgeInsets.only(top: 5),
              alignment: Alignment.center,
              child: StreamBuilder<ProductModel>(
                  stream: productBloc.productStream,
                  builder: (c, s) {
                    if (s.connectionState != ConnectionState.active) {
                      print("all connection");
                      return Container(
                          height: 300,
                          alignment: Alignment.center,
                          child: Center(
                            heightFactor: 50,
                            child: CircularProgressIndicator(),
                          ));
                    }
                    if (s.hasError) {
                      print("as3 error");
                      return Container(
                        height: 300,
                        alignment: Alignment.center,
                        child: Text(
                          "Error Loading Data",
                        ),
                      );
                    }
                    if (s.data.product.length == 0) {
                      print("as3 empty");
                      return Container(
                        height: 300,
                        alignment: Alignment.center,
                        child: Text(
                          "No Products Found",
                        ),
                      );
                    }

                    product1 = s.data.product;

                    for (int i = 0; i < s.data.product.length; i++) {
                      productList.add(s.data.product[i].productName);
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Select the product required"),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownSearch<String>(
                          validator: (v) => v == null ? "required field" : null,
                          mode: Mode.MENU,
                          dropdownSearchDecoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 30, right: 20, top: 5, bottom: 5),
                            alignLabelWithHint: true,
                            hintText: "Product List",
                            hintStyle: TextStyle(color: Colors.black45),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(30)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(30)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          showSelectedItem: true,
                          items: productList,
                          onChanged: (value) {
                            setState(() {
                              product = value;
                            });
                            print("product selected: $product");
                          },
                          //selectedItem: "Please Select your Area",
                        ),
                      ],
                    );
                  }),
            ),
            actions: <Widget>[
              CupertinoButton(
                child: Text(
                  "Send",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  String id;
                  for (int i = 0; i < product1.length; i++) {
                    print("${product1[i].productName}");
                    if (product == product1[i].productName) {
                      print(
                          "object $product ${product1[i].productName} ${product1[i].id}");
                      setState(() {
                        id = product1[i].id;
                      });
                    }
                  }
                  print("object product name and id $product $id");
                  sendNotification(id);
                  //Navigator.of(contextDialog).pop();
                },
              ),
            ],
          )
        : AlertDialog(
            title: Text(
              'Send Product Notification to Sales',
              textAlign: TextAlign.center,
            ),
            content: Container(
              height: 200,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 5),
              child: StreamBuilder<ProductModel>(
                  stream: productBloc.productStream,
                  builder: (c, s) {
                    if (s.connectionState != ConnectionState.active) {
                      print("all connection");
                      return Container(
                          height: 300,
                          alignment: Alignment.center,
                          child: Center(
                            heightFactor: 50,
                            child: CircularProgressIndicator(),
                          ));
                    }
                    if (s.hasError) {
                      print("as3 error");
                      return Container(
                        height: 300,
                        alignment: Alignment.center,
                        child: Text(
                          "Error Loading Data",
                        ),
                      );
                    }
                    if (s.data.product.length == 0) {
                      print("as3 empty");
                      return Container(
                        height: 300,
                        alignment: Alignment.center,
                        child: Text(
                          "No Products Found",
                        ),
                      );
                    }

                    product1 = s.data.product;

                    for (int i = 0; i < s.data.product.length; i++) {
                      productList.add(s.data.product[i].productName);
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Select the product required"),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownSearch<String>(
                          validator: (v) => v == null ? "required field" : null,
                          mode: Mode.MENU,
                          dropdownSearchDecoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 30, right: 20, top: 5, bottom: 5),
                            alignLabelWithHint: true,
                            hintText: "Product List",
                            hintStyle: TextStyle(color: Colors.black45),
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(30)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(30)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          showSelectedItem: true,
                          items: productList,
                          onChanged: (value) {
                            setState(() {
                              product = value;
                            });
                            print("product selected: $product");
                          },
                          //selectedItem: "Please Select your Area",
                        ),
                      ],
                    );
                  }),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "Send",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  String id;
                  for (int i = 0; i < product1.length; i++) {
                    print("${product1[i].productName} ${product1[i].id}");
                    if (product == product1[i].productName) {
                      print(
                          "object $product ${product1[i].productName} ${product1[i].id}");
                      setState(() {
                        id = product1[i].id;
                      });
                    }
                  }
                  print("object product name and id $product $id");
                  sendNotification(id);
                  // Navigator.of(contextDialog).pop();
                },
              ),
            ],
          );
  }

  sendNotification(String idPro) async {
    print("object $idPro");
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),
    );
    pr.show();
    var response = await http
        .post(Uri.parse(Connection.productiontoNotificationSales), body: {
      'secretkey': Connection.secretKey,
      'title': 'product required',
      'product': '$idPro'
    });
    print("object ${response.body}");

    var results = json.decode(response.body);
    print("object $results");
    pr.hide();
    if (results['status'] == true) {
      Navigator.of(contextDialog).pop();
    } else {
      Alerts.showAlertAndBack(
          context, "Notification Send Failed", "Something Went Wrong");
    }
  }
}
