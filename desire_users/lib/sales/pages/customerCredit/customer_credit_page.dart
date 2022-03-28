import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/models/credit_list_model.dart';
import 'package:desire_users/pages/intro/kyc_pagen.dart';
import 'package:desire_users/sales/bloc/credit_list_bloc.dart';
import 'package:desire_users/sales/pages/customerCredit/add_credits_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/my_drawer.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';

import '../sales_home_page.dart';


class CustomerCreditPage extends StatefulWidget {

  final String salesId;
  final String name;
  final String email;

  const CustomerCreditPage({@required this.salesId, @required this.name, @required this.email});

  @override
  _CustomerCreditPageState createState() => _CustomerCreditPageState();
}

class _CustomerCreditPageState extends State<CustomerCreditPage> {

  final customerBloc = CustomerCreditListBloc();
  TextEditingController searchView;
  bool search = false;
  List<CreditList> _searchResult = [];
  List<CreditList> customer = [];

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    searchView = TextEditingController();
    print("object sales id ${widget.salesId}");
    customerBloc.fetchCustomerCredit();
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
    super.dispose();
    searchView.dispose();
    customerBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Text("Customer Credit List", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: _searchView(),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: kPrimaryColor,
            icon:   Icon(Icons.add,color: kWhiteColor,),
            label:  Text("Add Credits"),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (builder) => AddCreditsPage(salesId: widget.salesId, name: widget.name, email: widget.email,)));
            },

          ),
          drawer: MyDrawer(name: widget.name, email: widget.email, salesId: widget.salesId,),
          body: _body(),
        ));
  }

  Widget _body(){
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 10),
      child: StreamBuilder<CreditListModel>(
        stream: customerBloc.newCustomerCreditListStream,
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
          if (s.data.creditList.isEmpty) {
            print("as3 empty");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("No Customers Found",),);
          }

          customer = s.data.creditList;
          return RefreshIndicator(
            color: kPrimaryColor,
            onRefresh: () {
              return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerCreditPage(salesId: widget.salesId, name: widget.name, email: widget.email, )), (route) => false);
            },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  _searchResult.length == 0 ? ListView.separated(
                    padding: EdgeInsets.all(10),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    //reverse: true,
                    itemCount: s.data.creditList.length,
                    itemBuilder: (c,i){
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
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: AspectRatio(
                                  aspectRatio: 0.88,
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF5F6F9),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: kPrimaryColor)
                                    ),
                                    child: Icon(Icons.person_outline, color: Colors.black,size: 40,),
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
                                        child: Text("Name: ${s.data.creditList[i].customerName}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),)),
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Credit Amount: ", textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                                          SizedBox(width: 5,),
                                          Text("${s.data.creditList[i].creditLimit}", textAlign: TextAlign.center, style: TextStyle(color:kPrimaryColor),),
                                        ],
                                      ),),
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Credit Days: ", textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                                          SizedBox(width: 5,),
                                          Text("${s.data.creditList[i].creditDays}", textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor),),
                                        ],
                                      ),),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return Divider(indent: 20, color: Colors.grey.withOpacity(.8),);
                  },
                  ) :
                  ListView.separated(
                    padding: EdgeInsets.all(10),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    //reverse: true,
                    itemCount: _searchResult.length,
                    itemBuilder: (c,i){
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
                              SizedBox(
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
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child: Text("Name: ${_searchResult[i].customerName}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: kBlackColor
                                              , fontSize: 16, fontWeight: FontWeight.bold),)),
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Credit Amount: ", textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                                          SizedBox(width: 5,),
                                          Text("${_searchResult[i].creditLimit}", textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor),),
                                        ],
                                      ),),
                                    SizedBox(height: 10,),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("Credit Days: ", textAlign: TextAlign.center, style: TextStyle(color: Colors.black),),
                                          SizedBox(width: 5,),
                                          Text("${_searchResult[i].creditDays}", textAlign: TextAlign.center, style: TextStyle(color: kPrimaryColor),),
                                        ],
                                      ),),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, separatorBuilder: (BuildContext context, int index) {
                    return Divider(indent: 20, color: Colors.grey.withOpacity(.8),);
                  },
                  ),
                ],
              ),
            ),
          );
        },

      ),
    );
  }


  Widget _searchView() {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
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

    customer.forEach((exp) {
      if (exp.customerName.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }

  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  Widget clipShape() {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large? _height/8 : (_medium? _height/7 : _height/6.5),
              decoration: BoxDecoration(
                gradient: kPrimaryGradientColor,
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large? _height/12 : (_medium? _height/11 : _height/10),
              decoration: BoxDecoration(
                gradient: kPrimaryGradientColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
