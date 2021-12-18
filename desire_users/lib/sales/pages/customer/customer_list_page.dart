import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/sales/bloc/customer_bloc.dart';
import 'package:desire_users/sales/pages/customer/customer_edit_page.dart';
import 'package:desire_users/sales/pages/orders/customerOrderHistoryPage.dart';
import 'package:desire_users/sales/pages/products/customer_price_list_page.dart';
import 'package:desire_users/sales/pages/products/customer_pricing_page_copy.dart';
import 'package:desire_users/sales/pages/products/product_home_page.dart';
import 'package:desire_users/sales/utils_sales/my_drawer.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:desire_users/models/sales_customer_list_model.dart';
import 'package:desire_users/sales/pages/customer/customer_kyc_details_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/services/connection_sales.dart';
import 'package:flutter/material.dart';

import '../sales_home_page.dart';
import 'customer_detail_page.dart';

class CustomerListPage extends StatefulWidget {
  final String salesId;
  final String customerId;
  final String name;
  final String email;
  const CustomerListPage({
    @required this.customerId,
    @required this.salesId,
    @required this.name,
    @required this.email,
  });

  @override
  _CustomerListPageState createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  final customerBloc = CustomerListBloc();
  List<UserModel> customerList = [];
  List<bool> status = [];
  TextEditingController searchView;
  bool search = false;
  List<UserModel> _searchResult = [];


