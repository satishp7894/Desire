import 'dart:math';

import 'package:desire_users/bloc/transport_list_bloc.dart';
import 'package:desire_users/models/transport_list_model.dart';
import 'package:desire_users/pages/transport_details/add_transport_details.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransportDetailsList extends StatefulWidget {


  final customerId;
  const TransportDetailsList({Key key, this.customerId}) : super(key: key);

  @override
  _TransportDetailsListState createState() => _TransportDetailsListState();
}

class _TransportDetailsListState extends State<TransportDetailsList> {

  final TransportListBloc transportListBloc =  TransportListBloc();
  AsyncSnapshot<TransportListModel> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("customer id ${widget.customerId}");
    transportListBloc.fetchTransportList(widget.customerId);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: kPrimaryColor,
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => AddTransportDetails(customerId: widget.customerId,)));

      }, label: Text("Add Transport Details",style: TextStyle(color: kWhiteColor),),icon: Icon(Icons.add,color: kWhiteColor,),),
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: kBlackColor
        ),
        titleTextStyle: TextStyle(color: kBlackColor,fontSize: 18.0),
        title: Text("Transport Details"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return StreamBuilder<TransportListModel>(
        stream: transportListBloc.transportListStream,
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
                  ...List.generate(asyncSnapshot.data.customerTransport.length, (index) => TransportListTile(
                    customerTransport: asyncSnapshot.data.customerTransport[index],
                  ))
                ],
              ),
            );
          }

        });
  }





}
class TransportListTile extends StatelessWidget {

  final  CustomerTransport customerTransport;

  const TransportListTile({Key key,this.customerTransport}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10.0,top: 5,bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name: "),
                          Text(customerTransport.transportName),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email : "),
                          customerTransport.emailId == null ? Text("N/A"):   Text(customerTransport.emailId),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mob No.: "),
                          customerTransport.mobileNo == null ? Text("N/A"):   Text(customerTransport.mobileNo),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("GST No.: "),
                          customerTransport.gst == null ? Text("N/A"):   Text(customerTransport.gst),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Address : "),
                  customerTransport.address == null ? Text("N/A"):
                  Expanded(
                      child: Text("${customerTransport.address}, ${customerTransport.city}, ${customerTransport.state}, ${customerTransport.pincode}")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}