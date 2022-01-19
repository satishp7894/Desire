import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/complete_order_bloc.dart';
import 'package:desire_users/bloc/hold_order_bloc.dart';
import 'package:desire_users/bloc/pending_order_list_bloc.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/models/complete_order_list_model.dart';
import 'package:desire_users/models/pending_order_list_model.dart';
import 'package:desire_users/pages/home/customer_price_list.dart';
import 'package:desire_users/sales/pages/orders/orderDetailsByIdPage.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CompleteOrderList extends StatefulWidget {
  final customerId;

  const CompleteOrderList({Key key, this.customerId}) : super(key: key);

  @override
  _CompleteOrderListState createState() => _CompleteOrderListState();
}

class _CompleteOrderListState extends State<CompleteOrderList> {
  CompleteOrderBloc completeOrderBloc = CompleteOrderBloc();
  AsyncSnapshot<CompleteOrderListModel> asyncSnapshot;
  DateTime selectedDate = DateTime.now();
  TextEditingController dateinput = TextEditingController();
  List<CompleteOrder> filterDate = [];
  var toDate;
  var fromDate;
  TextEditingController fromDateinput = TextEditingController();
  TextEditingController toDateinput = TextEditingController();
  bool isVisible = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print("Date " + selectedDate.toString());
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();

