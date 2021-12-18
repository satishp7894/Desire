import 'dart:convert';
import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/pages/cart/cust_cart_page.dart';
import 'package:desire_users/pages/profile/user_detail_page.dart';
import 'package:desire_users/services/check_block.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:desire_users/bloc/address_bloc.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/models/address_model.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/progress_dialog.dart';
import 'package:desire_users/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressViewPage extends StatefulWidget {

  final String userId;
  final String page;
  final bool status;
  final int orderCount;
  AddressViewPage({@required this.userId , @required this.page, @required this.status, @required this.orderCount});

  @override
  _AddressViewPageState createState() => _AddressViewPageState();
}

class _AddressViewPageState extends State<AddressViewPage> with Validator{

  TextEditingController name;
  TextEditingController flat;
  TextEditingController street;
  TextEditingController landmark;
  TextEditingController pincode;
  TextEditingController city;
  TextEditingController district;
  TextEditingController state;
  TextEditingController mobile;

  final _focusNode = FocusNode();

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

  @override
  void initState(){
    super.initState();
    checkConnectivity();
    if(widget.status)
    {
      getDetailsB();
    }
    getPrefs();
    addBloc.fetchAddress(widget.userId);
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
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }

  getPrefs()async{
    prefs = await SharedPreferences.getInstance();
  }

