import 'dart:async';
import 'package:desire_users/pages/home/home_page.dart';
import 'package:desire_users/pages/intro/kyc_pagen.dart';
import 'package:desire_users/pages/intro/new_login_page.dart';
import 'package:desire_users/pages/intro/sales_login_page.dart';
import 'package:desire_users/pages/intro/success_page.dart';
import 'package:desire_users/pages/introSlider/into_slider_page.dart';
import 'package:desire_users/sales/pages/sales_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  AnimationController animationController;
  Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);
    String login = prefs.getString("login");
    if (login == "sales") {
      if (prefs.getBool('sales_remember') != null &&
          prefs.getBool('sales_remember')) {
        setState(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (builder) => SalesHomePage(
                        salesManId: prefs.getString("sales_id"),
                      )),
              (route) => false);
        });
      } else {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (builder) => SalesLoginPage()),
            (route) => false);
      }
    } else {
      if (prefs.getBool('remember') != null && prefs.getBool('remember')) {
        setState(() {
          prefs.getString("kycStats") == "0"
              ? Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => KYCPageN(
                            userId: prefs.getString("customer_id"),
                          )),
                  (Route<dynamic> route) => false)
              : prefs.getString("kyc") == "1"
                  ? Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                status: true,
                                customerId: prefs.getString("customer_id"),
                                customerName: prefs.getString("Customer_name"),
                                customerEmail: prefs.getString("Email"),
                                mobileNo: prefs.getString("Mobile_no"),
                                salesmanId: prefs.getString("salesmanId"),
                              )),
                      (Route<dynamic> route) => false)
                  : Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SuccessPage(
                              userId: prefs.getString("customer_id"))),
                      (Route<dynamic> route) => false);
        });
      } else {
        if (_seen) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (builder) => NewLoginPage()),
              (route) => false);
        } else {
          await prefs.setBool('seen', true);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (builder) => IntroSliderPage()),
              (route) => false);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation = new CurvedAnimation(
        parent: animationController, curve: Curves.elasticInOut);

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
