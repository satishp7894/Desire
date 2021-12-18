import 'dart:convert';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/admin_list_bloc.dart';
import 'package:desire_production/bloc/role_bloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/role_model.dart';
import 'package:desire_production/model/user_model.dart';
import 'package:desire_production/pages/admin/sales/sales_edit_page.dart';
import 'package:desire_production/pages/admin/sales/salesman_details_page.dart';
import 'package:desire_production/pages/dashboards/dashboard_page_admin.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/drawer_admin.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import 'sales/sales_customer_list_page.dart';

class AdminUserListPage extends StatefulWidget {

  final String adminUserId;

  const AdminUserListPage({@required this.adminUserId});


  @override
  _AdminUserListPageState createState() => _AdminUserListPageState();
}

class _AdminUserListPageState extends State<AdminUserListPage> with Validator{

  final adminBloc = AdminListBloc();
  TextEditingController searchView;
  bool search = false;
  List<User> _searchResult = [];
  List<User> userList = [];
  List<bool> status = [];

  bool isExpand = false;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController fname;
  TextEditingController lname;
  TextEditingController email;
  TextEditingController pass;
  TextEditingController phone;
  TextEditingController uName;
  TextEditingController address;
  TextEditingController city;
  TextEditingController state;
  TextEditingController pincode;

  String id;
  final _focusNode = FocusNode();

  final _imagePicker = ImagePicker();
  File _imageFile;
  String photo;

  final roleBloc = AdminRoleBloc();

  String roleId;
  List<String> role = ["Select your role"];
  List<Roles> roleList = [];