  String customerId = " ";
  String customerName = " ";
  String customerEmail = " ";
  String customerMobile = " ";
  getDetailsB() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerMobile = prefs.getString("Mobile_no");
    customerId = prefs.getString("customer_id");
    customerName = prefs.getString("Customer_name");
    customerEmail = prefs.getString("Email");
    print("object $customerMobile ${widget.page}");
    final checkBloc = CheckBlocked(customerMobile);
    checkBloc.getDetailsAddress(context, widget.userId, widget.page);
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
        print("Address Id: $addressId");
      print("object $_verticalGroupValue");

  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddressViewPage(userId: widget.userId,page: "address",status: true,orderCount: widget.orderCount)));
      },
      child: SafeArea(
          child:Scaffold(
            appBar: AppBar(
              title: Text("Shipping Address"),
              centerTitle: true,
              elevation: 0,
              backgroundColor:kSecondaryColor.withOpacity(0),

              textTheme: Theme.of(context).textTheme,

            ),
            body: _body(),
          )
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
                    return Center(child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),);
                  }
                  if (s.hasError) {
                    return Container(
                        alignment: Alignment.center,
                        child: Text('error '+s.error));
                  }
                  // if (s.data.data.isEmpty) {
                  //   return Container(
                  //       alignment: Alignment.center,
                  //       child: Text('No Address Found', textAlign: TextAlign.center,));
                  // }
                  if (s.data.data == null) {
                    return Container(
                        alignment: Alignment.center,
                        child: Text('No Address Found', textAlign: TextAlign.center,));
                  }
                  if(prefs.getString("add") != null){
                    getSavedAddress();
                  } else {
                    _verticalGroupValue = "";
                    _addressGroup = _verticalGroupValue;
                    addressId = "";
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
                                  "${s.data.data[i].locality},\n${s.data.data[i].landmark},\n${s.data.data[i].district},"
                                  "${s.data.data[i].city},${s.data.data[i].state},${s.data.data[i].pincode}.\nMob: "
                                  "${s.data.data[i].mobileNo}", textAlign: TextAlign.left,),
                              value: s.data.data[i].addressId,
                              onChanged: (val) {
                                setState(() {
                                  _addressGroup = "${s.data.data[i].name}"
                                      "\n${s.data.data[i].address},""${s.data.data[i].locality},${s.data.data[i].landmark},"
                                      "\n${s.data.data[i].district},""${s.data.data[i].city},${s.data.data[i].state},"
                                      "\n${s.data.data[i].pincode}.\nMob: ""${s.data.data[i].mobileNo}";
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
                                      showDialog(context: context, builder: (builder) => EditDialog(data: s.data.data[i], userId: widget.userId, page: widget.page, status: widget.status, orderCount: widget.orderCount, context: context,));
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

    widget.page == "cart" ? Navigator.push(context, MaterialPageRoute(builder: (builder) => CustCartPage(
      customerName: customerName,
      customerEmail: customerEmail,
      customerMobile: customerMobile,
      customerId: customerId,
    ))) : Navigator.push(context, MaterialPageRoute(builder: (builder) => UserDetailPage(status: true, orderCount: widget.orderCount)));

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
                  //maxLength: 6,
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  validator: validatePinCode,
                  controller: pincode,
                  scrollPadding: EdgeInsets.zero,
                  // onFieldSubmitted: (value){
                  //   getOtherAttributes(value);
                  // },
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
          +".\n\n +91 "+mobile.text +"type:"+_verticalGroupValue1;
      print(address);
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();
      var response = await http.post(Uri.parse(Connection.addAddress), body: {

        'secretkey': Connection.secretKey,
        'customer_id':'${widget.userId}',
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
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AddressViewPage(userId: widget.userId, page: widget.page,status: true,orderCount: widget.orderCount)), (Route<dynamic> route) => false);
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
        'customer_id':'${widget.userId}',
        "address_id": id

      });
      var results = json.decode(response.body);
      print('response == $results  ${response.body}');
      pr.hide();
      if (results['status'] == true) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AddressViewPage(userId: widget.userId,status: true, page: widget.page,orderCount: widget.orderCount)), (Route<dynamic> route) => false);
      } else {
        print('error deleting address');
        Alerts.showAlertAndBack(context, 'Error', 'Address not Deleted.');
      }
  }

  editAddress(BuildContext context, Datum data){

    TextEditingController nameD = TextEditingController(text: data.name);
    TextEditingController flatD = TextEditingController(text: data.address);
    TextEditingController streetD = TextEditingController(text: data.locality);
    TextEditingController landmarkD = TextEditingController(text: data.landmark);
    TextEditingController pincodeD = TextEditingController(text: data.pincode);
    TextEditingController cityD = TextEditingController(text: data.city);
    TextEditingController districtD = TextEditingController(text: data.district);
    TextEditingController stateD = TextEditingController(text: data.state);
    TextEditingController mobileD = TextEditingController(text: data.mobileNo);

    AutovalidateMode _autovalidateMode1 = AutovalidateMode.disabled;
    final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();

    String _verticalGroupValue12 = "Work";

    List<String> _status12 = ["Work","Home"];

    showDialog(context: context,
      builder: (BuildContext c) {
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
                      validator: (String value) {
                        String pattern = r'(^[a-zA-Z ]*$)';
                        RegExp regExp = RegExp(pattern);
                        if (value.isEmpty) {
                          return "This field is Required";
                        } else if (!regExp.hasMatch(value)) {
                          return "Invalid Name";
                        }
                        return null;
                      },
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
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "This field is Required";
                        }
                        return null;
                      },
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
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "This field is Required";
                        }
                        return null;
                      },
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
                          getOtherAttributes(pincode.text);
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
                        // onFieldSubmitted: (value){
                        //   setState(() {
                        //     getOtherAttributes(value);
                        //   });
                        // },
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
                Navigator.of(c).pop();
              },
            ),
            CupertinoButton(
              child: Text("Edit", style: TextStyle(color: Colors.red),),
              onPressed: () async{
                Navigator.of(c).pop();
                if (_formkey1.currentState.validate()){
                  _formkey1.currentState.save();
                  ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
                    isDismissible: false,);
                  pr.style(message: 'Please wait...',
                    progressWidget: Center(child: CircularProgressIndicator()),);
                  pr.show();
                  var response = await http.post(Uri.parse(Connection.editAddress), body: {
                    'secretkey':Connection.secretKey,
                    'address_id':addressId,
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
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => AddressViewPage(userId: widget.userId, page: widget.page, status: widget.status, orderCount: widget.orderCount)), (route) => false);
                  } else {
                    Alerts.showAlertAndBack(context, "Password Reset Failed", "Incorrect EmailId");
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
                          getOtherAttributes(pincode.text);
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
                Navigator.of(c).pop();
              },
            ),
            TextButton(
              child: Text("Edit", style: TextStyle(color: Colors.red),),
              onPressed: () async{
                Navigator.of(c).pop();
                if (_formkey1.currentState.validate()){
                  _formkey1.currentState.save();
                  ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
                    isDismissible: false,);
                  pr.style(message: 'Please wait...',
                    progressWidget: Center(child: CircularProgressIndicator()),);
                  pr.show();
                  var response = await http.post(Uri.parse(Connection.editAddress), body: {
                    'secretkey':Connection.secretKey,
                    'address_id':addressId,
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
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => AddressViewPage(userId: widget.userId, page: widget.page, status: widget.status, orderCount: widget.orderCount)), (route) => false);
                  } else {
                    Alerts.showAlertAndBack(context, "Password Reset Failed", "Incorrect EmailId");
                  }
                } else {
                  _autovalidateMode1 = AutovalidateMode.always;
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class EditDialog extends StatefulWidget {

  final Datum data;
  final String userId;
  final String page;
  final bool status;
  final int orderCount;
  final BuildContext context;

  const EditDialog({@required this.data, @required this.userId, @required this.page, @required this.status, @required this.orderCount, @required this.context});

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
                Navigator.pushAndRemoveUntil(contextDialog, MaterialPageRoute(builder: (builder) => AddressViewPage(userId: widget.userId, page: widget.page, status: widget.status, orderCount: widget.orderCount)), (route) => false);
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
                Navigator.pushAndRemoveUntil(contextDialog, MaterialPageRoute(builder: (builder) => AddressViewPage(userId: widget.userId, page: widget.page, status: widget.status, orderCount: widget.orderCount)), (route) => false);
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

