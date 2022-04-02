import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/role_list_bloc.dart';
import 'package:desire_production/bloc/select_state_bloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/role_list_model.dart';
import 'package:desire_production/model/state_model.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../../model/city_model.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> with Validator {
  final _formKey = GlobalKey<FormState>();
  final _formKeyRegion = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  var txt = TextEditingController();

  var cityController = TextEditingController();
  TextEditingController cityText;
  TextEditingController stateText;
  TextEditingController pin;

  final roleBloc = RoleListBloc();
  final stateBloc = SelectStateBloc();

  List<RoleList> roleList = [];
  List<StateData> stateList = [];
  List<StateData> selectedStateList = [];
  List<CityData> selectedCityList = [];
  List<String> salesmanName = ["Select Role"];
  String dropdownValue = "Select Role";
  String roleId;

  final _focusNode = FocusNode();

  String firstname;
  String lastname;
  String uName;
  String email;
  String password;
  String phone;
  String address;
  String pincode;
  String city;
  String state;

  String regionState;
  String regionCity;
  bool anotherViewVisible = false;
  List<CityData> cityList = [];

  int userId = 0;

  @override
  void initState() {
    super.initState();
    checkConnectivity();

    stateBloc.fetchState();
    roleBloc.fetchRoleList();
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
    roleBloc.dispose();
    stateBloc.dispose();
    _focusNode.dispose();
    pin.dispose();
    cityText.dispose();
    stateText.dispose();
  }

  checkConnectivity() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(
          context, "No Internet Connection", "Please check your internet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          (anotherViewVisible && dropdownValue == "Sales")
              ? "Select Region"
              : "Add New User",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: (anotherViewVisible && dropdownValue == "Sales")
          ? _anotherBody()
          : _body(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DefaultButton(
            text: (anotherViewVisible && dropdownValue == "Sales")
                ? "Add Region"
                : "Add User",
            press: () {
              if (anotherViewVisible && dropdownValue == "Sales") {
                viewAssignArea();
              } else {
                registerNow();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(child: signUpForm()),
    );
  }

  Widget _anotherBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(child: citySelectForm()),
    );
  }

  Widget citySelectForm() {
    return StreamBuilder<StateModel>(
        stream: stateBloc.stateStream,
        builder: (context, s) {
          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(
                height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50,
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ));
          }
          if (s.hasError) {
            print("as3 error");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "Error Loading Data",
              ),
            );
          }
          if (s.data.stateData.isEmpty) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          }
          stateList = s.data.stateData;

          return Form(
            key: _formKeyRegion,
            autovalidateMode: _autovalidateMode,
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onSaved: (newValue) => regionState = newValue,
                    onChanged: (value) {
                      regionState = value;
                    },
                    validator: validateRegion,
                    controller: txt,
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Select State"),
                              content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    setupStateDialog(),
                                    Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                                primary: kPrimaryColor,
                                                backgroundColor: kPrimaryColor),
                                            onPressed: () {
                                              var selectedState = stateList
                                                  .where((x) => x.isCheck)
                                                  .map((e) => e.stateName)
                                                  .toList()
                                                  .join(",");
                                              var listsId = stateList
                                                  .where((x) => x.isCheck)
                                                  .map((e) => e.stateId)
                                                  .toList();
                                              // var json = jsonEncode(lists, toEncodable: (e) => e.toString());
                                              // print(lists);
                                              selectedStateList = stateList
                                                  .where((x) => x.isCheck)
                                                  .toList();
                                              txt.text = selectedState;
                                              Navigator.pop(context);

                                              stateWiseCity(listsId);
                                            },
                                            child: Text(
                                              "Submit",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )))
                                  ]),
                            );
                          });
                    },
                    decoration: InputDecoration(
                      labelText: "State",
                      hintText: "Select State",
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(
                        Icons.pin_drop,
                        color: kPrimaryColor,
                      ),
                      hintStyle:
                          TextStyle(color: Color(0xff979797), fontSize: 12),
                      labelStyle: TextStyle(color: kPrimaryColor, fontSize: 16),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff979797))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 2)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: cityController,
                    keyboardType: TextInputType.text,
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: Text("Select City"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    setupCityDialog(cityList),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            primary: kPrimaryColor,
                                            backgroundColor: kPrimaryColor),
                                        onPressed: () {
                                          var lists = cityList
                                              .where((x) => x.isCheck)
                                              .map((e) => e.cityName)
                                              .toList()
                                              .join(",");
                                          // var json = jsonEncode(lists, toEncodable: (e) => e.toString());
                                          // print(lists);
                                          selectedCityList = cityList
                                              .where((x) => x.isCheck)
                                              .toList();
                                          cityController.text = lists;
                                          Navigator.pop(context);
                                          // txt.text = lists;
                                        },
                                        child: Text(
                                          "Submit",
                                          style: TextStyle(color: Colors.white),
                                        ))
                                  ],
                                ));
                          });
                    },
                    validator: validateRegion,
                    onSaved: (newValue) => regionCity = newValue,
                    onChanged: (value) {
                      regionCity = value;
                    },
                    decoration: InputDecoration(
                      labelText: "City",
                      hintText: "Select City",
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(
                        Icons.pin_drop,
                        color: kPrimaryColor,
                      ),
                      hintStyle:
                          TextStyle(color: Color(0xff979797), fontSize: 12),
                      labelStyle: TextStyle(color: kPrimaryColor, fontSize: 16),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff979797))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 2)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget setupStateDialog() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: Column(
        children: [
          Container(
            height: 300,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: stateList.length,
                itemBuilder: (BuildContext context, int index) {
                  return StatefulBuilder(builder: (context, setState) {
                    return CheckboxListTile(
                      title: Text(stateList[index].stateName),
                      value: stateList[index].isCheck,
                      onChanged: (val) {
                        setState(() {
                          stateList[index].isCheck = val;
                        });
                      },
                    );
                  });
                }),
          )
        ],
      ),
    );
  }

  Widget setupCityDialog(List<CityData> cityList) {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: cityList.length,
          itemBuilder: (BuildContext context, int index) {
            return StatefulBuilder(builder: (context, setState) {
              return CheckboxListTile(
                title: Text(cityList[index].cityName),
                value: cityList[index].isCheck,
                onChanged: (val) {
                  setState(() {
                    cityList[index].isCheck = val;
                  });
                },
              );
            });
          }),
    );
  }

  Widget signUpForm() {
    return StreamBuilder<RoleListModel>(
        stream: roleBloc.roleStream,
        builder: (context, s) {
          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(
                height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50,
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ));
          }
          if (s.hasError) {
            print("as3 error");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "Error Loading Data",
              ),
            );
          }
          if (s.data.toString().isEmpty) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          }
          roleList = s.data.roleList;

          for (int i = 0; i < roleList.length; i++) {
            salesmanName.add(roleList[i].roleName);
            print("drop down value $dropdownValue $roleId");
          }

          return Form(
            autovalidateMode: _autovalidateMode,
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onSaved: (newValue) => firstname = newValue,
                  onChanged: (value) {
                    firstname = value;
                  },
                  validator: validateName,
                  decoration: InputDecoration(
                    labelText: "First Name",
                    hintText: "Enter First Name",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(
                      Icons.apartment,
                      color: kPrimaryColor,
                    ),
                    hintStyle:
                        TextStyle(color: Color(0xff979797), fontSize: 12),
                    labelStyle: TextStyle(color: kPrimaryColor, fontSize: 16),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff979797))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  onSaved: (newValue) => lastname = newValue,
                  onChanged: (value) {
                    lastname = value;
                  },
                  validator: validateName,
                  decoration: InputDecoration(
                    labelText: "Last Name",
                    hintText: "Enter Last Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                    hintStyle:
                        TextStyle(color: Color(0xff979797), fontSize: 12),
                    labelStyle: TextStyle(color: kPrimaryColor, fontSize: 16),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff979797))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                    hintText: "Enter User Name",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                    hintStyle:
                        TextStyle(color: Color(0xff979797), fontSize: 12),
                    labelStyle: TextStyle(color: kPrimaryColor, fontSize: 16),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff979797))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                    hintText: "Enter User email",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(
                      Icons.email,
                      color: kPrimaryColor,
                    ),
                    hintStyle:
                        TextStyle(color: Color(0xff979797), fontSize: 12),
                    labelStyle: TextStyle(color: kPrimaryColor, fontSize: 16),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff979797))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor, width: 2)),
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
                    prefixIcon: Icon(
                      Icons.password,
                      color: kPrimaryColor,
                    ),
                    hintStyle:
                        TextStyle(color: Color(0xff979797), fontSize: 12),
                    labelStyle: TextStyle(color: kPrimaryColor, fontSize: 16),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff979797))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.phone,
                  //maxLength: 10,
                  onSaved: (newValue) => phone = newValue,
                  onChanged: (value) {
                    phone = value;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: validateMobile,
                  decoration: InputDecoration(
                    labelText: "Mobile",
                    hintText: "Enter User Mobile Number",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: kPrimaryColor,
                    ),
                    hintStyle:
                        TextStyle(color: Color(0xff979797), fontSize: 12),
                    labelStyle: TextStyle(color: kPrimaryColor, fontSize: 16),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff979797))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                    hintText: "Enter User Address",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: kPrimaryColor,
                    ),
                    hintStyle:
                        TextStyle(color: Color(0xff979797), fontSize: 12),
                    labelStyle: TextStyle(color: kPrimaryColor, fontSize: 16),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff979797))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
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
                  controller: cityText,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                  onSaved: (newValue) => city = newValue,
                  //readOnly: true,
                  validator: validateName,
                  decoration: InputDecoration(
                    labelText: "City",
                    hintText: "Enter User City",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: kPrimaryColor,
                    ),
                    hintStyle:
                        TextStyle(color: Color(0xff979797), fontSize: 12),
                    labelStyle: TextStyle(color: kPrimaryColor, fontSize: 16),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff979797))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Focus(
                  onFocusChange: (v) {
                    print("object focus changed rsponse $v");
                    if (v == false) {
                      if (pin.text.length == 6) {
                        getOtherAttributes(pin.text);
                      } else {
                        Alerts.showAlertAndBack(context, "Incorrect PinCode",
                            "Enter a valid Pincode");
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
                      hintText: "Enter User Pincode",
                      // If  you are using latest version of flutter then lable text and hint text shown like this
                      // if you r using flutter less then 1.20.* then maybe this is not working properly
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: kPrimaryColor,
                      ),
                      hintStyle:
                          TextStyle(color: Color(0xff979797), fontSize: 12),
                      labelStyle: TextStyle(color: kPrimaryColor, fontSize: 16),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff979797))),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: kPrimaryColor, width: 2)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: stateText,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  onSaved: (newValue) => state = newValue,
                  //readOnly: true,
                  validator: validateRequired,
                  decoration: InputDecoration(
                    labelText: "State",
                    hintText: "Enter User State",
                    // If  you are using latest version of flutter then lable text and hint text shown like this
                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: kPrimaryColor,
                    ),
                    hintStyle:
                        TextStyle(color: Color(0xff979797), fontSize: 12),
                    labelStyle: TextStyle(color: kPrimaryColor, fontSize: 16),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff979797))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kPrimaryColor, width: 2)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xff979797)),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: DropdownSearch<String>(
                      validator: (v) => v == null ? "required field" : null,
                      mode: Mode.MENU,
                      //selectedItem: dropdownValue,
                      dropdownSearchDecoration: InputDecoration(
                        //contentPadding: EdgeInsets.only(left: 30, right: 20, top: 5, bottom: 5),
                        alignLabelWithHint: true,
                        hintText: "Please Select Role",
                        //hintStyle: TextStyle(color: Colors.black45),
                        // focusedErrorBorder: InputDecoration(borderSide: BorderSide(color: Colors.red),),
                        // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),),
                        // focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), ),
                      ),
                      showSelectedItems: true,
                      items: salesmanName,
                      onChanged: (value) {
                        setState(() {
                          dropdownValue = value;
                        });
                        print("customer selected: $value");
                        for (int i = 0; i < roleList.length; i++) {
                          if (roleList[i].roleName == dropdownValue) {
                            setState(() {
                              roleId = roleList[i].roleId;
                            });
                          }
                        }
                        print("object customer id $roleId");
                      },
                      //selectedItem: "Please Select your Area",
                    )),
              ],
            ),
          );
        });
  }

  List<String> areaWise = ['Please Select your Area'];

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
      print("object ${response.body == null}");
      var result = json.decode(response.body);
      print("object $result");

      if (result[0]["Message"] == "No records found") {
        pr.hide();
        Alerts.showAlertAndBack(
            context, "Incorrect PinCode", "Enter a valid Pincode");
      } else {
        pr.hide();
        //String cityN = result[0]["PostOffice"][0]["Division"];
        String stateN = result[0]["PostOffice"][0]["State"];

        setState(() {
          //cityText = TextEditingController(text: cityN);
          stateText = TextEditingController(text: stateN);

          for (int i = 0; i < result[0]["PostOffice"].length; i++) {
            print("value for areas ${result[0]["PostOffice"][i]["Name"]}");
            areaWise.add("${result[0]["PostOffice"][i]["Name"]}");
          }
        });
      }
      print(
          "object value for the region ${result[0]["Message"]} ${result[0]["PostOffice"][0]["Region"]}");
      //pr.hide();
    }
  }

  stateWiseCity(List<String> listsId) async {
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: true,
    );
    pr.style(
      message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),
    );
    pr.show();
    var response = await http.post(
        Uri.parse(
            "http://loccon.in/desiremoulding/api/AdminApiController/stateWiseCity"),
        body: {
          "secretkey": Connection.secretKey,
          "state_id": listsId.toString()
        });

    var result = CityModel.fromJson(json.decode(response.body));

    print('results: $result');

    pr.hide();

    if (result.status == true) {
      // Alerts.showAlertAndBack(context, '', result['message']);
      setState(() {
        cityList.addAll(result.cityData);
      });
      return true;
    } else {
      Alerts.showAlertAndBack(context, 'Error SignUP', 'Try again later');
      return false;
    }
  }

  registerNow() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(
          "values from form $firstname \n $uName \n $password \n $email \n $lastname \n $phone \n $address \n $pincode \n"
          "\n $city \n $state");
      ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: true,
      );
      pr.style(
        message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),
      );
      pr.show();

      var response =
          await http.post(Uri.parse(Connection.submitNewAdminUser), body: {
        "role_id": "$roleId",
        "first_name": "$firstname",
        "last_name": "$lastname",
        "email": "$email",
        "mobile": "$phone",
        "username": "$uName",
        "password": "$password",
        "pincode": "$pincode",
        "state": "$state",
        "city": "$city",
        "address": "$address",
        "secretkey": Connection.secretKey
      });

      var result = json.decode(response.body);

      print('results: $result');

      pr.hide();

      if (result['status'] == true) {
        // Alerts.showAlertAndBack(context, '', result['message']);
        final snackBar = SnackBar(content: Text(result['message']));
        userId = result['user_id'];
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        setState(() {
          anotherViewVisible = true;
        });

        if (anotherViewVisible && dropdownValue == "Sales") {
          stateBloc.fetchState();
        } else {
          Navigator.pop(context, true);
        }
        // Navigator.pop(context, true);
        return true;
      } else {
        Alerts.showAlertAndBack(context, 'Error SignUP', 'Try again later');
        return false;
      }
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  viewAssignArea() async {
    if (_formKeyRegion.currentState.validate()) {
      _formKeyRegion.currentState.save();
      var val = selectedStateList.map((e) {
        dynamic data = new Map();
        data[e.stateId] = selectedCityList
            .where((c) => c.stateId == e.stateId)
            .map((e) => e.cityId)
            .toList();
        return data;
      }).toList();
      print(jsonEncode(val));
      ProgressDialog pr = ProgressDialog(
        context,
        type: ProgressDialogType.Normal,
        isDismissible: true,
      );
      pr.style(
        message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),
      );
      pr.show();
      var response = await http.post(
          Uri.parse(
              "http://loccon.in/desiremoulding/api/AdminApiController/viewAssignArea"),
          body: {
            "secretkey": Connection.secretKey,
            "sales_id": userId.toString(),
            "assign_area": jsonEncode(val)
          });

      var result = json.decode(response.body);

      print('results: $result');

      pr.hide();

      if (result['status'] == true) {
        // Alerts.showAlertAndBack(context, '', result['message']);
        final snackBar = SnackBar(content: Text(result['message']));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context, true);
        txt.text = "";
        cityController.text = "";
        return true;
      } else {
        Alerts.showAlertAndBack(context, 'Error SignUP', 'Try again later');
        return false;
      }
    }
    else{
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }
}
