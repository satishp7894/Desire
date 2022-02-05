import 'dart:async';
import 'package:desire_production/pages/dashboards/admin_dashboard_page.dart';
import 'package:desire_production/pages/dashboards/collection_dashboard_page.dart';
import 'package:desire_production/pages/dashboards/dashboard_page_warhouse.dart';
import 'package:desire_production/pages/dashboards/production_dashboard_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;

  AnimationController animationController;
  Animation<double> animation;
  String adminRoleId = "1";
  String productionRoleId = "4";
  String wareHouseRoleId = "5";
  String collectionRoleId = "6";

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('remember') != null && prefs.getBool('remember')) {
      setState(() {
        if (prefs.getString("role_id") == adminRoleId) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => AdminDashboardPage()),
              (route) => false);
        } else if (prefs.getString("role_id") == productionRoleId) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (builder) => DashboardPageProduction(
                        page: 'production',
                      )),
              (route) => false);
        } else if (prefs.getString("role_id") == wareHouseRoleId) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (builder) => DashboardPageWarehouse(
                        page: "warHouse",
                      )),
              (route) => false);
        } else if (prefs.getString("role_id") == collectionRoleId) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (builder) => CollectionDashboardPage()),
              (route) => false);
        }
      });
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (builder) => LoginPage()),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: new Image.asset(
              'assets/images/splash_logo.png',
              width: animation.value * 250,
              height: animation.value * 250,
            ),
          ),
        ],
      ),
    );
  }
}
