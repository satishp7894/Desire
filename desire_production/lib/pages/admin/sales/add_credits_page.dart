import 'dart:convert';
import 'package:desire_production/bloc/customer_bloc.dart';
import 'package:desire_production/components/custom_surfix_icon.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/sales_customer_list_model.dart';
import 'package:desire_production/pages/admin/sales/customer_credit_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class AddCreditsPage extends StatefulWidget {

  @override
  _AddCreditsPageState createState() => _AddCreditsPageState();
}

class _AddCreditsPageState extends State<AddCreditsPage> with Validator{

  TextEditingController creditAmount, creditDays;
  final customerBloc = CustomerListBloc();

  AutovalidateMode _autoValidateMode1 = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  String customer;
  String custId;
  List<String> custList = ['Please Select Customer'];
  List<CustomerModel> customerList = [];


  @override
  void initState() {
    super.initState();
    creditAmount = TextEditingController();
    creditDays = TextEditingController();

    customerBloc.fetchCustomerList();
  }

  @override
  void dispose() {
    super.dispose();
    creditDays.dispose();
    creditAmount.dispose();
    customerBloc.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text(
          "Add Credits",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _body(),
      //bottomNavigationBar: _checkoutCard(),
    );
  }


  Widget _body(){
    return StreamBuilder<SalesCustomerModel>(
      stream: customerBloc.newCustomerStream,
      builder: (context, s) {

        if (s.connectionState != ConnectionState.active) {
          print("all connection");
          return Container(height: 300,
              alignment: Alignment.center,
              child: Center(
                heightFactor: 50, child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),));
        }
        if (s.hasError) {
          print("as3 error");
          return Container(height: 300,
            alignment: Alignment.center,
            child: Text("Error Loading Data",),);
        }
        if (s.data
            .toString()
            .isEmpty) {
          print("as3 empty");
          return Container(height: 300,
            alignment: Alignment.center,
            child: Text("No Data Found",),);
        }

        for(int i=0; i< s.data.customer.length; i++){
          custList.add(s.data.customer[i].customerName);
        }
        customerList = s.data.customer;

        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20),
          child: Form(
            autovalidateMode: _autoValidateMode1,
            key: _formKey1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownSearch<String>(
                  validator: (v) => v == null ? "required field" : null,
                  mode: Mode.MENU,
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 30, right: 20, top: 5, bottom: 5),
                    alignLabelWithHint: true,
                    hintText: "Please Select Customer",
                    hintStyle: TextStyle(color: Colors.black45),
                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),
                  ),
                  showSelectedItem: true,
                  items: custList,
                  onChanged: (value){
                    setState(() {
                      customer = value;
                    });
                    print("customer selected: $customer");
                    for(int i =0; i<customerList.length; i++){
                      if(customerList[i].customerName == customer){
                        setState(() {
                          custId = customerList[i].customerId;
                        });
                      }
                    }
                    print("object customer id $custId");
                  },
                  //selectedItem: "Please Select your Area",
                ),
                SizedBox(height: 20,),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  validator: validateRequired,
                  controller: creditAmount,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(8),
                  ],
                  scrollPadding: EdgeInsets.zero,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: "Enter your Credit Amount",
                    hintStyle: TextStyle(color: Colors.black45),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Cash.svg"),
                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)), ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  validator: validateRequired,
                  controller: creditDays,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  scrollPadding: EdgeInsets.zero,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: "Enter your Credit Days",
                    hintStyle: TextStyle(color: Colors.black45),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/clock.svg"),
                    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: kSecondaryColor), borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: kPrimaryColor), borderRadius: BorderRadius.circular(10)),),
                ),
                SizedBox(height: 20,),
                DefaultButton(
                  text: "Add Credits",
                  press: () {
                    addCredits();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }


  addCredits() async{
    print("object values  ${creditDays.text} ${creditAmount.text} $custId");
    if (_formKey1.currentState.validate()){
      _formKey1.currentState.save();
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();
      var response = await http.post(Uri.parse(Connection.addCredits), body: {
        'user_id':"$custId",
        'credit_amount':"${creditAmount.text}",
        'credit_days':"${creditDays.text}",
        'secretkey':"${Connection.secretKey}"
      });

      print("object ${response.body}");
      var results = json.decode(response.body);

      pr.hide();
      if (results['status'] == true) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => AddCreditsPage()), (route) => false);
      } else {
        Alerts.showAlertAndBack(context, "Error", "Credit already added.");
      }
    } else {
      setState(() {
        _autoValidateMode1 = AutovalidateMode.always;
      });
    }
  }

}
