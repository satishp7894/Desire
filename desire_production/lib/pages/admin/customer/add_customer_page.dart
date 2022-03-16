import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/salesman_list_bloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/sales_customer_list_model.dart';
import 'package:desire_production/model/user_model.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/custom_surfix_icon.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'customer_otp_page.dart';

class AddCustomerPage extends StatefulWidget {


  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> with Validator{


  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  
  TextEditingController cityText;
  TextEditingController stateText;
  TextEditingController pin;

  final salesBloc = SalesmanListBloc();

  List<User> salesmanList = [];
  List<String> salesmanName = ["Select Sales Person"];
  String dropdownValue = "Select Sales Person";
  String salesmanId;


  final _focusNode = FocusNode();

  String companyName;
  String name;
  String uName;
  String email;
  String password;
  String conformPassword;
  String phone;
  String address;
  String pincode;
  String area;
  String city;
  String state;

  @override
  void initState() {
    super.initState();
    salesBloc.fetchSalesmanList();
    checkConnectivity();
    pin = TextEditingController();
    cityText = TextEditingController();
    stateText = TextEditingController();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    salesBloc.dispose();
    _focusNode.dispose();
    pin.dispose();
    cityText.dispose();
    stateText.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: Text("Add New Customer", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
        centerTitle: true,
      ),
      body: _body(),
      bottomNavigationBar: SafeArea(
        child:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: DefaultButton(
            text: "Add Customer",
            press: () {
              registerNow();
            },
          ),
        ),
      ),
    );
  }

  Widget _body(){
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: signUpForm()
      ),
    );
  }

  Widget signUpForm(){
    return StreamBuilder<UserModel>(
        stream: salesBloc.salesmanStream,
        builder: (context, s) {

          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50, child: CircularProgressIndicator(color: kPrimaryColor,),));
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
          salesmanList = s.data.user;

          for (int i = 0; i < salesmanList.length; i++) {
            salesmanName.add(salesmanList[i].firstname);
            print("drop down value $dropdownValue $salesmanId");
          }


          return Form(
          autovalidateMode: _autovalidateMode,
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20,),
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onSaved: (newValue) => companyName = newValue,
                onChanged: (value) {
                  companyName = value;
                },
                validator: validateName,
                decoration: InputDecoration(
                  labelText: "Company Name",
                  hintText: "Enter Company Name",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon:Icon(Icons.apartment,color: kPrimaryColor,),
                  hintStyle: TextStyle(color: Color(0xff979797),fontSize: 12),
                  labelStyle: TextStyle(color: kPrimaryColor,fontSize: 16),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xff979797)
                    )
                  ),focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kPrimaryColor,
                      width: 2
                    )
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onSaved: (newValue) => name = newValue,
                onChanged: (value) {
                  name = value;
                },
                validator: validateName,
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "Enter Customer Name",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon:Icon(Icons.person,color: kPrimaryColor,),
                  hintStyle: TextStyle(color: Color(0xff979797),fontSize: 12),
                  labelStyle: TextStyle(color: kPrimaryColor,fontSize: 16),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff979797)
                      )
                  ),focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2
                    )
                ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                onSaved: (newValue) => uName = newValue,
                onChanged: (value) {
                  uName = value;
                },
                validator: validateName,
                decoration: InputDecoration(
                  labelText: "User Name",
                  hintText: "Enter Customer User Name",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon:Icon(Icons.person,color: kPrimaryColor,),
                  hintStyle: TextStyle(color: Color(0xff979797),fontSize: 12),
                  labelStyle: TextStyle(color: kPrimaryColor,fontSize: 16),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff979797)
                      )
                  ),focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2
                    )
                ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) => email = newValue,
                onChanged: (value) {
                  email = value;
                },
                validator: validateEmail,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter Customer email",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon:Icon(Icons.email,color: kPrimaryColor,),
                  hintStyle: TextStyle(color: Color(0xff979797),fontSize: 12),
                  labelStyle: TextStyle(color: kPrimaryColor,fontSize: 16),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff979797)
                      )
                  ),focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2
                    )
                ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                textInputAction: TextInputAction.next,
                obscureText: true,
                onSaved: (newValue) => password = newValue,
                onChanged: (value) {
                  password = value;
                },
                validator: validateRequired,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter password",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon:Icon(Icons.password,color: kPrimaryColor,),
                  hintStyle: TextStyle(color: Color(0xff979797),fontSize: 12),
                  labelStyle: TextStyle(color: kPrimaryColor,fontSize: 16),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff979797)
                      )
                  ),focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2
                    )
                ),
                ),
              ),
              SizedBox(height: 30),
              TextFormField(
                textInputAction: TextInputAction.next,
                obscureText: true,
                onSaved: (newValue) => conformPassword = newValue,
                onChanged: (value) {
                  conformPassword = value;
                },
                validator: validateRequired,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  hintText: "Re-enter password",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon:Icon(Icons.password,color: kPrimaryColor,),
                  hintStyle: TextStyle(color: Color(0xff979797),fontSize: 12),
                  labelStyle: TextStyle(color: kPrimaryColor,fontSize: 16),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff979797)
                      )
                  ),focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2
                    )
                ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                //maxLength: 10,
                onSaved: (newValue) => phone = newValue,
                onChanged: (value) {
                  phone = value;
                },inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
                validator: validateMobile,
                decoration: InputDecoration(
                  labelText: "Mobile",
                  hintText: "Enter Customer Mobile Number",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon:Icon(Icons.phone_android,color: kPrimaryColor,),
                  hintStyle: TextStyle(color: Color(0xff979797),fontSize: 12),
                  labelStyle: TextStyle(color: kPrimaryColor,fontSize: 16),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff979797)
                      )
                  ),focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2
                    )
                ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.streetAddress,
                onSaved: (newValue) => address = newValue,
                onChanged: (value) {
                  address = value;
                },
                validator: validateRequired,
                decoration: InputDecoration(
                  labelText: "Address",
                  hintText: "Enter Customer Address",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon:Icon(Icons.location_on,color: kPrimaryColor,),
                  hintStyle: TextStyle(color: Color(0xff979797),fontSize: 12),
                  labelStyle: TextStyle(color: kPrimaryColor,fontSize: 16),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff979797)
                      )
                  ),focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2
                    )
                ),
                ),
              ),
              SizedBox(height: 20,),
              // DropdownSearch<String>(
              //   validator: (v) => v == null ? "required field" : null,
              //   mode: Mode.MENU,
              //   dropdownSearchDecoration: InputDecoration(
              //     //contentPadding: EdgeInsets.only(left: 30, right: 20, top: 5, bottom: 5),
              //     alignLabelWithHint: true,
              //     hintText: "Please Select your Area",
              //     labelText: "Area",
              //     floatingLabelBehavior: FloatingLabelBehavior.always,
              //     suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Location point.svg"),
              //     // focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(30)),
              //     // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(30)),
              //     // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(30)),
              //   ),
              //   showSelectedItem: true,
              //   items: areaWise,
              //   onChanged: (value){
              //     setState(() {
              //       area = value;
              //     });
              //     print("area selected: $area");
              //   },
              //   //selectedItem: "Please Select your Area",
              // ),
              TextFormField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                onSaved: (newValue) => area = newValue,
                onChanged: (value) {
                  area = value;
                },
                validator: validateRequired,
                decoration: InputDecoration(
                  labelText: "Area",
                  hintText: "Enter Customer Area",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon:Icon(Icons.location_on,color: kPrimaryColor,),
                  hintStyle: TextStyle(color: Color(0xff979797),fontSize: 12),
                  labelStyle: TextStyle(color: kPrimaryColor,fontSize: 16),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff979797)
                      )
                  ),focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2
                    )
                ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: cityText,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                onSaved: (newValue) => city = newValue,
                //readOnly: true,
                validator: validateName,
                decoration: InputDecoration(
                  labelText: "City",
                  hintText: "Enter Customer City",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon:Icon(Icons.location_on,color: kPrimaryColor,),
                  hintStyle: TextStyle(color: Color(0xff979797),fontSize: 12),
                  labelStyle: TextStyle(color: kPrimaryColor,fontSize: 16),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff979797)
                      )
                  ),focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2
                    )
                ),
                ),
              ),
              SizedBox(height: 20,),
              Focus(
                onFocusChange: (v){
                  print("object focus changed rsponse $v");
                  if(v == false){
                    if (pin.text.length == 6) {
                      getOtherAttributes(pin.text);
                    } else {
                      Alerts.showAlertAndBack(context, "Incorrect PinCode", "Enter a valid Pincode");
                    }
                  }
                },
                child: TextFormField(
                  controller: pin,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  //maxLength: 6,
                  onSaved: (newValue) => pincode = newValue,
                  // onChanged: (value) {
                  //   pincode = value;
                  // },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  //
                  validator: validatePinCode,
                  decoration: InputDecoration(
                    labelText: "Pincode",
                    hintText: "Enter Customer Pincode",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon:Icon(Icons.location_on,color: kPrimaryColor,),
                    hintStyle: TextStyle(color: Color(0xff979797),fontSize: 12),
                    labelStyle: TextStyle(color: kPrimaryColor,fontSize: 16),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color(0xff979797)
                        )
                    ),focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColor,
                          width: 2
                      )
                  ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: stateText,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
                onSaved: (newValue) => state = newValue,
                //readOnly: true,
                validator: validateRequired,
                decoration: InputDecoration(
                  labelText: "State",
                  hintText: "Enter Customer State",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon:Icon(Icons.location_on,color: kPrimaryColor,),
                  hintStyle: TextStyle(color: Color(0xff979797),fontSize: 12),
                  labelStyle: TextStyle(color: kPrimaryColor,fontSize: 16),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xff979797)
                      )
                  ),focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor,
                        width: 2
                    )
                ),
                ),
              ),
              SizedBox(height: 10),
              DropdownSearch<String>(
                validator: (v) => v == null ? "required field" : null,
                mode: Mode.MENU,
                //selectedItem: dropdownValue,
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
            ],
          ),
        );
      }
    );
  }

  List<String> areaWise = ['Please Select your Area'];

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
      print("object ${response.body == null}");
      var result = json.decode(response.body);
      print("object $result");

      if(result[0]["Message"] == "No records found"){
        pr.hide();
        Alerts.showAlertAndBack(context, "Incorrect PinCode", "Enter a valid Pincode");
      } else{
        pr.hide();
        //String cityN = result[0]["PostOffice"][0]["Division"];
        String stateN = result[0]["PostOffice"][0]["State"];

        setState(() {
          //cityText = TextEditingController(text: cityN);
          stateText = TextEditingController(text: stateN);

          for(int i=0; i<result[0]["PostOffice"].length; i++){
            print("value for areas ${result[0]["PostOffice"][i]["Name"]}");
            areaWise.add("${result[0]["PostOffice"][i]["Name"]}");
          }
        });

      }
      print("object value for the region ${result[0]["Message"]} ${result[0]["PostOffice"][0]["Region"]}");
      //pr.hide();
    }
  }

  registerNow() async{
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print("values from form $name \n $uName \n $password \n $email \n $conformPassword \n $phone \n $address \n $pincode \n $area"
          "\n $city \n $state");
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: true,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();

      var response = await http.post(Uri.parse(Connection.addCustomer), body: {
        "salesmanID":"$salesmanId",
        "companyname":"$companyName",
        "customername":"$name",
        "email":"$email",
        "mobile":"$phone",
        "username":"$uName",
        "password":"$password",
        "address":"$address",
        "pincode":"$pincode",
        "state":"$state",
        "city":"$city",
        "area":"$area",
        "is_active":"1",
        "secretkey":Connection.secretKey
      });

      var result = json.decode(response.body);

      print('results: $result');

      pr.hide();

      if(result['status'] == true){
        CustomerModel userModel = CustomerModel.fromJson(result['data'][0]);
        print("model value ${userModel.customerId}");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerOtpPage(customerId: userModel.customerId, mob: userModel.mobileNo,)), (route) => false);
        return true;
      }
      if(result['message'] == "Email,Mobile and Username allready exists"){
        Alerts.showAlertAndBack(context, 'Error SignUP', 'UserName Email or Mobile already exist.');
      }
      else {
        Alerts.showAlertAndBack(context, 'Error SignUP', 'Try again later');
        return false;
      }

    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }

}
