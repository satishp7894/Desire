import 'dart:convert';
import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/address_bloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/address_model.dart';
import 'package:desire_production/model/sales_customer_list_model.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'customer_cart_page.dart';

class CustomerAddressViewPage extends StatefulWidget {

  final String customerId;
  final String page;
  final String customerName;
  final CustomerModel customer;
  CustomerAddressViewPage({@required this.customerId , @required this.customerName, @required this.page, this.customer});

  @override
  _CustomerAddressViewPageState createState() => _CustomerAddressViewPageState();
}

class _CustomerAddressViewPageState extends State<CustomerAddressViewPage> with Validator{

  TextEditingController name;
  TextEditingController flat;
  TextEditingController street;
  TextEditingController landmark;
  TextEditingController pincode;
  TextEditingController city;
  TextEditingController district;
  TextEditingController state;
  TextEditingController mobile;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();


  bool isExpand = false;
  final addBloc = AddressBloc();


  String _verticalGroupValue;
  String _verticalGroupValue1 = "Work";

  List<String> _status1 = ["Work","Home"];

  String _addressGroup;
  String addressId;

  SharedPreferences prefs;

  final _focusNode = FocusNode();

  @override
  void initState(){
    super.initState();
    checkConnectivity();
    getPrefs();
    addBloc.fetchAddress(widget.customerId);
    name = TextEditingController();
    flat= TextEditingController();
    street= TextEditingController();
    landmark= TextEditingController();
    pincode= TextEditingController();
    city= TextEditingController();
    district= TextEditingController();
    state= TextEditingController();
    mobile= TextEditingController();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
    });
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

  getPrefs()async{
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    flat.dispose();
    street.dispose();
    landmark.dispose();
    pincode.dispose();
    city.dispose();
    district.dispose();
    state.dispose();
    mobile.dispose();
    _focusNode.dispose();
  }
  getSavedAddress() async{

    _verticalGroupValue = prefs.getString("add");
    _addressGroup = _verticalGroupValue;
    addressId = prefs.getString("add_id");
    print("object $_verticalGroupValue");

  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CustomerAddressViewPage(customerId: widget.customerId,page: widget.page, customerName: widget.customerName, customer: widget.customer, )), (Route<dynamic> route) => false);
      },
      child: WillPopScope(
        onWillPop: () {
          return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerCartPage(customerId: widget.customerId, customerName: widget.customerName,)), (route) => false);
        },
        child: SafeArea(
            child:Scaffold(
              appBar: AppBar(
                title: Text("Shipping Address"),
                centerTitle: true,
                elevation: 0,
                backgroundColor:kSecondaryColor.withOpacity(0),
                titleTextStyle: headingStyle,
                textTheme: Theme.of(context).textTheme,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black,),
                  onPressed: (){
                    widget.page == "cart" ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerCartPage(customerId: widget.customerId, customerName: widget.customerName, )), (route) => false) : Navigator.of(context).pop();
                  },
                ),
              ),
              body: _body(),
            )
        ),
      ),
    );
  }

  Widget _body(){
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        //height: double.infinity,
        padding: EdgeInsets.only(top: 10, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50,),
            Container(
              color: Colors.white70,
              //height: 80,
              padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  backgroundColor: Colors.transparent,
                  trailing: SizedBox.shrink(),
                  onExpansionChanged: (bool expanding) => setState(() => this.isExpand = expanding),
                  leading:  isExpand ? Icon(Icons.remove, color: Color(0xFFFF7643),) : Icon(Icons.add, color: Color(0xFFFF7643),),
                  title: Text('Add Address', style: TextStyle(color: Colors.black45,fontSize: 18, fontWeight: FontWeight.w500),),
                  children: [
                    _address()
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            StreamBuilder<AddressModel>(
                stream: addBloc.newAddressStream,
                builder:(c,s) {
                  if (s.connectionState != ConnectionState.active) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  if (s.hasError) {
                    return Container(
                        alignment: Alignment.center,
                        child: Text('error '+s.error));
                  }
                  if (s.data.data == null) {
                    return Container(
                        alignment: Alignment.center,
                        child: Text('No Address Found', textAlign: TextAlign.center,));
                  }
                  if(prefs.getString("add") != null){
                    getSavedAddress();
                  } else {
                    _verticalGroupValue = "${s.data.data[0].name}\n${s.data.data[0].address},"
                        "${s.data.data[0].locality},${s.data.data[0].landmark},\n${s.data.data[0].district},"
                        "${s.data.data[0].city},${s.data.data[0].state},${s.data.data[0].pincode}.\nMob: "
                        "${s.data.data[0].mobileNo}";
                    _addressGroup = _verticalGroupValue;
                    addressId = s.data.data[0].addressId;
                    saveAddress();
                  }
                  return Column(
                    children: <Widget>[

                      for(int i=0; i<s.data.data.length; i++)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex:2,
                              child: RadioListTile(
                                groupValue: addressId,
                                title: Text("${s.data.data[i].name} (${s.data.data[i].addressType})"),
                                subtitle: Text("${s.data.data[i].address},"
                                    "${s.data.data[i].locality},${s.data.data[i].landmark},\n${s.data.data[i].district},"
                                    "${s.data.data[i].city},${s.data.data[i].state},${s.data.data[i].pincode}.\nMob: "
                                    "${s.data.data[i].mobileNo}", textAlign: TextAlign.left,),
                                value: s.data.data[i].addressId,
                                onChanged: (val) {
                                  setState(() {
                                    _addressGroup = "${s.data.data[i].name}\n${s.data.data[i].address},"
                                        "${s.data.data[i].locality},${s.data.data[i].landmark},\n${s.data.data[i].district},"
                                        "${s.data.data[i].city},${s.data.data[i].state},${s.data.data[i].pincode}.\nMob: "
                                        "${s.data.data[i].mobileNo}";
                                    addressId = val;
                                    print("object value selected $val \n $_addressGroup \n $addressId");
                                  });
                                  saveAddress();
                                },
                              ),
                            ),

                            Expanded(
                              child: Column(
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.edit_outlined, color: kPrimaryColor,),
                                      onPressed: (){
                                        showDialog(context: context, builder: (builder) => EditDialog(data: s.data.data[i], userId: widget.customerId, page: widget.page, context: context, customerName: widget.customerName,));
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.delete_outline),
                                      onPressed: (){
                                        delAddress(s.data.data[i].addressId);
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }

  saveAddress() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("add", _addressGroup);
    prefs.setString("add_id", addressId);
  }

  Widget _address(){
    return Form(
      autovalidateMode: _autovalidateMode,
      key: _formkey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
              child: TextFormField(
                validator: validateName,
                controller: name,
                decoration: InputDecoration(
                  labelText: 'Name',
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
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: flat,
                decoration: InputDecoration(
                  labelText: 'Flat No. House/Building',
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
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: street,
                decoration: InputDecoration(
                  labelText: 'Street address / Colony',
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
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
              child: TextFormField(
                validator: validateName,
                controller: landmark,
                decoration: InputDecoration(
                  labelText: 'Landmark',
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
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
              child: Focus(
                onFocusChange: (v){
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
                  //maxLength: 6,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  validator: validatePinCode,
                  controller: pincode,
                  scrollPadding: EdgeInsets.zero,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
              child: TextFormField(
                validator: validateName,
                controller: city,
                decoration: InputDecoration(
                  labelText: 'City',
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
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
              child: TextFormField(
                validator: validateName,
                controller: district,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'District',
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
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
              child: TextFormField(
                validator: validateName,
                controller: state,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'State',
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
              padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                validator: validateMobile,
                controller: mobile,
                decoration: InputDecoration(
                  labelText: 'Mobile No.',
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
              padding: EdgeInsets.only(left: 20.0, right: 10.0, top: 10),
              child: Row(
                children: [
                  Text("Address Type"),
                  RadioGroup<String>.builder(
                    direction: Axis.horizontal,
                    groupValue: _verticalGroupValue1,
                    onChanged: (value) => setState(() {
                      _verticalGroupValue1 = value;
                      print("object address type $value");
                    }),
                    items: _status1,
                    itemBuilder: (item) => RadioButtonBuilder(
                      item,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 10),
                  child: DefaultButton(
                    text: "Save",
                    press: (){
                      addAddress();
                    },
                  )
              ),
            ),
          ],
        ),
      ),
    );
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
        String districtN = result[0]["PostOffice"][0]["District"];

        setState(() {
          //city = TextEditingController(text: cityN);
          state = TextEditingController(text: stateN);
          district = TextEditingController(text: districtN);
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

  addAddress() async{
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      String address = flat.text+", "+street.text+", "+landmark.text+", "+pincode.text+", "+city.text+", "+state.text
          +".\n\n +91 "+mobile.text;
      print(address);
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();
      var response = await http.post(Uri.parse(Connection.addAddress), body: {

        'secretkey': Connection.secretKey,
        'customer_id':'${widget.customerId}',
        'name':'${name.text}',
        'address':'${flat.text}',
        'locality':'${street.text}',
        'landmark':'${landmark.text}',
        'city':'${city.text}',
        'district':'${district.text}',
        'pincode':'${pincode.text}',
        'state':'${state.text}',
        'address_type':'$_verticalGroupValue1',
        'mobile':'${mobile.text}'

      });
      var results = json.decode(response.body);
      print('response == $results  ${response.body}');
      pr.hide();
      if (results['status'] == true) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CustomerAddressViewPage(customerId: widget.customerId, page: widget.page, customerName: widget.customerName,customer: widget.customer,)), (Route<dynamic> route) => false);
      } else {
        print('error in add address');
        Alerts.showAlertAndBack(context, 'Error', 'Address not Added.');
      }
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  delAddress(String id) async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    var response = await http.post(Uri.parse(Connection.delAddress), body: {

      'secretkey': Connection.secretKey,
      'customer_id':'${widget.customerId}',
      "address_id": id

    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => CustomerAddressViewPage(customerId: widget.customerId, page: "cart", customerName: widget.customerName,customer:  widget.customer,)), (Route<dynamic> route) => false);
    } else {
      print('error deleting address');
      Alerts.showAlertAndBack(context, 'Error', 'Address not Deleted.');
    }
  }

}

class EditDialog extends StatefulWidget {

  final Datum data;
  final String userId;
  final String page;
  final String customerName;

  final BuildContext context;

  const EditDialog({@required this.data, @required this.userId, @required this.page, @required this.context, @required this.customerName,});

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> with Validator{

  AutovalidateMode _autovalidateMode1 = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();

  String _verticalGroupValue12 = "Work";

  List<String> _status12 = ["Work","Home"];

  final _focusNode = FocusNode();

  TextEditingController nameD;
  TextEditingController flatD;
  TextEditingController streetD;
  TextEditingController landmarkD;
  TextEditingController pincodeD;
  TextEditingController cityD;
  TextEditingController districtD;
  TextEditingController stateD;
  TextEditingController mobileD;
  BuildContext contextDialog;

  @override
  void initState() {
    super.initState();
    contextDialog = widget.context;
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
    });
    nameD = TextEditingController(text: widget.data.name);
    flatD= TextEditingController(text: widget.data.address);
    streetD= TextEditingController(text: widget.data.locality);
    landmarkD= TextEditingController(text: widget.data.landmark);
    pincodeD= TextEditingController(text: widget.data.pincode);
    cityD= TextEditingController(text: widget.data.city);
    districtD= TextEditingController(text: widget.data.district);
    stateD= TextEditingController(text: widget.data.state);
    mobileD= TextEditingController(text: widget.data.mobileNo);
    widget.data.addressType == null ? _verticalGroupValue12 = "Work" : _verticalGroupValue12 = widget.data.addressType;
  }

  @override
  void dispose() {
    super.dispose();
    nameD.dispose();
    flatD.dispose();
    streetD.dispose();
    landmarkD.dispose();
    pincodeD.dispose();
    cityD.dispose();
    districtD.dispose();
    stateD.dispose();
    mobileD.dispose();
    _focusNode.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Platform.isIOS ? CupertinoAlertDialog(
      title: Text('Edit Address', textAlign: TextAlign.center,),
      content: Form(
        autovalidateMode: _autovalidateMode1,
        key: _formkey1,
        child: Container(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: validateName,
                  controller: nameD,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextFormField(
                  validator: validateRequired,
                  controller: flatD,
                  decoration: InputDecoration(
                    labelText: 'Flat No. House/Building',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextFormField(
                  validator: validateRequired,
                  controller: streetD,
                  decoration: InputDecoration(
                    labelText: 'Street address / Colony',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextFormField(
                  validator: validateName,
                  controller: landmarkD,
                  decoration: InputDecoration(
                    labelText: 'Landmark',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                Focus(
                  onFocusChange: (v){
                    // getOtherAttributes(pincode.text);
                    print("object focus changed rsponse $v");
                    if(v == false){
                      getOtherAttributes(pincodeD.text);
                    }
                  },
                  child: TextFormField(
                    //maxLength: 6,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    validator: validatePinCode,
                    controller: pincodeD,
                    scrollPadding: EdgeInsets.zero,
                    onFieldSubmitted: (value){
                      setState(() {
                        getOtherAttributes(value);
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Pincode',
                      hoverColor: Color(0xFFFF7643),
                      labelStyle: TextStyle(color: Colors.grey),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  validator: validateName,
                  controller: cityD,
                  decoration: InputDecoration(
                    labelText: 'City',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextFormField(
                  validator: validateName,
                  controller: districtD,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'District',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextFormField(
                  validator: validateName,
                  controller: stateD,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'State',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  validator: validateMobile,
                  controller: mobileD,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Mobile No.',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text("Address Type", style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.start,),
                    RadioGroup<String>.builder(
                      direction: Axis.vertical,
                      groupValue: _verticalGroupValue12,
                      onChanged: (value) => setState(() {
                        _verticalGroupValue12 = value;
                        print("object address type $value");
                      }),
                      items: _status12,
                      itemBuilder: (item) => RadioButtonBuilder(
                        item,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        CupertinoButton(
          child: Text("Cancel", style: TextStyle(color: Colors.red),),
          onPressed: () {
            Navigator.of(contextDialog).pop();
          },
        ),
        CupertinoButton(
          child: Text("Edit", style: TextStyle(color: Colors.red),),
          onPressed: () async{
            Navigator.of(contextDialog).pop();
            if (_formkey1.currentState.validate()){
              _formkey1.currentState.save();
              ProgressDialog pr = ProgressDialog(contextDialog, type: ProgressDialogType.Normal,
                isDismissible: false,);
              pr.style(message: 'Please wait...',
                progressWidget: Center(child: CircularProgressIndicator()),);
              pr.show();
              var response = await http.post(Uri.parse(Connection.editAddress), body: {
                'secretkey':Connection.secretKey,
                'address_id':widget.data.addressId,
                'customer_id':widget.userId,
                'name':'${nameD.text}',
                'address':'${flatD.text}',
                'locality':'${streetD.text}',
                'landmark':'${landmarkD.text}',
                'city':'${cityD.text}',
                'district':'${districtD.text}',
                'pincode':'${pincodeD.text}',
                'state':'${stateD.text}',
                'address_type':'$_verticalGroupValue12',
                'mobile':'${mobileD.text}'
              });
              var results = json.decode(response.body);
              pr.hide();
              if (results['status'] == true) {
                print("user details ${results['status']}");
                Navigator.pushAndRemoveUntil(contextDialog, MaterialPageRoute(builder: (builder) => CustomerAddressViewPage(customerId: widget.userId, page: widget.page,  customerName: widget.customerName)), (route) => false);
              } else {
                Alerts.showAlertAndBack(contextDialog, "Password Reset Failed", "Incorrect EmailId");
              }
            } else {
              _autovalidateMode1 = AutovalidateMode.always;
            }
          },
        ),
      ],
    ) :
    AlertDialog(
      title: Text('Edit Address', textAlign: TextAlign.center,),
      content: Form(
        autovalidateMode: _autovalidateMode1,
        key: _formkey1,
        child: Container(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: validateName,
                  controller: nameD,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextFormField(
                  validator: validateRequired,
                  controller: flatD,
                  decoration: InputDecoration(
                    labelText: 'Flat No. House/Building',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextFormField(
                  validator: validateRequired,
                  controller: streetD,
                  decoration: InputDecoration(
                    labelText: 'Street address / Colony',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextFormField(
                  validator: validateName,
                  controller: landmarkD,
                  decoration: InputDecoration(
                    labelText: 'Landmark',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                Focus(
                  onFocusChange: (v){
                    // getOtherAttributes(pincode.text);
                    print("object focus changed rsponse $v");
                    if(v == false){
                      getOtherAttributes(pincodeD.text);
                    }
                  },
                  child: TextFormField(
                    //maxLength: 6,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    validator: validatePinCode,
                    controller: pincodeD,
                    scrollPadding: EdgeInsets.zero,
                    onFieldSubmitted: (value){
                      setState(() {
                        getOtherAttributes(value);
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Pincode',
                      hoverColor: Color(0xFFFF7643),
                      labelStyle: TextStyle(color: Colors.grey),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  validator: validateName,
                  controller: cityD,
                  decoration: InputDecoration(
                    labelText: 'City',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextFormField(
                  validator: validateName,
                  controller: districtD,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'District',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextFormField(
                  validator: validateName,
                  controller: stateD,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'State',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  validator: validateMobile,
                  controller: mobileD,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Mobile No.',
                    hoverColor: Color(0xFFFF7643),
                    labelStyle: TextStyle(color: Colors.grey),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 5,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Address Type", style: TextStyle(color: Colors.grey, fontSize: 12), textAlign: TextAlign.start,),
                    RadioGroup<String>.builder(
                      direction: Axis.vertical,
                      groupValue: _verticalGroupValue12,
                      onChanged: (value) => setState(() {
                        setState(() {
                          _verticalGroupValue12 = value;
                        });
                        print("object address type $value");
                      }),
                      items: _status12,
                      itemBuilder: (item) => RadioButtonBuilder(
                        item,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text("Cancel", style: TextStyle(color: Colors.red),),
          onPressed: () {
            Navigator.of(contextDialog).pop();
          },
        ),
        TextButton(
          child: Text("Edit", style: TextStyle(color: Colors.red),),
          onPressed: () async{
            Navigator.of(contextDialog).pop();
            if (_formkey1.currentState.validate()){
              _formkey1.currentState.save();
              ProgressDialog pr = ProgressDialog(contextDialog, type: ProgressDialogType.Normal,
                isDismissible: false,);
              pr.style(message: 'Please wait...',
                progressWidget: Center(child: CircularProgressIndicator()),);
              pr.show();
              var response = await http.post(Uri.parse(Connection.editAddress), body: {
                'secretkey':Connection.secretKey,
                'address_id':widget.data.addressId,
                'customer_id':widget.userId,
                'name':'${nameD.text}',
                'address':'${flatD.text}',
                'locality':'${streetD.text}',
                'landmark':'${landmarkD.text}',
                'city':'${cityD.text}',
                'district':'${districtD.text}',
                'pincode':'${pincodeD.text}',
                'state':'${stateD.text}',
                'address_type':'$_verticalGroupValue12',
                'mobile':'${mobileD.text}'
              });
              var results = json.decode(response.body);
              pr.hide();
              if (results['status'] == true) {
                print("user details ${results['status']}");
                Navigator.pushAndRemoveUntil(contextDialog, MaterialPageRoute(builder: (builder) => CustomerAddressViewPage(customerId: widget.userId, page: widget.page, customerName: widget.customerName, )), (route) => false);
              } else {
                Alerts.showAlertAndBack(contextDialog, "Password Reset Failed", "Incorrect EmailId");
              }
            } else {
              _autovalidateMode1 = AutovalidateMode.always;
            }
          },
        ),
      ],
    );
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
        String districtN = result[0]["PostOffice"][0]["District"];

        setState(() {
          stateD = TextEditingController(text: stateN);
          districtD = TextEditingController(text: districtN);
        });

        print(
            "object value for the region ${result[0]["Message"]} ${result[0]["PostOffice"][0]["Region"]}");
        pr.hide();
      }
    }
  }

}

