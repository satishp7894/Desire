import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Contact Us"),
          centerTitle: true,
          elevation: 0,
          backgroundColor:kSecondaryColor.withOpacity(0),
          titleTextStyle: headingStyle,
          textTheme: Theme.of(context).textTheme,
        ),
        body: _body(),
      ),
    );
  }

  Widget _body(){
    return Scaffold();
  }

}
