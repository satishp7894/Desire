import 'package:desire_users/pages/intro/verify_kyc_screen.dart';
import 'package:desire_users/pages/intro/verify_kyc_screen_old.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectCardType extends StatefulWidget {
  final String userId;

  const SelectCardType({Key key, this.userId}) : super(key: key);

  @override
  _SelectCardTypeState createState() => _SelectCardTypeState();
}

class _SelectCardTypeState extends State<SelectCardType> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build,
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("KYC Form"),
          titleTextStyle: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: kBlackColor),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return Padding(
        padding: const EdgeInsets.only(top: 20, right: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                child: Container(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/gst.png",
                        height: 150,
                      ),
                      Text(
                        "KYC with GST Number",
                        style: TextStyle(color: kPrimaryColor, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => VerifyKycScreen(
                              userId: widget.userId, type: "0")))
                },
              ),
              Text(
                "Or",
                style: TextStyle(color: kPrimaryColor, fontSize: 16),
              ),
              InkWell(
                child: Container(
                    child: Column(children: [
                  Image.asset("assets/images/pan.png", height: 150),
                  Text(
                    "KYC with Pan Card Number ",
                    style: TextStyle(color: kPrimaryColor, fontSize: 16,fontWeight: FontWeight.bold),
                  ),
                ])),
                onTap:() => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => VerifyKycScreen(
                              userId: widget.userId, type: "1")))
                },
              )
            ],
          ),
        ));
  }
}
