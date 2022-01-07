import 'package:desire_users/bloc/invoice_bloc.dart';
import 'package:desire_users/models/invoice_model.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'invoice_detail_page.dart';

class InvoiceListPage extends StatefulWidget {

  final customerId, customerName;
  const InvoiceListPage({Key key,this.customerId,this.customerName}) : super(key: key);

  @override
  _InvoiceListPageState createState() => _InvoiceListPageState();
}

class _InvoiceListPageState extends State<InvoiceListPage> {
  final InvoiceBloc invoiceBloc =  InvoiceBloc();
  AsyncSnapshot<InvoiceModel> asyncSnapshot;


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
                  ...List.generate(asyncSnapshot.data.customerInvoice.length, (index) => InvoicesTile(
                    customerInvoice: asyncSnapshot.data.customerInvoice[index],
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

  const InvoicesTile({Key key,this.customerInvoice}) : super(key: key);

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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>InvoiceDetailPage(
                     id:customerInvoice.dispatchinvoiceid
                    )));

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

