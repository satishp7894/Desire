import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

class ConceptsPage extends StatefulWidget {
  @override
  _ConceptsPageState createState() => _ConceptsPageState();
}

class _ConceptsPageState extends State<ConceptsPage> {

  TextEditingController text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    text = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    text.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          //height: 100,
          width: 100,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: text,
              ),
              TextButton(
                  onPressed: (){
                    print("md5 value ${md5.convert(utf8.encode(text.text)).toString()}");
                  },
                  child: Text("Convert")),
            ],
          ),
        ),
      ),
    );
  }
}