    completeOrderBloc.fetchCompleteOrder(widget.customerId);
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
    // TODO: implement dispose
    super.dispose();
    completeOrderBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          iconTheme: IconThemeData(color: kBlackColor),
          title: Text("Completed Orders"),
          titleTextStyle: TextStyle(
              color: kBlackColor, fontSize: 18, fontWeight: FontWeight.bold),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (isVisible) {
                      isVisible = false;
                    } else {
                      isVisible = true;
                    }
                  });
                },
                icon: Icon(
                  Icons.filter_list,
                  size: 30,
                  color: kPrimaryColor,
                ))
          ],
        ),
        body: RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: () {
            return Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (builder) =>
                        CompleteOrderList(customerId: widget.customerId)));
          },
          child: _body(),
        ));
  }

  Widget _body() {
    return StreamBuilder<CompleteOrderListModel>(
        stream: completeOrderBloc.completeOrderStream,
        builder: (c, s) {
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
          } else if (s.hasError) {
            print("as3 error");
            print(s.error);
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: SelectableText(
                "Error Loading Data ${s.error}",
              ),
            );
          } else if (s.data.toString().isEmpty) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          } else {
            asyncSnapshot = s;
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  AnimatedSize(
                      duration: Duration(milliseconds: 1000),
                      child: Container(
                          height: !isVisible ? 0.0 :null,
                          child: Visibility(
                              visible: isVisible,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width /
                                              2,
                                          margin: const EdgeInsets.only(top: 5),
                                          padding: const EdgeInsets.all(10.0),
                                          child: TextField(
                                            controller: fromDateinput,
                                            //editing controller of this TextField
                                            decoration: InputDecoration(
                                                prefixIcon:
                                                Icon(Icons.date_range),
                                                hintText: "Enter Start Date",
                                                hintStyle: TextStyle(
                                                    color: kSecondaryColor,
                                                    fontSize: 12),
                                                labelText: "Start Date",
                                                labelStyle: TextStyle(
                                                    color: kPrimaryColor),
                                                floatingLabelBehavior:
                                                FloatingLabelBehavior
                                                    .always,
                                                focusedBorder:
                                                OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                        kPrimaryColor)),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: kPrimaryColor))),
                                            readOnly: true,
                                            //set it true, so that user will not able to edit text
                                            onTap: () async {
                                              DateTime pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate:
                                                  DateTime.now(),
                                                  firstDate: DateTime(2000),
                                                  //DateTime.now() - not to allow to choose before today.
                                                  lastDate: DateTime(2101));

                                              if (pickedDate != null) {
                                                print(
                                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

                                                setState(() {
                                                  fromDate = pickedDate;
                                                  fromDateinput.text =
                                                      DateFormat('yyyy-MM-dd')
                                                          .format(pickedDate);
                                                  //set output date to TextField value.
                                                });
                                              } else {
                                                print("Date is not selected");
                                              }
                                            },
                                          )),
                                      Container(
                                        width:
                                        MediaQuery.of(context).size.width /
                                            2,
                                        margin: const EdgeInsets.only(top: 5),
                                        padding: EdgeInsets.all(10),
                                        child: TextField(
                                          controller: toDateinput,
                                          //editing controller of this TextField
                                          decoration: InputDecoration(
                                              prefixIcon:
                                              Icon(Icons.date_range),
                                              hintText: "Enter End Date",
                                              hintStyle: TextStyle(
                                                  color: kSecondaryColor,
                                                  fontSize: 12),
                                              labelText: "End Date",
                                              labelStyle: TextStyle(
                                                  color: kPrimaryColor),
                                              floatingLabelBehavior:
                                              FloatingLabelBehavior.always,
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimaryColor)),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: kPrimaryColor))),
                                          readOnly: true,
                                          //set it true, so that user will not able to edit text
                                          onTap: () async {
                                            DateTime pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101));

                                            if (pickedDate != null) {
                                              print(
                                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

                                              setState(() {
                                                toDate = pickedDate;
                                                toDateinput.text = DateFormat(
                                                    'yyyy-MM-dd')
                                                    .format(
                                                    pickedDate); //set output date to TextField value.
                                              });
                                            } else {
                                              print("Date is not selected");
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: kPrimaryColor,
                                            textStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              filterList();
                                            });
                                          },
                                          child: const Text('Filter',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor: kPrimaryColor,
                                            textStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              fromDateinput.clear();
                                              toDateinput.clear();
                                              filterDate.clear();
                                              fromDate = null;
                                              toDate = null;
                                            });
                                          },
                                          child: const Text(
                                            'Clear Filter',
                                            style:
                                            TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )))),
                  ...List.generate(
                      asyncSnapshot.data.completeOrder.length,
                      (index) => ModelListTile(
                            completeOrder:
                                asyncSnapshot.data.completeOrder[index],
                            customerId: widget.customerId,
                          ))
                ],
              ),
            );
          }
        });
  }

  void filterList() {
    filterDate.clear();
    asyncSnapshot.data.completeOrder
        .map((item) => {
              if (fromDate.isBefore(
                      new DateFormat("yyyy-MM-dd").parse(item.complete_date)) &&
                  toDate.isAfter(
                      new DateFormat("yyyy-MM-dd").parse(item.complete_date)))
                filterDate.add(item)
            })
        .toList();
    setState(() {
      print("filtered length >>>>" + filterDate.length.toString());
      if (filterDate.length == 0) {
        final snackBar =
            SnackBar(content: Text('No invoice found between provided Date'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }
}

class ModelListTile extends StatelessWidget {
  final CompleteOrder completeOrder;
  final customerId;

  const ModelListTile({Key key, this.completeOrder, this.customerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        color: kWhiteColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order Number",
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text("Total Amount",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kSecondaryColor,
                                fontSize: 14)),
                        Text("Total Quantity",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kSecondaryColor,
                                fontSize: 14)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(" : ",
                            style: TextStyle(
                                color: kBlackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Text(" : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackColor,
                                fontSize: 14)),
                        Text(" : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackColor,
                                fontSize: 14)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${completeOrder.orderNumber}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackColor,
                                fontSize: 14)),
                        Text("₹.${completeOrder.orderAmount} /-",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackColor,
                                fontSize: 14)),
                        Text("${completeOrder.totalOrderQuantity}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kBlackColor,
                                fontSize: 14)),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                  child: Divider(
                    color: Colors.grey,
                    height: 0.0,
                    thickness: 0.5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () {
                          var widget;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetailsByIdPage(
                                        customerId: customerId,
                                        orderId: completeOrder.orderId,
                                        orderName: completeOrder.orderNumber,
                                      )));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: kPrimaryColor)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("View Order Details",
                                  style: TextStyle(
                                      color: kBlackColor, fontSize: 14)),
                            )))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
