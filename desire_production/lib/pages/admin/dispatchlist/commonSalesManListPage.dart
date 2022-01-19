import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/salesman_list_bloc.dart';
import 'package:desire_production/model/user_model.dart';
import 'package:desire_production/pages/admin/dispatchlist/CustomerInvoiceListPage.dart';
import 'package:desire_production/pages/admin/dispatchlist/hold_order_list_page.dart';
import 'package:desire_production/pages/admin/sales/sales_customer_list_page.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'PendingOrderListPage.dart';

class CommonSalesManListPage extends StatefulWidget {
  final type;

  const CommonSalesManListPage({Key key, this.type}) : super(key: key);

  @override
  _CommonSalesManListPageState createState() => _CommonSalesManListPageState();
}

class _CommonSalesManListPageState extends State<CommonSalesManListPage> {
  final customerBloc = SalesmanListBloc();
  List<bool> status = [];
  TextEditingController searchView;
  bool search = false;
  List<User> _searchResult = [];
  List<User> salesmanList = [];

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    searchView = TextEditingController();
    customerBloc.fetchSalesmanList();
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Salesman List",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: _searchView(),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () {
        return Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (builder) => CommonSalesManListPage()));
      },
      child: StreamBuilder<UserModel>(
          stream: customerBloc.salesmanStream,
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

            salesmanList = s.data.user;

            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                child: Column(
                  children: [
                    _searchResult.length == 0
                        ? ListView.separated(
                            //padding: EdgeInsets.all(10),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            //reverse: true,
                            itemCount: salesmanList.length,
                            itemBuilder: (c, i) {
                              salesmanList[i].isActive == "0"
                                  ? status.add(false)
                                  : status.add(true);
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) => widget.type ==
                                                  "invoice"
                                              ? CustomerInvoiceListPage(
                                                  salesId:
                                                      salesmanList[i].userId,
                                                )
                                              : widget.type == "pending"
                                                  ? PendingOrderListPage(
                                                      salesId: salesmanList[i]
                                                          .userId)
                                                  : HoldOrderListPage(
                                                      salesId: salesmanList[i]
                                                          .userId)));
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
                                      SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: AspectRatio(
                                          aspectRatio: 0.88,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFF5F6F9),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Icon(
                                              Icons.person_outline,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  "Name: ${salesmanList[i].firstname} ${salesmanList[i].lastname}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Status: ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  salesmanList[i].isActive ==
                                                          "0"
                                                      ? Text(
                                                          "Blocked",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                        )
                                                      : Text(
                                                          "Active",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  "Email : ${salesmanList[i].email}",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                          ],
                                        ),
                                      ),
                                      // Expanded(
                                      //     child: Column(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.start,
                                      //   crossAxisAlignment:
                                      //       CrossAxisAlignment.start,
                                      //   children: [
                                      //     GestureDetector(
                                      //       onTap: () {
                                      //         Navigator.push(
                                      //             context,
                                      //             MaterialPageRoute(
                                      //                 builder: (builder) =>
                                      //                     SalesmanDetailsPage(
                                      //                       salesman:
                                      //                           salesmanList[i],
                                      //                     )));
                                      //       },
                                      //       child: Container(
                                      //         height: 30,
                                      //         width: 20,
                                      //         padding: EdgeInsets.zero,
                                      //         child: Icon(
                                      //           Icons.preview_outlined,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     GestureDetector(
                                      //       onTap: () {
                                      //         Navigator.push(
                                      //             context,
                                      //             MaterialPageRoute(
                                      //                 builder: (builder) =>
                                      //                     SalesEditPage(
                                      //                       salesman:
                                      //                           salesmanList[i],
                                      //                       userId: '2',
                                      //                     )));
                                      //       },
                                      //       child: Container(
                                      //         height: 30,
                                      //         width: 20,
                                      //         padding: EdgeInsets.zero,
                                      //         child: Icon(Icons.edit_outlined),
                                      //       ),
                                      //     ),
                                      //     salesmanList[i].isActive == "0"
                                      //         ? GestureDetector(
                                      //             onTap: () {
                                      //               //updateStatusId("1",salesmanList[i].userId);
                                      //             },
                                      //             child: Container(
                                      //               height: 30,
                                      //               width: 20,
                                      //               padding: EdgeInsets.zero,
                                      //               child: Icon(
                                      //                 Icons.block,
                                      //                 color: kPrimaryColor,
                                      //               ),
                                      //             ),
                                      //           )
                                      //         : GestureDetector(
                                      //             onTap: () {
                                      //               //updateStatusId("0",salesmanList[i].userId);
                                      //             },
                                      //             child: Container(
                                      //               padding: EdgeInsets.zero,
                                      //               height: 30,
                                      //               width: 20,
                                      //               child: Icon(
                                      //                 Icons.block,
                                      //                 color: Colors.blue,
                                      //               ),
                                      //             ),
                                      //           ),
                                      //     GestureDetector(
                                      //       onTap: () {
                                      //         Navigator.push(
                                      //             context,
                                      //             MaterialPageRoute(
                                      //                 builder: (builder) =>
                                      //                     SalesCustomerListPage(
                                      //                         salesId:
                                      //                             salesmanList[
                                      //                                     i]
                                      //                                 .userId)));
                                      //       },
                                      //       child: Container(
                                      //         height: 30,
                                      //         width: 20,
                                      //         padding: EdgeInsets.zero,
                                      //         child: SvgPicture.asset(
                                      //           "assets/icons/custList.svg",
                                      //           color: kPrimaryColor,
                                      //           width: 30,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ))
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                indent: 20,
                                color: Colors.grey.withOpacity(.8),
                              );
                            },
                          )
                        : ListView.separated(
                            padding: EdgeInsets.all(10),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            //reverse: true,
                            itemCount: _searchResult.length,
                            itemBuilder: (c, i) {
                              _searchResult[i].isActive == "0"
                                  ? status.add(false)
                                  : status.add(true);
                              return GestureDetector(
                                onTap: () {},
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
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: Icon(
                                              Icons.person_outline,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  "Name: ${_searchResult[i].firstname} ${_searchResult[i].lastname}",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "Status: ",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  _searchResult[i].isActive ==
                                                          "0"
                                                      ? Text(
                                                          "Blocked",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors
                                                                .redAccent,
                                                          ),
                                                        )
                                                      : Text(
                                                          "Active",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green),
                                                        ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  "Email : ${_searchResult[i].email}",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                          ],
                                        ),
                                      ),
                                      // Expanded(
                                      //     flex: 1,
                                      //     child: Column(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.start,
                                      //       children: [
                                      //         IconButton(
                                      //             icon:
                                      //                 Icon(Icons.edit_outlined),
                                      //             onPressed: () {
                                      //               Navigator.push(
                                      //                   context,
                                      //                   MaterialPageRoute(
                                      //                       builder: (builder) =>
                                      //                           SalesEditPage(
                                      //                             salesman:
                                      //                                 salesmanList[
                                      //                                     i],
                                      //                             userId: '2',
                                      //                           )));
                                      //             }),
                                      //         _searchResult[i].isActive == "0"
                                      //             ? IconButton(
                                      //                 icon: Icon(
                                      //                   Icons.block,
                                      //                   color: kPrimaryColor,
                                      //                 ),
                                      //                 onPressed: () {
                                      //                   //updateStatusId("1",_searchResult[i].userId);
                                      //                 })
                                      //             : IconButton(
                                      //                 icon: Icon(
                                      //                   Icons.block,
                                      //                   color: Colors.blue,
                                      //                 ),
                                      //                 onPressed: () {
                                      //                   //updateStatusId("0",_searchResult[i].userId);
                                      //                 }),
                                      //         GestureDetector(
                                      //           onTap: () {
                                      //             Navigator.push(
                                      //                 context,
                                      //                 MaterialPageRoute(
                                      //                     builder: (builder) =>
                                      //                         SalesCustomerListPage(
                                      //                             salesId:
                                      //                                 salesmanList[
                                      //                                         i]
                                      //                                     .userId)));
                                      //           },
                                      //           child: Container(
                                      //             height: 30,
                                      //             width: 20,
                                      //             padding: EdgeInsets.zero,
                                      //             child: SvgPicture.asset(
                                      //               "assets/icons/custList.svg",
                                      //               color: kPrimaryColor,
                                      //               width: 30,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     )),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider(
                                indent: 20,
                                color: Colors.grey.withOpacity(.8),
                              );
                            },
                          ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _searchView() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(border: Border.all(color: kSecondaryColor)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: TextFormField(
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
              hintText: "Search Customers",
            ),
          ),
        ),
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

    salesmanList.forEach((exp) {
      if (exp.firstname.toLowerCase().contains(text.toLowerCase()) ||
          exp.lastname.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }
}
