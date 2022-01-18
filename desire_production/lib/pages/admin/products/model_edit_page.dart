import 'dart:convert';

import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/model_listing_model.dart';
import 'package:desire_production/pages/admin/products/model_list_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/drawer_admin.dart';
import 'package:desire_production/utils/progress_dialog.dart';

import 'package:desire_production/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ModelEditPage extends StatefulWidget {

  final ModelList model;
  final String userId;

  const ModelEditPage({@required this.model, @required this.userId});

  @override
  _ModelEditPageState createState() => _ModelEditPageState();
}

class _ModelEditPageState extends State<ModelEditPage>  with Validator{

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController model;
  TextEditingController sPrice;
  TextEditingController dPrice;
  TextEditingController nPrice;
  TextEditingController cPrice;

  @override
  void initState() {
    super.initState();
    model = TextEditingController(text: widget.model.modelNo);
    sPrice = TextEditingController(text: "100");
    dPrice = TextEditingController(text: "120");
    nPrice = TextEditingController(text: "120");
    cPrice = TextEditingController(text: "100");
  }

  @override
  void dispose() {
    super.dispose();
    model.dispose();
    sPrice.dispose();
    dPrice.dispose();
    nPrice.dispose();
    cPrice.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => ModelListPage(userId: widget.userId,)));
      },
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              // leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => SalesHomePage()));
              // },),
              title: Text("Product Details", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
              centerTitle: true,
              leading: Builder(
                builder: (c){
                  return IconButton(icon: Image.asset("assets/images/logo_new.png"), onPressed: (){
                    Scaffold.of(c).openDrawer();
                  },);
                },
              ),
              actions: [
                PopupMenuButton(
                    icon: Icon(Icons.settings_outlined, color: Colors.black,),
                    itemBuilder: (b) =>[
                      PopupMenuItem(
                          child: TextButton(
                            child: Text("Log Out", textAlign: TextAlign.center,),
                            onPressed: (){
                              Alerts.showLogOut(context, "Log Out", "Are you sure?");
                            },
                          )
                      ),
                    ]
                )
              ],
            ),
            drawer: DrawerAdmin(),
            body: _body(),
          )),
    );
  }

  Widget _body(){
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      physics: AlwaysScrollableScrollPhysics(),
      child: product(),
    );
  }

  Widget product(){
    return Form(
      autovalidateMode: _autovalidateMode,
      key: _formkey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: model,
                decoration: InputDecoration(
                  labelText: 'Model No.',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: sPrice,
                decoration: InputDecoration(
                  labelText: 'Salesman Price',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: cPrice,
                decoration: InputDecoration(
                  labelText: 'Customer Price',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: dPrice,
                decoration: InputDecoration(
                  labelText: 'Old Price',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: nPrice,
                decoration: InputDecoration(
                  labelText: 'New Price',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Center(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10),
                  child: DefaultButton(
                    text: "Edit Model",
                    press: (){
                      editModelPricing();
                    },
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  editModelPricing() async{
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: true,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();

      var response = await http.post(Uri.parse(Connection.editModel), body: {
        "secretkey":Connection.secretKey,
        "modelno":"${model.text}",
        "model_no_id":"${widget.model.modelNoId}",
        "user_id":"${widget.userId}",
      });

      var result = json.decode(response.body);

      print('results: $result');

      pr.hide();

      if(result['status'] == true){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => ModelListPage(userId: widget.userId,)), (route) => false);
        return true;
      } else {
        Alerts.showAlertAndBack(context, 'Error', 'Try again later');
        return false;
      }

    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }


}
