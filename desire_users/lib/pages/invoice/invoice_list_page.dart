import 'package:desire_users/bloc/invoice_bloc.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/models/invoice_model.dart';
import 'package:desire_users/pages/return_material/submit_return_material.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'invoice_detail_page.dart';

class InvoiceListPage extends StatefulWidget {

  final customerId, customerName, type;
  const InvoiceListPage({Key key,this.customerId,this.customerName, this.type}) : super(key: key);

  @override
  _InvoiceListPageState createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  final InvoiceBloc invoiceBloc =  InvoiceBloc();
  AsyncSnapshot<InvoiceModel> asyncSnapshot;
  TextEditingController fromDateinput = TextEditingController();
  TextEditingController toDateinput = TextEditingController();



  String customerName = "";
  String customerId = "";
  getUserDetails()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
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
        iconTheme: IconThemeData(
            color: kBlackColor
        ),
        title: Text("${widget.customerName} Invoices"),
        titleTextStyle: TextStyle(color: kBlackColor,fontSize: 18,fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: _body(),
    );
  }


  Widget _body(){
    return StreamBuilder<InvoiceModel>(
        stream: invoiceBloc.invoiceStream,
        builder: (c,s){
          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50, child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),));
          }
          else if (s.hasError) {
            print("as3 error");
            print(s.error);
            return Container(height: 300,
              alignment: Alignment.center,
              child: SelectableText("Error Loading Data ${s.error}",),);
          }
          else  if (s.data.toString().isEmpty) {
            print("as3 empty");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("No Data Found",),);
          }
          else {
            asyncSnapshot = s;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Center(
                          child: TextField(
                            controller: fromDateinput,
                            //editing controller of this TextField
                            decoration: InputDecoration(
                                icon: Icon(Icons.calendar_today),
                                //icon of text field
                                labelText: "Enter Start Date" //label text of field
                            ),
                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              DateTime pickedDate = await showDatePicker(
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
                                      DateFormat('yyyy-MM-dd').format(pickedDate);
                                  //set output date to TextField value.
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                          )),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                            child: TextField(
                              controller: toDateinput,
                              //editing controller of this TextField
                              decoration: InputDecoration(
                                  icon: Icon(Icons.calendar_today),
                                  //icon of text field
                                  labelText: "Enter End Date" //label text of field
                              ),
                              readOnly: true,
                              //set it true, so that user will not able to edit text
                              onTap: () async {
                                DateTime pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101));

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000

                                  setState(() {
                                    toDateinput.text = DateFormat('yyyy-MM-dd').format(
                                        pickedDate); //set output date to TextField value.
                                  });
                                } else {
                                  print("Date is not selected");
                                }
                              },
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              width: 150,
                              height: 50,
                              child: DefaultButton(
                                text: "Filter",
                                press: () {
                                  // if (fromDateinput.text != "" &&
                                  //     toDateinput.text != "") {
                                  //   filterLedgerList(widget.customerId);
                                  // } else {
                                  //   final snackBar = SnackBar(
                                  //       content: Text(
                                  //           "Please Enter Start Date and End Date."));
                                  //   ScaffoldMessenger.of(context)
                                  //       .showSnackBar(snackBar);
                                  // }
                                },
                              ),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: 150,
                              height: 50,
                              child: DefaultButton(
                                text: "Clear Filter",
                                press: () {
                                  // fromDateinput.clear();
                                  // toDateinput.clear();
                                  // asyncSnapshot.clear();
                                  // ledgerBloc.fetchLedger(widget.customerId);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ...List.generate(asyncSnapshot.data.customerInvoice.length, (index) => InvoicesTile(
                    customerInvoice: asyncSnapshot.data.customerInvoice[index],type: widget.type,customerId:widget.customerId
                  ))
                ],
              ),
            );
          }

        });
  }
}


class InvoicesTile extends StatelessWidget {

 final  CustomerInvoice customerInvoice;
 final type;
 final customerId;

  const InvoicesTile({Key key,this.customerInvoice, this.type, this.customerId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Invoice No: "+customerInvoice.invoiceNumber,style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold),),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Invoice Date: "+customerInvoice.invoiceDate,style: TextStyle(color: kBlackColor,fontWeight: FontWeight.w500),),
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: kPrimaryColor
                  ),
                  onPressed: (){
                    if(type == 0) {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          InvoiceDetailPage(
                              id: customerInvoice.dispatchinvoiceid
                          )));
                    }else{
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                          SubmitReturnMaterial(
                              id: customerInvoice.dispatchinvoiceid, customerId: customerId
                          )));
                    }

                  }, child: Text("View & Download Invoice",style: TextStyle(color: kWhiteColor),))
            ],
          ),
          SizedBox(height: 10,),
          Divider(height:0.0,color: kSecondaryColor,thickness: 1,),

        ],
      ),
    );
  }
}

