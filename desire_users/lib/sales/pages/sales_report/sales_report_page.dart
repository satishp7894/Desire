import 'package:desire_users/models/ledger_model.dart';
import 'package:desire_users/models/sales_report_list_model.dart';
import 'package:desire_users/models/sales_report_model.dart';
import 'package:desire_users/sales/bloc/sales_report_bloc.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalesReportPage extends StatefulWidget {
  final salesid;

  const SalesReportPage({Key key, this.salesid}) : super(key: key);

  @override
  _SalesReportPageState createState() => _SalesReportPageState();
}

class _SalesReportPageState extends State<SalesReportPage> {
  var salesReportBloc = SalesReportBloc();
  List<ReportDetails> asyncSnapshot;
  LedgerModel ledgermodel;

  List<ReportDetails> as;
  TextEditingController fromDateinput = TextEditingController();
  TextEditingController toDateinput = TextEditingController();
  bool isVisible = false;
  String totalAmount = "";
  String totalQuantity = "";
  String totalOrder = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    salesReportBloc.fetchSalesReport(widget.salesid, "", "");
    salesReportBloc.fetchSalesReportList(widget.salesid, "", "");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    salesReportBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0.0,
          iconTheme: IconThemeData(color: kBlackColor),
          titleTextStyle: TextStyle(color: kBlackColor, fontSize: 18.0),
          title: Text("Sales Report"),
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
        /*  floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          generatePdf();
          savePdf(context);
        },
        label: Text(
          "Generate PDF",
          style: TextStyle(color: kWhiteColor),
        ),
        icon: Icon(
          Icons.add,
          color: kWhiteColor,
        ),
      ),*/
        body: StreamBuilder<SalesReportModel>(
            stream: salesReportBloc.reportStream,
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
              } else if (s.data.reportData == null) {
                print("as3 empty");
                return Container(
                  height: 300,
                  alignment: Alignment.center,
                  child: Text(
                    "No Data Found",
                  ),
                );
              } else {
                totalQuantity = s.data.reportData.totalQuantity;
                totalAmount = s.data.reportData.totalAmount;
                totalOrder = s.data.reportData.totalOrder;
                return _body();
              }
            }));
  }

  Widget _body() {
    return StreamBuilder<SalesReportListModel>(
        stream: salesReportBloc.reportListStream,
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
          } else if (s.data.reportDetails == null) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          } else {
            asyncSnapshot = s.data.reportDetails;
            as = s.data.reportDetails;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSize(
                    duration: Duration(milliseconds: 1000),
                    child: Container(
                        height: !isVisible ? 0.0 : null,
                        child: Visibility(
                            visible: isVisible,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width /
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
                                                    //DateTime.now() - not to allow to choose before today.
                                                    lastDate: DateTime(2101));

                                            if (pickedDate != null) {
                                              print(
                                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

                                              setState(() {
                                                fromDateinput.text =
                                                    DateFormat('dd-MM-yyyy')
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
                                          MediaQuery.of(context).size.width / 2,
                                      margin: const EdgeInsets.only(top: 5),
                                      padding: EdgeInsets.all(10),
                                      child: TextField(
                                        controller: toDateinput,
                                        //editing controller of this TextField
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.date_range),
                                            hintText: "Enter End Date",
                                            hintStyle: TextStyle(
                                                color: kSecondaryColor,
                                                fontSize: 12),
                                            labelText: "End Date",
                                            labelStyle:
                                                TextStyle(color: kPrimaryColor),
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
                                              toDateinput.text = DateFormat(
                                                      'dd-MM-yyyy')
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
                                            if (fromDateinput.text != "" &&
                                                toDateinput.text != "") {
                                              salesReportBloc.fetchSalesReport(
                                                  widget.salesid,
                                                  fromDateinput.text,
                                                  toDateinput.text);
                                              salesReportBloc
                                                  .fetchSalesReportList(
                                                      widget.salesid,
                                                      fromDateinput.text,
                                                      toDateinput.text);
                                            } else {
                                              final snackBar = SnackBar(
                                                  content: Text(
                                                      "Please Enter Start Date and End Date."));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          });
                                        },
                                        child: const Text('Filter',
                                            style:
                                                TextStyle(color: Colors.white)),
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
                                            salesReportBloc.fetchSalesReport(
                                                widget.salesid, "", "");
                                            salesReportBloc
                                                .fetchSalesReportList(
                                                    widget.salesid, "", "");
                                          });
                                        },
                                        child: const Text(
                                          'Clear Filter',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )))),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: kPrimaryColor)),
                  child: Column(
                    children: [
                      RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: "Total Order : ",
                          style: TextStyle(color: kBlackColor, fontSize: 20),
                          children: <TextSpan>[
                            TextSpan(
                                text: totalOrder,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: "Total Quantity : ",
                          style: TextStyle(color: kBlackColor, fontSize: 20),
                          children: <TextSpan>[
                            TextSpan(
                                text: totalQuantity,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: "Total Amount : ",
                          style: TextStyle(color: kBlackColor, fontSize: 20),
                          children: <TextSpan>[
                            TextSpan(
                                text: totalAmount,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: asyncSnapshot.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            reportDetails: asyncSnapshot[index],
                          );
                        }),
                  ),
                )
              ],
            );
          }
        });
  }
}

class ListTile extends StatelessWidget {
  final ReportDetails reportDetails;

  const ListTile({Key key, this.reportDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10.0, top: 5, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
            color: kWhiteColor,
            border: Border.all(color: kSecondaryColor),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              reportDetails.customerName == null
                  ? Text("N/A")
                  : RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "Customer Name : ",
                        style: TextStyle(color: kBlackColor, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                              text: reportDetails.customerName,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              reportDetails.orderNumber == null
                  ? Text("N/A")
                  : RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "Order Number : ",
                        style: TextStyle(color: kBlackColor, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                              text: reportDetails.orderNumber,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              reportDetails.orderDate == null
                  ? Text("N/A")
                  : RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "Date : ",
                        style: TextStyle(color: kBlackColor, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                              text: reportDetails.orderDate,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              reportDetails.totalOrderQuantity == null
                  ? Text("N/A")
                  : RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "Total Quantity : ",
                        style: TextStyle(color: kBlackColor, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                              text: reportDetails.totalOrderQuantity,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              reportDetails.orderAmount == null
                  ? Text("N/A")
                  : RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: "Order Amount : ",
                        style: TextStyle(color: kBlackColor, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                              text: reportDetails.orderAmount,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
