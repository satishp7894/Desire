import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/services/check_block.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/progress_dialog.dart';
import 'package:desire_users/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'address_view_page.dart';

class UserDetailPage extends StatefulWidget {
  final bool status;

  final int orderCount;

  const UserDetailPage({@required this.status, @required this.orderCount});

  @override
  _UserDetailPageState createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> with Validator {
  TextEditingController companyName;
  TextEditingController name;
  TextEditingController email;
  TextEditingController phone;
  TextEditingController uName;
  TextEditingController address;
  TextEditingController area;
  TextEditingController city;
  TextEditingController state;
  TextEditingController pinCode;

  String id;
  SharedPreferences prefs;

  final _focusNode = FocusNode();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    checkConnectivity();
    if (widget.status) {
      getDetailsB();
    }
    companyName = TextEditingController();
    name = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    uName = TextEditingController();
    address = TextEditingController();
    area = TextEditingController();
    city = TextEditingController();
    state = TextEditingController();
    pinCode = TextEditingController();
    getDetails();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
    });
    super.initState();
  }

  checkConnectivity() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(
          context, "No Internet Connection", "Please check your internet");
    }
  }

  @override
  void dispose() {
    companyName.dispose();
    name.dispose();
    email.dispose();
    phone.dispose();
    uName.dispose();
    address.dispose();
    area.dispose();
    city.dispose();
    state.dispose();
    pinCode.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  getDetailsB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mob = prefs.getString("Mobile_no");
    print("object $mob");
    final checkBloc = CheckBlocked(mob);
    checkBloc.getDetailsUserD(context);
  }

  getDetails() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString("customer_id");
    companyName.text = prefs.getString("company_name");
    name.text = prefs.getString("Customer_name");
    email.text = prefs.getString("Email");
    phone.text = prefs.getString("Mobile_no");
    uName.text = prefs.getString("User_name");
    address.text = prefs.getString("address");
    area.text = prefs.getString("area");
    city.text = prefs.getString("City");
    state.text = prefs.getString("State");
    pinCode.text = prefs.getString("Pincode");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("User Details"),
        centerTitle: false,
        elevation: 0,
        backgroundColor: kSecondaryColor.withOpacity(0),
        titleTextStyle: headingStyle,
        textTheme: Theme.of(context).textTheme,
        actions: [
          _status ? _getEditIcon() : _getSaveCancel(),
          SizedBox(
            width: 10,
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _body(),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          color: kSecondaryColor,
          child: GestureDetector(
            child: Center(
              child: Text(
                "Add Address",
                style: TextStyle(color: kWhiteColor, fontSize: 20),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => AddressViewPage(
                          userId: id,
                          page: "detail",
                          status: true,
                          orderCount: widget.orderCount)));
            },
          ),
        ),
      ),
    ));
  }

  bool _status = true;

  Widget _body() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: Form(
              autovalidateMode: _autoValidateMode,
              key: _formKey,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Text(
                            'Personal Information',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              new Text(
                                'Company Name',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: Row(
                        children: [
                          new Flexible(
                            child: TextFormField(
                              validator: validateName,
                              onTap: () {
                                final snackBar = SnackBar(
                                    content: Text(
                                        "Contact Admin to change your company name"));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              controller: companyName,
                              decoration: const InputDecoration(
                                  hintText: "Enter Your Company Name",
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: kPrimaryColor))),
                              readOnly: true,
                              // enabled: !_status,
                              // autofocus: !_status,
                              // showCursor: !_status,
                            ),
                          )
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
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
                              enabled: !_status,
                              autofocus: !_status,
                              showCursor: !_status,
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
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
                              enabled: !_status,
                              //autofocus: !_status,
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
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
                              enabled: !_status,
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              controller: phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validator: validateMobile,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  hintText: "Enter Mobile Number"),
                              enabled: !_status,
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
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
                              enabled: !_status,
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              //readOnly: true,
                              controller: area,
                              validator: validateRequired,
                              keyboardType: TextInputType.streetAddress,
                              decoration:
                                  const InputDecoration(hintText: "Enter Area"),
                              enabled: !_status,
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              //readOnly: true,
                              controller: city,
                              validator: validateRequired,
                              keyboardType: TextInputType.streetAddress,
                              decoration:
                                  const InputDecoration(hintText: "Enter City"),
                              enabled: !_status,
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: Focus(
                              onFocusChange: (v) {
                                // getOtherAttributes(pincode.text);
                                print("object focus changed rsponse $v");
                                if (v == false) {
                                  if (pinCode.text.length == 6) {
                                    getOtherAttributes(pinCode.text);
                                  } else {
                                    Alerts.showAlertAndBack(
                                        context,
                                        "Incorrect PinCode",
                                        "Enter a valid Pincode");
                                  }
                                }
                              },
                              child: TextFormField(
                                //readOnly: true,
                                controller: pinCode,
                                focusNode: _focusNode,
                                validator: validatePinCode,
                                onFieldSubmitted: (value) {
                                  getOtherAttributes(value);
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: "Enter Pincode"),
                                enabled: !_status,
                              ),
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
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
                              enabled: !_status,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: kPrimaryColor,
        onPressed: () {
          setState(() {
            _status = false;
          });
        },
        child: Text("Edit"),
      ),
    );
  }

  Widget _getSaveCancel() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          new FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: kSecondaryColor,
            onPressed: () {
              setState(() {
                _status = true;
                name.text = prefs.getString("Customer_name");
                email.text = prefs.getString("Email");
                phone.text = prefs.getString("Mobile_no");
                uName.text = prefs.getString("User_name");
                address.text = prefs.getString("address");
                area.text = prefs.getString("area");
                city.text = prefs.getString("City");
                state.text = prefs.getString("State");
                pinCode.text = prefs.getString("Pincode");
                FocusScope.of(context).requestFocus(new FocusNode());
              });
            },
            child: Text(
              "Cancel",
              style: TextStyle(fontSize: 12),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          new FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: kPrimaryColor,
            onPressed: () {
              getUpdated();
            },
            child: Text(
              "Save",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
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
                press: () {
                  getUpdated();
                },
              )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                child: DefaultButton1(
                  text: "Cancel",
                  press: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getUpdated() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: false,
      );
      pr.style(
        message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),
      );
      pr.show();
      var response =
          await http.post(Uri.parse(Connection.updateProfile), body: {
        'secretkey': Connection.secretKey,
        'customer_id': id,
        'name': name.text,
        'username': uName.text,
        'email': email.text,
        'mobile': phone.text,
        'address': address.text,
        'area': area.text,
        'City': city.text,
        'State': state.text,
        'Pincode': pinCode.text,
      });
      var results = json.decode(response.body);
      print('response == $results  ${response.body}');
      pr.hide();
      if (results['status'] == true) {
        _status = true;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("Customer_name", "${name.text}");
        prefs.setString("Email", email.text);
        prefs.setString("Mobile_no", phone.text);
        prefs.setString("User_name", uName.text);
        prefs.setString('address', address.text);
        prefs.setString('area', area.text);
        prefs.setString('City', city.text);
        prefs.setString('State', state.text);
        prefs.setString('Pincode', pinCode.text);
        final snackBar =
            SnackBar(content: Text('Profile Updated Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => UserDetailPage(
                      status: true,
                      orderCount: widget.orderCount,
                    )),
            (Route<dynamic> route) => false);
      } else {
        print('error in updating profile');
        Alerts.showAlertAndBack(
            context, 'Error', 'Profile not Updated. Please try again later');
      }
    } else {
      setState(() {
        _autoValidateMode = AutovalidateMode.always;
      });
    }
  }

  getOtherAttributes(String pin) async {
    print("object pin $pin");
    if (pin.isEmpty || pin.length > 6) {
      Alerts.showAlertAndBack(
          context, "Invalid Value", "Please Enter 6 digit Pincode");
    } else {
      ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: false,
      );
      pr.style(
        message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),
      );
      pr.show();
      var response =
          await http.get(Uri.parse(Connection.getAttributes + "$pin"));
      var result = json.decode(response.body);

      if (result[0]["Message"] == "No records found") {
        pr.hide();
        Alerts.showAlertAndBack(
            context, "Incorrect PinCode", "Enter a valid Pincode");
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
