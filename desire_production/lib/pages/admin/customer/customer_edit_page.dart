import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/salesman_list_bloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/sales_customer_list_model.dart';
import 'package:desire_production/model/user_model.dart';
import 'package:desire_production/pages/admin/customer/customer_list_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'customer_address_view_page.dart';

class CustomerEditPage extends StatefulWidget {

 final CustomerModel customer;


  CustomerEditPage({@required this.customer});

  @override
  _CustomerEditPageState createState() => _CustomerEditPageState();
}

class _CustomerEditPageState extends State<CustomerEditPage> with Validator{

  final salesBloc = SalesmanListBloc();

  TextEditingController comapanyName;
  TextEditingController name;
  TextEditingController email;
  TextEditingController phone;
  TextEditingController uName;
  TextEditingController address;
  TextEditingController area;
  TextEditingController city;
  TextEditingController state;
  TextEditingController pincode;

  String id;
  final _focusNode = FocusNode();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  List<User> salesmanList = [];
  List<String> salesmanName = ["Select Sales Person"];
  String dropdownValue;
  String salesmanId;

  @override
  void initState() {
    checkConnectivity();
    salesBloc.fetchSalesmanList();
    comapanyName = TextEditingController(text: widget.customer.companyName);
    name = TextEditingController(text: widget.customer.customerName);
    email = TextEditingController(text: widget.customer.email);
    phone = TextEditingController(text: widget.customer.mobileNo);
    uName = TextEditingController(text: widget.customer.userName);
    address = TextEditingController(text: widget.customer.address);
    area = TextEditingController(text: widget.customer.area);
    city = TextEditingController(text: widget.customer.city);
    state = TextEditingController(text: widget.customer.state);
    pincode = TextEditingController(text: widget.customer.pincode);
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
    });
    super.initState();
  }

  checkConnectivity() async{
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }

  @override
  void dispose() {
    salesBloc.dispose();
    comapanyName.dispose();
    name.dispose();
    email.dispose();
    phone.dispose();
    uName.dispose();
    address.dispose();
    area.dispose();
    city.dispose();
    state.dispose();
    pincode.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
          appBar: AppBar(
            title: Text("Customer Details"),
            centerTitle: true,
            elevation: 0,
            backgroundColor:kSecondaryColor.withOpacity(0),
            titleTextStyle: headingStyle,
            textTheme: Theme.of(context).textTheme,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: (){
              Navigator.of(context).pop();
            },),
          ),
          body: _body(),
        )
    );
  }

  Widget _body(){

    return StreamBuilder<UserModel>(
      stream: salesBloc.salesmanStream,
      builder: (context, s) {

        if (s.connectionState != ConnectionState.active) {
          print("all connection");
          return Container(height: 300,
              alignment: Alignment.center,
              child: Center(
                heightFactor: 50, child: CircularProgressIndicator(),));
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

        print("sales man in customers ${widget.customer.salesmanID}");

        salesmanList = s.data.user;

        for (int i = 0; i < salesmanList.length; i++) {
          salesmanName.add(salesmanList[i].firstname);
          if (widget.customer.salesmanID == salesmanList[i].userId) {
            dropdownValue = salesmanList[i].firstname;
            salesmanId = salesmanList[i].userId;
          } else {
            dropdownValue = "Select Sales Person";
          }
          print("drop down value $dropdownValue $salesmanId");
        }

        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 25.0),
                child: Form(
                  autovalidateMode: _autovalidateMode,
                  key: _formkey,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Text(
                            'Personal Information',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Company Name (Only Admin)',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: TextFormField(
                                  readOnly: true,
                                  validator: validateName,
                                  controller: comapanyName,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Your Company Name",
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: TextFormField(
                                  validator: validateName,
                                  controller: name,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Your Name",
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'User Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: TextFormField(
                                  validator: validateRequired,
                                  controller: uName,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Your User Name",
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Email ID',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextFormField(
                                  validator: validateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: email,
                                  decoration: const InputDecoration(
                                      hintText: "Enter Email ID"),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Mobile',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: TextFormField(
                                  controller: phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  validator: validateMobile,
                                  keyboardType: TextInputType.phone,
                                  decoration: const InputDecoration(
                                      hintText: "Enter Mobile Number"),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Flat No/House No',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextFormField(
                                  readOnly: true,
                                  controller: address,
                                  validator: validateRequired,
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: const InputDecoration(
                                      hintText: "Enter Flat No/ House No."),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Area',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextFormField(
                                  //readOnly: true,
                                  controller: area,
                                  validator: validateRequired,
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: const InputDecoration(
                                      hintText: "Enter Area"),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'City',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextFormField(
                                  //readOnly: true,
                                  controller: city,
                                  validator: validateRequired,
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: const InputDecoration(
                                      hintText: "Enter City"),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Pincode',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: Focus(
                                  onFocusChange: (v){
                                    // getOtherAttributes(pincode.text);
                                    print("object focus changed rsponse $v");
                                    if(v == false){
                                      if (pincode.text.length == 6) {
                                        getOtherAttributes(pincode.text);
                                      } else {
                                        Alerts.showAlertAndBack(context, "Incorrect PinCode", "Enter a valid Pincode");
                                      }
                                    }
                                  },
                                  child: TextFormField(
                                    //readOnly: true,
                                    controller: pincode,
                                    focusNode: _focusNode,
                                    validator: validatePinCode,
                                    // onFieldSubmitted: (value){
                                    //   getOtherAttributes(value);
                                    // },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(6),
                                    ],
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        hintText: "Enter Pincode"),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'State',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextFormField(
                                  //readOnly: true,
                                  controller: state,
                                  validator: validateRequired,
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: const InputDecoration(
                                      hintText: "Enter State"),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Salesman Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                        child: DropdownSearch<String>(
                          validator: (v) => v == null ? "required field" : null,
                          mode: Mode.MENU,
                          selectedItem: dropdownValue,
                          dropdownSearchDecoration: InputDecoration(
                            //contentPadding: EdgeInsets.only(left: 30, right: 20, top: 5, bottom: 5),
                            alignLabelWithHint: true,
                            hintText: "Please Select Sales Person",
                            //hintStyle: TextStyle(color: Colors.black45),
                            // focusedErrorBorder: InputDecoration(borderSide: BorderSide(color: Colors.red),),
                            // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),),
                            // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), ),
                          ),
                          showSelectedItem: true,
                          items: salesmanName,
                          onChanged: (value){
                            setState(() {
                              dropdownValue = value;
                            });
                            print("customer selected: $value");
                            for(int i =0; i<salesmanList.length; i++){
                              if(salesmanList[i].firstname == dropdownValue){
                                setState(() {
                                  salesmanId = salesmanList[i].userId;
                                });
                              }
                            }
                            print("object customer id $salesmanId");
                          },
                          //selectedItem: "Please Select your Area",
                        ),
                      ),
                      _getActionButtons()
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                      height: 80,
                      alignment: Alignment.center,
                      color: Colors.white60,
                      child: DefaultButton1(
                        text: "Add Address",
                        press: (){
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerAddressViewPage(customerId: '', customerName: '', page: "edit", customer: widget.customer, )));
                        },
                      )
                  )
              ),
              SizedBox(height: 20,)
            ],
          ),
        );
      }
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: DefaultButton(
                    text: "Save",
                    press: (){
                      getUpdated();
                    },
                  )
              ),),),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                child: DefaultButton1(
                  text: "Cancel",
                  press: (){
                    setState(() {
                      name.text = widget.customer.customerName;
                      email.text = widget.customer.email;
                      phone.text = widget.customer.mobileNo;
                      uName.text = widget.customer.userName;
                      address.text = widget.customer.address;
                      area.text = widget.customer.area;
                      city.text = widget.customer.city;
                      state.text = widget.customer.state;
                      pincode.text = widget.customer.pincode;
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getUpdated() async{

    print('salesmanID_assign: $salesmanId, customer_id ${widget.customer.customerId}, name: ${name
        .text}, usernam : ${uName.text}, email: ${email.text}, mobile:${ phone.text}, address : ${address.text},area: ${area.text},City: ${city.text},State: ${state.text},Pincode: ${pincode.text},');
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();
      var response = await http.post(Uri.parse(Connection.updateProfile), body: {

        'secretkey': Connection.secretKey,
        'salesmanID_assign':salesmanId,
        'customer_id':widget.customer.customerId,
        'name': name.text,
        'username' : uName.text,
        'email': email.text,
        'mobile': phone.text,
        'address' : address.text,
        'area' : area.text,
        'City' : city.text,
        'State' : state.text,
        'Pincode' : pincode.text,
      });
      var results = json.decode(response.body);
      print('response == $results  ${response.body}');
      pr.hide();
      if (results['status'] == true) {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString("Customer_name","${name.text}");
        // prefs.setString("Email",email.text);
        // prefs.setString("Mobile_no", phone.text);
        // prefs.setString("User_name", uname.text);
        final snackBar = SnackBar(content: Text('Customer Profile Updated Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CustomerListPage()), (Route<dynamic> route) => false);
      } else {
        print('error in updating profile');
        Alerts.showAlertAndBack(context, 'Error', 'Customer Profile not Updated. Please try again later');
      }
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }

  }

  getOtherAttributes(String pin) async{
    print("object pin $pin");
    if(pin.isEmpty || pin.length > 6){
      Alerts.showAlertAndBack(context, "Invalid Value", "Please Enter 6 digit Pincode");
    } else {
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();
      var response = await http.get(Uri.parse(Connection.getAttributes+"$pin"));
      var result = json.decode(response.body);


      if(result[0]["Message"] == "No records found"){
        pr.hide();
        Alerts.showAlertAndBack(context, "Incorrect PinCode", "Enter a valid Pincode");
      } else {
        //String cityN = result[0]["PostOffice"][0]["Division"];
        String stateN = result[0]["PostOffice"][0]["State"];
        //String districtN = result[0]["PostOffice"][0]["District"];

        setState(() {
          //city = TextEditingController(text: cityN);
          state = TextEditingController(text: stateN);
          //district = TextEditingController(text: districtN);
          // for(int i=0; i<result[0]["PostOffice"].length; i++){
          //   print("value for areas ${result[0]["PostOffice"][i]["Name"]}");
          //   areaWise.add("${result[0]["PostOffice"][i]["Name"]}");
          // }
        });

        print(
            "object value for the region ${result[0]["Message"]} ${result[0]["PostOffice"][0]["Region"]}");
        pr.hide();
      }
    }
  }


}
