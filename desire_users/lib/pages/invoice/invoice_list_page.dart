import 'package:desire_users/bloc/invoice_bloc.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/models/invoice_model.dart';
import 'package:desire_users/pages/complaint/add_complaint.dart';
import 'package:desire_users/pages/return_material/submit_return_material.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'invoice_detail_page.dart';

class InvoiceListPage extends StatefulWidget {
  final customerId, customerName, type;

  const InvoiceListPage(
      {Key key, this.customerId, this.customerName, this.type})
      : super(key: key);

  @override
  _InvoiceListPageState createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  final InvoiceBloc invoiceBloc = InvoiceBloc();
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

  getUserDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      customerName = sharedPreferences.getString("Customer_name");
      customerId = sharedPreferences.getString("customer_id");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
    invoiceBloc.fetchInvoiceDetails(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        iconTheme: IconThemeData(color: kBlackColor),
        title: Text("${widget.customerName} Invoices"),
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
        stream: invoiceBloc.invoiceStream,
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
            asyncSnapshot = s.data;
            cs = asyncSnapshot.customerInvoice;
            return SingleChildScrollView(
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
                          type: widget.type,
                          customerId: widget.customerId))
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
  final type;
  final customerId;

  const InvoicesTile(
      {Key key, this.customerInvoice, this.type, this.customerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Invoice No: " + customerInvoice.invoiceNumber,
            style: TextStyle(color: kBlackColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Invoice Date: " + customerInvoice.invoiceDate,
                style:
                    TextStyle(color: kBlackColor, fontWeight: FontWeight.w500),
              ),
              TextButton(
                  style: TextButton.styleFrom(backgroundColor: kPrimaryColor),
                  onPressed: () {
                    if (type == 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InvoiceDetailPage(
                                  id: customerInvoice.dispatchinvoiceid)));
                    } else if (type == 2) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubmitReturnMaterial(
                                  id: customerInvoice.dispatchinvoiceid,
                                  customerId: customerId,
                                  type: 1)));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubmitReturnMaterial(
                                  id: customerInvoice.dispatchinvoiceid,
                                  customerId: customerId,
                                  type: 0)));
                    }
                  },
                  child: Text(
                    "View & Download Invoice",
                    style: TextStyle(color: kWhiteColor),
                  ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 0.0,
            color: kSecondaryColor,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
