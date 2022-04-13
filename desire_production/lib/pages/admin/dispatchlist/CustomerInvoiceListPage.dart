import 'package:desire_production/bloc/CustomerInvoiceSalesBloc.dart';
import 'package:desire_production/model/InvoiceModel.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'InvoiceDetailSalesPage.dart';

class CustomerInvoiceListPage extends StatefulWidget {
  final salesId;

  const CustomerInvoiceListPage({Key key, this.salesId}) : super(key: key);

  @override
  _CustomerInvoiceListPageState createState() =>
      _CustomerInvoiceListPageState();
}

class _CustomerInvoiceListPageState extends State<CustomerInvoiceListPage> {
  final CustomerInvoiceSalesBloc customerinvoicesalesbloc =
      CustomerInvoiceSalesBloc();
  InvoiceModel asyncSnapshot;
  TextEditingController fromDateinput = TextEditingController();
  TextEditingController toDateinput = TextEditingController();
  List<CustomerInvoice> cs;
  var toDate;
  var fromDate;
  List<CustomerInvoice> filterDate = [];

  String customerName = "";
  String customerId = "";
  bool isVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerinvoicesalesbloc.fetchsaleInvoiceList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    customerinvoicesalesbloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
        iconTheme: IconThemeData(color: kBlackColor),
        title: Text("Invoices"),
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
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder<InvoiceModel>(
        stream: customerinvoicesalesbloc.invoiceListStream,
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
          } else if (s.data.customerInvoice.length == 0) {
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                s.data.message,
              ),
            );
          } else {
            asyncSnapshot = s.data;
            cs = asyncSnapshot.customerInvoice;
            return SingleChildScrollView(
              child: Column(
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
                                              fromDateinput.clear();
                                              toDateinput.clear();
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
                      filterDate.length > 0
                          ? filterDate.length
                          : asyncSnapshot.customerInvoice.length,
                      (index) => InvoicesTile(
                            customerInvoice: filterDate.length > 0
                                ? filterDate[index]
                                : asyncSnapshot.customerInvoice[index],
                            link: asyncSnapshot.invoiceUrl,
                          ))
                ],
              ),
            );
          }
        });
  }

  void filterList() {
    filterDate.clear();
    asyncSnapshot.customerInvoice
        .map((item) => {
              if (fromDate.isBefore(
                      new DateFormat("yyyy-MM-dd").parse(item.invoiceDate)) &&
                  toDate.isAfter(
                      new DateFormat("yyyy-MM-dd").parse(item.invoiceDate)))
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

class InvoicesTile extends StatelessWidget {
  final CustomerInvoice customerInvoice;
  final link;

  const InvoicesTile({Key key, this.customerInvoice, this.link})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: kPrimaryColor),
            borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Invoice No: " + customerInvoice.invoiceNumber,
                  style: TextStyle(
                      color: kBlackColor, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Invoice Date: " + customerInvoice.invoiceDate,
                  style: TextStyle(
                      color: kBlackColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: kPrimaryColor,
              ),
              padding: EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InvoiceDetailSalesPage(
                                id: customerInvoice.dispatchinvoiceid,
                                pdf: link + customerInvoice.invoiceFile,
                              )));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.read_more,
                      color: kWhite,
                    ),
                    Text(
                      "View",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: kWhite),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
