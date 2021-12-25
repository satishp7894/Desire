import 'package:desire_production/bloc/complaint_details_bloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/complaint_detail_model.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ComplaintDetailPage extends StatefulWidget {
  final String complaintId;

  const ComplaintDetailPage({@required this.complaintId});

  @override
  _ComplaintDetailPageSate createState() => _ComplaintDetailPageSate();
}

class _ComplaintDetailPageSate extends State<ComplaintDetailPage> {
  var complaintDetail = ComplaintDetialBloc();
  List<ComplaintDetails> details;

  @override
  void initState() {
    complaintDetail.fetchComplaintDetail(widget.complaintId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Complaint Detail",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        body: _body());
  }

  Widget _body() {
    return StreamBuilder<ComplaintDetailModel>(
        stream: complaintDetail.customerComplaintDetailStream,
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
          if (s.data.complaintDetails == null) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Orders Found",
              ),
            );
          }

          if (s.data.complaintDetails != null &&
              s.data.complaintDetails.length > 0) {
            details = s.data.complaintDetails;
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.all(10),
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
                                        text: details[0].customerName,
                                        style: TextStyle(color: Colors.black)),
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
                                          text: details[0].invoiceNumber,
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 5),
                                child: RichText(
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    text: "Description : ",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: details[0].description,
                                          style:
                                          TextStyle(color: Colors.black)),
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
                                          text: details[0].complaintDate,
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    details[0].photo != null && details[0].photo == ""
                        ? Container()
                        : Container(
                            height: 350,
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.network(
                                s.data.complaint_photo_url + details[0].photo,
                                fit: BoxFit.fill,
                                height: 350,
                                loadingBuilder: (BuildContext ctx, Widget child,
                                    ImageChunkEvent loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                kPrimaryColor),
                                      ),
                                    );
                                  }
                                },
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              margin: EdgeInsets.all(10),
                            )),
                    details[0].video != null && details[0].video == ""
                        ? Container()
                        : Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                            child: DefaultButton(
                              text: "Show Video",
                              press: () {
                                launch(s.data.complaint_video_url +
                                    details[0].video);
                              },
                            ))

                    // Image.network(s.data.complaint_photo_url + details[0].photo,width: double.infinity,height: 300,fit: BoxFit.cover,),
                  ],
                ),
              ),
            );
          }
        });
  }
}
