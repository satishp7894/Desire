import 'package:desire_production/bloc/customer_complaint_bloc.dart';
import 'package:desire_production/model/customer_complaint_list_model.dart';
import 'package:desire_production/pages/production/complaint_detail_page.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomerComplaintPage extends StatefulWidget {
  @override
  _CustomerComplaintPageState createState() => _CustomerComplaintPageState();
}

class _CustomerComplaintPageState extends State<CustomerComplaintPage> {
  final complaintList = CustomerComplaintListBloc();
  List<ComplaintList> complainData;

  @override
  void initState() {
    complaintList.fetchCustomerComplaintList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Customer Complaint",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        body: _complaintList());
  }

  Widget _complaintList() {
    return StreamBuilder<CustomerComplaintListModel>(
      stream: complaintList.customerComplaintListStream,
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
        if (s.data.complaintList == null) {
          print("as3 empty");
          return Container(
            height: 300,
            alignment: Alignment.center,
            child: Text(
              "No Orders Found",
            ),
          );
        }

        complainData = s.data.complaintList;

        return ListView.builder(
            itemCount: complainData.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                  title: GestureDetector(
                      onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (b) => ComplaintDetailPage(complaintId: complainData[index].customerComplaintId)))
                          },
                      child: Card(
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Name : ",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: complainData[index]
                                                .customerName,
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Invoice Number : ",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: complainData[index]
                                                  .invoiceNumber,
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    )),
                                Container(
                                    margin: EdgeInsets.only(top: 5),
                                    child: RichText(
                                      text: TextSpan(
                                        text: "Complaint Date : ",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: complainData[index]
                                                  .complaintDate,
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ))));
            });
      },
    );
  }
}