  @override
  void initState() {
    checkConnectivity();
    fname = TextEditingController();
    lname = TextEditingController();
    email = TextEditingController();
    pass = TextEditingController();
    phone = TextEditingController();
    uName = TextEditingController();
    address = TextEditingController();
    city = TextEditingController();
    state = TextEditingController();
    pincode = TextEditingController();
    adminBloc.fetchAdminList();
    roleBloc.fetchAdminRoleList();
    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");
    });
    super.initState();
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
  void dispose() {
    fname.dispose();
    lname.dispose();
    email.dispose();
    pass.dispose();
    phone.dispose();
    uName.dispose();
    address.dispose();
    city.dispose();
    state.dispose();
    pincode.dispose();
    _focusNode.dispose();
    adminBloc.dispose();
    roleBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => DashboardPageAdmin()));
      },
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              // leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => SalesHomePage()));
              // },),
              title: Text("Admin Users List", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
              centerTitle: true,
              leading: Builder(
                builder: (c){
                  return IconButton(icon: Image.asset("assets/images/logo.png"), onPressed: (){
                    Scaffold.of(c).openDrawer();
                  },);
                },
              ),
            ),
            drawer: DrawerAdmin(),
            body: _body(),
          )),
    );
  }

  Widget _body(){
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
      child: RefreshIndicator(
        color: kPrimaryColor,
        onRefresh: () {
          return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => AdminUserListPage(adminUserId: widget.adminUserId,)), (route) => false);
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
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
                    leading:  isExpand ? Icon(Icons.remove, color:kPrimaryColor,) : Icon(Icons.add, color: kPrimaryColor,),
                    title: Text('Add New User', style: TextStyle(color: Colors.black45,fontSize: 18, fontWeight: FontWeight.w500),),
                    children: [
                      addNewUser()
                    ],
                  ),
                ),
              ),
              StreamBuilder<UserModel>(
                  stream: adminBloc.adminStream,
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


                    userList = s.data.user;

                    return Column(
                      children: [
                        _searchView(),
                        _searchResult.length == 0 ? ListView.separated(
                          //padding: EdgeInsets.all(10),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          //reverse: true,
                          itemCount: userList.length,
                          itemBuilder: (c,i){
                            userList[i].isActive == "0" ? status.add(false) : status.add(true);
                            return GestureDetector(
                              onTap: (){
                                //s.data.customer[i].kycStatus == "0" ? Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerKYCDetailsPage(customerId: s.data.customer[i].customerId, salesId: widget.salesId,)))  :  Navigator.of(context).push(MaterialPageRoute(builder: (_) => CustomerListPage(salesId: widget.salesId,)));
                              },
                              child: Container(
                                //padding: EdgeInsets.only(top: 10, bottom: 10),
                                margin: EdgeInsets.only(left: 5, right: 5),
                                alignment: Alignment.centerLeft,
                                // decoration: BoxDecoration(
                                //   //color: Color(0xFFF5F6F9),
                                //   borderRadius: BorderRadius.circular(15),
                                // ),
                                child: Row(
                                  children: [
                                    userList[i].userPhoto == "" ? Expanded(
                                      child: SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: AspectRatio(
                                          aspectRatio: 0.88,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF5F6F9),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Icon(Icons.person_outline, color: Colors.black,),
                                          ),
                                        ),
                                      ),
                                    ) :
                                    Expanded(
                                      child: SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: AspectRatio(
                                          aspectRatio: 0.88,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF5F6F9),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Image.network("http://loccon.in/desiremoulding/upload/Image/Admin/${userList[i].userPhoto}"),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Text("Name: ${userList[i].firstname} ${userList[i].lastname}",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),)),
                                          SizedBox(height: 10,),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("Status: ", textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                                                SizedBox(width: 5,),
                                                userList[i].isActive == "0" ? Text("Blocked", textAlign: TextAlign.center, style: TextStyle(color: Colors.redAccent,),) : Text("Active", textAlign: TextAlign.center, style: TextStyle(color: Colors.green),),
                                              ],
                                            ),),
                                          SizedBox(height: 10,),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("Department: ", textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                                                SizedBox(width: 5,),
                                                userList[i].roleId == "1" || userList[i].roleId == "2" ? Text("Admin", textAlign: TextAlign.center) : userList[i].roleId == "3" ? Text("Sales", textAlign: TextAlign.center) : userList[i].roleId == "4" ? Text("Production", textAlign: TextAlign.center) : Text("Warehouse", textAlign: TextAlign.center,),
                                              ],
                                            ),),
                                          SizedBox(height: 10,),
                                          Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Text("Email : ${userList[i].email}", style: TextStyle(color: Colors.black),)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (builder) => SalesmanDetailsPage(salesman: userList[i],)));
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 20,
                                                padding: EdgeInsets.zero,
                                                child: Icon(Icons.preview_outlined,),),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (builder) => SalesEditPage(salesman: userList[i], userId: widget.adminUserId,)));
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 20,
                                                padding: EdgeInsets.zero,
                                                child: Icon(Icons.edit_outlined),),
                                            ),
                                            userList[i].isActive == "0" ?
                                            GestureDetector(
                                              onTap: (){
                                                //updateStatusId("1",salesmanList[i].userId);
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 20,
                                                padding: EdgeInsets.zero,
                                                child: Icon(Icons.block, color: kPrimaryColor,),
                                              ),
                                            ) :
                                            GestureDetector(
                                              onTap: (){
                                                deleteUser(userList[i].userId);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.zero,
                                                height: 30,
                                                width: 20,
                                                child: Icon(Icons.delete, color: Colors.redAccent,),
                                              ),
                                            ),
                                            userList[i].roleId == "3" ? GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (builder) => SalesCustomerListPage(salesId: userList[i].userId)));
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 20,
                                                padding: EdgeInsets.zero,
                                                child: SvgPicture.asset(
                                                  "assets/icons/custList.svg",
                                                  color: kPrimaryColor,
                                                  width: 30,
                                                ),),
                                            ) : Container(),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ),
                            );
                          }, separatorBuilder: (BuildContext context, int index) {
                          return Divider(indent: 20, color: Colors.grey.withOpacity(.8),);
                        },
                        ) : ListView.separated(
                          padding: EdgeInsets.all(10),
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          //reverse: true,
                          itemCount: _searchResult.length,
                          itemBuilder: (c,i){
                            _searchResult[i].isActive == "0" ? status.add(false) : status.add(true);
                            return GestureDetector(
                              onTap: (){
                                //s.data.customer[i].kycStatus == "0" ? Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerKYCDetailsPage(customerId: s.data.customer[i].customerId, salesId: widget.salesId,)))  :  Navigator.of(context).push(MaterialPageRoute(builder: (_) => CustomerListPage(salesId: widget.salesId,)));
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 20, bottom: 10),
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  //color: Color(0xFFF5F6F9),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    _searchResult[i].userPhoto == "" ? SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: AspectRatio(
                                        aspectRatio: 0.88,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF5F6F9),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Icon(Icons.person_outline, color: Colors.black,),
                                        ),
                                      ),
                                    ) : SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: AspectRatio(
                                        aspectRatio: 0.88,
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFF5F6F9),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Image.network("http://loccon.in/desiremoulding/upload/Image/Admin/${_searchResult[i].userPhoto}"),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Text("Name: ${_searchResult[i].firstname} ${_searchResult[i].lastname}",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),)),
                                          SizedBox(height: 10,),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("Status: ", textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                                                SizedBox(width: 5,),
                                                _searchResult[i].isActive == "0" ? Text("Blocked", textAlign: TextAlign.center, style: TextStyle(color: Colors.redAccent,),) : Text("Active", textAlign: TextAlign.center, style: TextStyle(color: Colors.green),),
                                              ],
                                            ),),
                                          SizedBox(height: 10,),
                                          Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Text("Email : ${_searchResult[i].email}",
                                                style: TextStyle(color: Colors.black),)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            IconButton(icon: Icon(Icons.edit_outlined), onPressed: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (builder) => SalesEditPage(salesman: userList[i], userId: widget.adminUserId,)));
                                            }),
                                            IconButton(icon: Icon(Icons.delete, color: Colors.redAccent,), onPressed: (){
                                              deleteUser(_searchResult[i].userId);
                                            }),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            );
                          }, separatorBuilder: (BuildContext context, int index) {
                          return Divider(indent: 20, color: Colors.grey.withOpacity(.8),);
                        },
                        ),
                      ],
                    );
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchView() {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.black,),
          SizedBox(width: 8,),
          Expanded(
            child: TextField(
              controller: searchView,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              onChanged: (value){
                setState(() {
                  search = true;
                  onSearchTextChangedICD(value);
                });
              },
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
              ),
            ),
          ),
        ],
      ),
    );
  }

  onSearchTextChangedICD(String text) async {
    _searchResult.clear();
    print("$text value from search");
    if (text.isEmpty) {
      setState(() {
        search = false;
      });
      return;
    }
    userList.forEach((exp) {
      if (exp.firstname.toLowerCase().contains(text.toLowerCase()) || exp.lastname.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});

  }

  deleteUser(String userId) async{
      ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
        isDismissible: false,);
      pr.style(message: 'Please wait...',
        progressWidget: Center(child: CircularProgressIndicator()),);
      pr.show();
      var response = await http.post(Uri.parse(Connection.deleteAdmin), body: {
        'secretkey': Connection.secretKey,
        'user_id':widget.adminUserId,
        'admin_user_id': userId,
      });
      var results = json.decode(response.body);
      print('response == $results  ${response.body}');
      pr.hide();
      if (results['status'] == true) {
        final snackBar = SnackBar(content: Text('Admin Profile Deleted Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AdminUserListPage(adminUserId: widget.adminUserId,)), (Route<dynamic> route) => false);
      } else {
        print('error in updating profile');
        Alerts.showAlertAndBack(context, 'Error', 'Sales Profile not Updated. Please try again later');
      }

  }

  Widget addNewUser(){
    return StreamBuilder<RoleModel>(
      stream: roleBloc.adminRoleStream,
      builder: (c, s) {

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

        roleList = s.data.data;

        for(int i = 0; i<s.data.data.length; i++){
          role.add(s.data.data[i].roleName);
        }

        return Form(
          autovalidateMode: _autovalidateMode,
          key: _formkey,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              'First Name',
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
                            controller: fname,
                            decoration: const InputDecoration(
                              hintText: "Enter Your First Name",
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
                              'Last Name',
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
                            controller: lname,
                            decoration: const InputDecoration(
                              hintText: "Enter Your Last Name",
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
                            //readOnly: true,
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
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                          child: new TextFormField(
                            readOnly: true,
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
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                  child: DropdownSearch<String>(
                    validator: (v) => v == null ? "required field" : null,
                    mode: Mode.MENU,
                    dropdownSearchDecoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 30, right: 20, top: 5, bottom: 5),
                      alignLabelWithHint: true,
                      hintText: "Please Select Customer",
                      hintStyle: TextStyle(color: Colors.black45),
                      focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                    ),
                    showSelectedItem: true,
                    items: role,
                    onChanged: (value){
                      print("customer selected: $value");
                      for(int i =0; i<roleList.length; i++){
                        if(roleList[i].roleName == value){
                          setState(() {
                            roleId = roleList[i].roleId.toString();
                          });
                        }
                      }
                      print("object customer id $roleId");
                    },
                    //selectedItem: "Please Select your Area",
                  ),
                ),
                _imageFile == null ? Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                  child: Icon(Icons.person_outline, color: Colors.black, size: 150,),
                ): Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                    child: Image.file(_imageFile, height: 150, width: 150,)),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: TextButton(
                      onPressed: () {
                        futureShowChoiceDialog();
                      },
                      child: Text("Upload Image"),),
                  ),
                ),
                Center(
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 10),
                      child: DefaultButton(
                        text: "Add New Users",
                        press: (){

                        },
                      )
                  ),
                ),
              ],
            ),
          ),
        );
      }
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

  futureShowChoiceDialog() {
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.blue),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _uploadGallery();

                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _uploadCamera();
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
            ],
          ),
        ),);
    });
  }

  _uploadGallery() async {

    final _pickedPic = await _imagePicker.pickImage(source: ImageSource.gallery);

    _imageFile = File(_pickedPic.path);

  }

  _uploadCamera() async {

    final _pickedPic = await _imagePicker.pickImage(source: ImageSource.camera);

    _imageFile = File(_pickedPic.path);

  }

  Future<String> addUser(File photo) async {

    //print("object inside upload ${photo.path}");

    var request = http.MultipartRequest("POST", Uri.parse(Connection.addAdminUser));

    request.fields['secretkey'] = '${Connection.secretKey}';
    request.fields['user_role'] = '$roleId';
    request.fields['firstname'] = '${fname.text}';
    request.fields['lastname'] = '${lname.text}';
    request.fields['email'] = '${email.text}';
    request.fields['username'] = '${uName.text}';
    request.fields['password'] = '${pass.text}';
    request.fields['mobile_no'] = '${phone.text}';
    request.fields['pincode'] = '${pincode.text}';
    request.fields['state'] = '${state.text}';
    request.fields['city'] = '${city.text}';
    request.fields['address'] = '${address.text}';
    request.fields['user_id'] = '2';

    request.files.add(await http.MultipartFile.fromPath('image', photo.path, filename: 'DisplayPicture${uName.text}.jpg', contentType: MediaType('image', 'jpeg')));

    final streamResponse = await request.send();

    print("object ${streamResponse.statusCode}");
    print("object response ${streamResponse.statusCode} ${streamResponse.request}");

    if (streamResponse.statusCode >= 200 && streamResponse.statusCode <= 299) {
      final http.Response response = await http.Response.fromStream(streamResponse);
      final results = json.decode(response.body);
      if (results['data'] != null) {
        print("object ${results['data']}");
        return "success";
      } else {
        return null;
      }
    } else {
      return "false";
    }
  }

}
