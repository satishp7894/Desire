import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/models/sales_customer_list_model.dart';
import 'package:desire_users/sales/pages/customer/customer_otp_page.dart';
import 'package:desire_users/sales/pages/sales_home_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/custom_surfix_icon.dart';
import 'package:desire_users/sales/utils_sales/default_button.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/sales/utils_sales/validator.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/services/connection_sales.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AddCustomerPage extends StatefulWidget {

  final String salesId;
  final String name;
  final String email;
  const AddCustomerPage({@required this.salesId, @required this.email, @required this.name});



  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> with Validator{


  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  
  TextEditingController cityText;
  TextEditingController stateText;
  TextEditingController pin;


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
    _focusNode.dispose();
    pin.dispose();
    cityText.dispose();
    stateText.dispose();
  }


  checkConnectivity() async{
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.indigo.shade100,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text("Add New Customer", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
            centerTitle: true,
          ),
          body: _body(),
        ));
  }

  Widget _body(){
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: signUpForm()
      ),
    );
  }

  Widget signUpForm(){
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
              floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.apartment,color: kPrimaryColor,),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kPrimaryColor
                )
              ),border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: kSecondaryColor
                )
              ),
              labelStyle: TextStyle(color: kPrimaryColor,fontSize: 14),
              hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12)
            ),cursorColor: kBlackColor,
          ),
          SizedBox(height: 10,),
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
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
                prefixIcon: Icon(Icons.person,color: kPrimaryColor,),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor
                    )
                ),border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kSecondaryColor
                )
            ),
                labelStyle: TextStyle(color: kPrimaryColor,fontSize: 14),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12)
            ),cursorColor: kBlackColor,
          ),
          SizedBox(height: 10,),
          /*TextFormField(
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
                prefixIcon: Icon(Icons.person,color: kPrimaryColor,),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor
                    )
                ),border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kSecondaryColor
                )
            ),
                labelStyle: TextStyle(color: kPrimaryColor,fontSize: 14),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12)
            ),cursorColor: kBlackColor,
          ),
          SizedBox(height: 10,),*/
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
                prefixIcon: Icon(Icons.email,color: kPrimaryColor,),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor
                    )
                ),border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kSecondaryColor
                )
            ),
                labelStyle: TextStyle(color: kPrimaryColor,fontSize: 14),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12)
            ),cursorColor: kBlackColor,
          ),
          SizedBox(height: 10),
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
                prefixIcon: Icon(Icons.password,color: kPrimaryColor,),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor
                    )
                ),border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kSecondaryColor
                )
            ),
                labelStyle: TextStyle(color: kPrimaryColor,fontSize: 14),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12)
            ),cursorColor: kBlackColor,
          ),
          SizedBox(height: 10),
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
                prefixIcon: Icon(Icons.password,color: kPrimaryColor,),focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kPrimaryColor
                )
            ),border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kSecondaryColor
                )
            ),
                labelStyle: TextStyle(color: kPrimaryColor,fontSize: 14),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12)
            ),cursorColor: kBlackColor,
          ),
          SizedBox(height: 10,),
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
                prefixIcon: Icon(Icons.phone_android,color: kPrimaryColor,),focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kPrimaryColor
                )
            ),border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kSecondaryColor
                )
            ),
                labelStyle: TextStyle(color: kPrimaryColor,fontSize: 14),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12)
            ),cursorColor: kBlackColor,
          ),
          SizedBox(height: 10,),
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
                prefixIcon: Icon(Icons.location_on,color: kPrimaryColor,),focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kPrimaryColor
                )
            ),border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kSecondaryColor
                )
            ),
                labelStyle: TextStyle(color: kPrimaryColor,fontSize: 14),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12)
            ),cursorColor: kBlackColor,
          ),
          SizedBox(height: 10,),
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
                prefixIcon: Icon(Icons.location_on,color: kPrimaryColor,),focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kPrimaryColor
                )
            ),border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kSecondaryColor
                )
            ),
                labelStyle: TextStyle(color: kPrimaryColor,fontSize: 14),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12)
            ),cursorColor: kBlackColor,
          ),
          SizedBox(height: 10,),
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
                prefixIcon: Icon(Icons.location_on,color: kPrimaryColor,),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor
                    )
                ),border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kSecondaryColor
                )
            ),
                labelStyle: TextStyle(color: kPrimaryColor,fontSize: 14),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12)
            ),cursorColor: kBlackColor,
          ),
          SizedBox(height: 10,),
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
                labelText: "Pin-code",
                hintText: "Enter Customer Pin-code",
                // If  you are using latest version of flutter then lable text and hint text shown like this
                // if you r using flutter less then 1.20.* then maybe this is not working properly
                floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Icon(Icons.location_on,color: kPrimaryColor,),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColor
                      )
                  ),border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: kSecondaryColor
                  )
              ),
                  labelStyle: TextStyle(color: kPrimaryColor,fontSize: 14),
                  hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12)
              ),cursorColor: kBlackColor,
            ),
          ),
          SizedBox(height: 10,),
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
              prefixIcon: Icon(Icons.location_on,color: kPrimaryColor,),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kPrimaryColor
                    )
                ),border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: kSecondaryColor
                )
            ),
                labelStyle: TextStyle(color: kPrimaryColor,fontSize: 14),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12)
            ),cursorColor: kBlackColor,
          ),
          SizedBox(height: 10),
          DefaultButton(
            text: "Continue",
            press: () {
              registerNow();
            },
          ),
          SizedBox(height: 30,)
        ],
      ),
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
      print("values from form ${widget.salesId} $name \n $uName \n $password \n $email \n $conformPassword \n $phone \n $address \n $pincode \n $area"
          "\n $city \n $state");
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: true,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();

      var response = await http.post(Uri.parse(ConnectionSales.addCustomer), body: {
        "salesmanID":"${widget.salesId}",
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
        "secretkey":"12!@34#\$5%"
      });

      var result = json.decode(response.body);

      print('results: $result');

      pr.hide();

      if(result['status'] == true){
        UserModel userModel = UserModel.fromJson(result['data'][0]);
        print("model value ${userModel.customerId}");
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerOtpPage(customerId: userModel.customerId, salesId: widget.salesId, name: widget.name, email: widget.email, mob: userModel.mobileNo,)), (route) => false);
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