  @override
  void initState() {
    super.initState();
    checkConnectivity();
    searchView = TextEditingController();
    print("object sales id ${widget.salesId}");
   customerBloc.fetchCustomerList(widget.salesId);
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
    super.dispose();
    searchView.dispose();
    customerBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => SalesHomePage(
          salesManId: widget.salesId.toString(),
        )), (route) => false);
      },
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(

          backgroundColor: kWhiteColor,
          iconTheme: IconThemeData(
            color: kBlackColor
          ),
          elevation: 0.0,
          title: Text(
            "All Customers",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,

          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              child: _searchView(),
            ),
          ),
        ),
        body: allCustomersListView(),
      )),
    );
  }


  Widget allCustomersListView(){
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () {
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) => CustomerListPage(
                  salesId: widget.salesId,
                  name: widget.name,
                  email: widget.email,
                  customerId: widget.customerId,
                )),
                );
      },
      child:  StreamBuilder<SalesCustomerModel>(
        stream: customerBloc.newCustomerStream,
        builder: (c,s){
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
          customerList = s.data.customer;
          return ListView(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
             _searchResult.length != 0 ?
             ListView.builder(
                shrinkWrap: true,
                  itemCount: _searchResult.length,
                  itemBuilder: (c,i){
                    _searchResult[i].isActive == "0"
                        ? status.add(false)
                        : status.add(true);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: kWhiteColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow:[ BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5
                            )]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0,top: 10,bottom: 10,right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${_searchResult[i].customerName}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: kPrimaryColor,
                                        fontSize: 16,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                  _searchResult[i].isActive == "0"
                                      ? Text("Blocked", textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.redAccent,fontSize: 16,),)
                                      : Text("Active", textAlign: TextAlign.left,
                                    style: TextStyle(color: Colors.green,fontSize: 16,),),

                                  GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      height: 30,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 4.0,right: 4,),
                                          child: Text(
                                            "Buy Product",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: kWhiteColor),),
                                        ),
                                      ),
                                    ),
                                    onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  ProductHomePage(
                                                    customerId: _searchResult[i].customerId,
                                                    customerName: _searchResult[i].customerName,

                                                  )));
                                    },
                                  ),


                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _searchResult[i].kycStatus == "0"
                                      ? Text("Documents not Uploaded",  textAlign: TextAlign.left,style: TextStyle(fontSize: 12,color: Colors.black),
                                  )
                                      : Text("Documents Uploaded", textAlign: TextAlign.left, style: TextStyle(fontSize: 12,color: Colors.black),
                                  ),
                                  _searchResult[i].kycStatus == "2" ? _searchResult[i].kycApprove == "0"
                                      ? Text(
                                    "KYC Pending", style: TextStyle(color: Colors.orange,fontSize: 12),
                                  )
                                      : _searchResult[i].kycApprove == "1"
                                      ? Text(
                                    "KYC Approved", textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 12,
                                        color: Colors
                                            .green),
                                  )
                                      : Text(
                                    "KYC Rejected", textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 12,
                                        color: Colors
                                            .redAccent),
                                  )
                                      : Text(
                                    "KYC Pending", textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 12,
                                        color: Colors.orange),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  CustomerDetailsPage(
                                                    salesId:
                                                    widget.salesId,
                                                    name: widget.name,
                                                    email: widget.email,
                                                    customer:
                                                    _searchResult[i],
                                                  )));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      height: 30,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 4.0,right: 4,),
                                          child: Text(
                                            "View Details",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: kWhiteColor),),
                                        ),
                                      ),
                                    ),
                                  ),



                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0,bottom: 10),
                                child: Divider(color: Colors.grey,height: 0.0,thickness: 1,),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  CustomerPricingPage(
                                                    customerId:" ${_searchResult[i].customerId}",
                                                    customerName: "${_searchResult[i].customerName}",
                                                    salesId:   widget.salesId,

                                                  )
                                          )
                                      );
                                    },
                                    child: Image.asset("assets/images/rupees.png",height: 25,width: 25,),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  CustomerEditPage(
                                                    salesId:
                                                    widget.salesId,
                                                    name: widget.name,
                                                    email: widget.email,
                                                    customer:
                                                    _searchResult[i],
                                                  )));
                                    },
                                    child: Icon(Icons.edit_outlined),
                                  ),
                                  _searchResult[i].isActive == "0"
                                      ? GestureDetector(
                                    onTap: () {
                                      updateStatusId(
                                          "1",
                                          _searchResult[i]
                                              .customerId);
                                    },
                                    child: Icon(
                                      Icons.block,
                                      color: Colors.red,
                                    ),
                                  )
                                      : GestureDetector(
                                    onTap: () {
                                      updateStatusId(
                                          "0",
                                          _searchResult[i]
                                              .customerId);
                                    },
                                    child: Icon(
                                      Icons.block,
                                      color: Colors.green,
                                    ),
                                  ),
                                  _searchResult[i].kycStatus == "2" && _searchResult[i].kycApprove == "0"
                                      ? GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  CustomerKYCDetailsPage(
                                                    customerId:
                                                    _searchResult[
                                                    i]
                                                        .customerId,
                                                    salesId: widget
                                                        .salesId,
                                                    name: widget
                                                        .name,
                                                    email: widget
                                                        .email,
                                                  )));
                                    },
                                    child: Icon(
                                      Icons
                                          .check_circle_outline,
                                      color: Colors.red,
                                    ),
                                  )
                                      : Icon(
                                    Icons
                                        .check_circle_outline,
                                    color: Colors.green,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  CustomerOrderHistoryPage(
                                                    customerName: _searchResult[i].customerName,
                                                    customerId: _searchResult[i].customerId,
                                                  )
                                          )
                                      );
                                    },
                                    child: Image.asset(
                                      "assets/images/production_order.png",height: 30,width: 30,),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );

              })
                 :ListView.builder(
                 physics: BouncingScrollPhysics(),
                 shrinkWrap: true,
                 itemCount: customerList.length,
                 itemBuilder: (c,i){
                   customerList[i].isActive == "0"
                       ? status.add(false)
                       : status.add(true);
                   return Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Container(
                       decoration: BoxDecoration(
                           color: kWhiteColor,
                           borderRadius: BorderRadius.circular(10),
                           boxShadow:[ BoxShadow(
                               color: Colors.grey,
                               blurRadius: 5
                           )]
                       ),
                       child: Padding(
                         padding: const EdgeInsets.only(left: 10.0,top: 10,bottom: 10,right: 10),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   "${customerList[i].customerName}",
                                   textAlign: TextAlign.left,
                                   style: TextStyle(
                                       color: kPrimaryColor,
                                       fontSize: 16,
                                       fontWeight:
                                       FontWeight.bold),
                                 ),
                                 customerList[i].isActive == "0"
                                     ? Text("Blocked", textAlign: TextAlign.left,
                                   style: TextStyle(color: Colors.redAccent,fontSize: 16,),)
                                     : Text("Active", textAlign: TextAlign.left,
                                   style: TextStyle(color: Colors.green,fontSize: 16,),),

                                 GestureDetector(
                                   child: Container(
                                     decoration: BoxDecoration(
                                         color: kPrimaryColor,
                                         borderRadius: BorderRadius.circular(10)
                                     ),
                                     height: 30,
                                     child: Center(
                                       child: Padding(
                                         padding: const EdgeInsets.only(left: 4.0,right: 4,),
                                         child: Text(
                                           "Buy Product",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: kWhiteColor),),
                                       ),
                                     ),
                                   ),
                                   onTap: (){
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                             builder: (builder) =>
                                                 ProductHomePage(
                                                   customerId: customerList[i].customerId,
                                                   customerName: customerList[i].customerName,
                                                 )));
                                   },
                                 ),


                               ],
                             ),
                             SizedBox(height: 10,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 customerList[i].kycStatus == "0"
                                     ? Text("Documents not Uploaded",  textAlign: TextAlign.left,style: TextStyle(fontSize: 12,color: Colors.black),
                                 )
                                     : Text("Documents Uploaded", textAlign: TextAlign.left, style: TextStyle(fontSize: 12,color: Colors.black),
                                 ),
                                 customerList[i].kycStatus == "2" ? customerList[i].kycApprove == "0"
                                     ? Text(
                                   "KYC Pending", style: TextStyle(color: Colors.orange,fontSize: 12),
                                 )
                                     : customerList[i].kycApprove == "1"
                                     ? Text(
                                   "KYC Approved", textAlign: TextAlign.left,
                                   style: TextStyle(fontSize: 12,
                                       color: Colors
                                           .green),
                                 )
                                     : Text(
                                   "KYC Rejected", textAlign: TextAlign.left,
                                   style: TextStyle(fontSize: 12,
                                       color: Colors
                                           .redAccent),
                                 )
                                     : Text(
                                   "KYC Pending", textAlign: TextAlign.left,
                                   style: TextStyle(fontSize: 12,
                                       color: Colors.orange),
                                 ),
                                 GestureDetector(
                                   onTap: () {
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                             builder: (builder) =>
                                                 CustomerDetailsPage(
                                                   salesId:
                                                   widget.salesId,
                                                   name: widget.name,
                                                   email: widget.email,
                                                   customer:
                                                   customerList[i],
                                                 )));
                                   },
                                   child: Container(
                                     decoration: BoxDecoration(
                                         color: kPrimaryColor,
                                         borderRadius: BorderRadius.circular(10)
                                     ),
                                     height: 30,
                                     child: Center(
                                       child: Padding(
                                         padding: const EdgeInsets.only(left: 4.0,right: 4,),
                                         child: Text(
                                           "View Details",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: kWhiteColor,),
                                       ),
                                     ),
                                   ),
                                 ),



                                 )],
                             ),
                             Padding(
                               padding: const EdgeInsets.only(top: 10.0,bottom: 10),
                               child: Divider(color: Colors.grey,height: 0.0,thickness: 1,),
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 GestureDetector(
                                   onTap: () {
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                             builder: (builder) =>
                                                 CustomerPricingPage(
                                                   customerId:" ${customerList[i].customerId}",
                                                   customerName: "${customerList[i].customerName}",
                                                   salesId: widget.salesId,

                                                 )
                                         )
                                     );
                                   },
                                   child: Image.asset("assets/images/rupees.png",height: 25,width: 25,),
                                 ),
                                 GestureDetector(
                                   onTap: () {
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                             builder: (builder) =>
                                                 CustomerEditPage(
                                                   salesId:
                                                   widget.salesId,
                                                   name: widget.name,
                                                   email: widget.email,
                                                   customer:
                                                   customerList[i],
                                                 )));
                                   },
                                   child: Icon(Icons.edit_outlined),
                                 ),
                                 customerList[i].isActive == "0"
                                     ? GestureDetector(
                                   onTap: () {
                                     updateStatusId(
                                         "1",
                                         customerList[i]
                                             .customerId);
                                   },
                                   child: Icon(
                                     Icons.block,
                                     color: Colors.red,
                                   ),
                                 )
                                     : GestureDetector(
                                   onTap: () {
                                     updateStatusId(
                                         "0",
                                         customerList[i]
                                             .customerId);
                                   },
                                   child: Icon(
                                     Icons.block,
                                     color: Colors.green,
                                   ),
                                 ),
                                 customerList[i].kycStatus == "2" && customerList[i].kycApprove == "1"
                                     ? GestureDetector(
                                   onTap: () {
                                     final snackBar = SnackBar(content: Text('KYC Approved'));
                                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                   },
                                   child: Icon(
                                     Icons
                                         .check_circle_outline,
                                     color: Colors.green,
                                   ),
                                 )
                                     : GestureDetector(
                                   onTap: (){
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                             builder: (builder) =>
                                                 CustomerKYCDetailsPage(
                                                   customerId:
                                                   customerList[
                                                   i]
                                                       .customerId,
                                                   salesId: widget
                                                       .salesId,
                                                   name: widget
                                                       .name,
                                                   email: widget
                                                       .email,
                                                 )));

                                   },
                                   child: Icon(
                                     Icons
                                         .check_circle_outline,
                                     color: Colors.red,
                                   ),
                                 ),
                                 GestureDetector(
                                   onTap: () {
                                     Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                             builder: (builder) =>
                                                 CustomerOrderHistoryPage(
                                                   customerName: customerList[i].customerName,
                                                   customerId: customerList[i].customerId,
                                                 )));
                                   },
                                   child: Image.asset(
                                       "assets/images/production_order.png",height: 30,width: 30,),
                                 ),
                               ],
                             )
                           ],
                         ),
                       ),
                     ),
                   );

                 })
            ],

          );

        },
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
          Icon(
            Icons.search,
            color: Colors.black,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              cursorColor: kBlackColor,
              controller: searchView,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              onChanged: (value) {
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

    customerList.forEach((exp) {
      if (exp.customerName.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }

  updateStatusId(String status, String customerId) async {
    // String value;
    // status ? value = "1" : value = "0";
    print("object request value $status $customerId");
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
        await http.post(Uri.parse(ConnectionSales.blockCustomer), body: {
      'secretkey': ConnectionSales.secretKey,
      'customer_id': '$customerId',
      "status": status,
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true) {
      final snackBar = SnackBar(
          content: Text(
        "Status Updated",
        textAlign: TextAlign.center,
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => CustomerListPage(
                    salesId: widget.salesId,
                    name: widget.name,
                    email: widget.email,
                  customerId: widget.customerId,
                  )),
          (Route<dynamic> route) => false);
    } else {
      print('error deleting address');
      Alerts.showAlertAndBack(context, 'Error', 'Address not Deleted.');
    }
  }
}
