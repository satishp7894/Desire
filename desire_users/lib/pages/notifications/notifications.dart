import 'dart:convert';

import 'package:desire_users/bloc/customer_notification_list_bloc.dart';
import 'package:desire_users/models/customer_notification_list_model.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;

class CustomerNotifications extends StatefulWidget {
  final customerId;

  const CustomerNotifications({Key key, this.customerId}) : super(key: key);

  @override
  _CustomerNotificationsState createState() => _CustomerNotificationsState();
}

class _CustomerNotificationsState extends State<CustomerNotifications> {
  CustomerNotificationListBloc notificationBloc =
      CustomerNotificationListBloc();

  List<CustomerNotification> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationBloc.fetchCustomerNotification(widget.customerId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    notificationBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0.0,
          iconTheme: IconThemeData(color: kBlackColor),
          titleTextStyle: TextStyle(color: kBlackColor, fontSize: 18.0),
          title: Text("Notifications"),
          centerTitle: true,
          actions: [
            asyncSnapshot !=null && asyncSnapshot.length > 0 ?Container(
                margin: EdgeInsets.only(right: 20),
                child: InkWell(
                  onTap: () {
                    clearNotification(widget.customerId);
                  },
                  child: Icon(
                    Icons.clear_all,
                    color: kPrimaryColor,
                  ),
                )):Container()
          ]),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder<CustomerNotificationListModel>(
        stream: notificationBloc.newNotificationStream,
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
          } else if (s.data.customerNotification.length == 0) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          } else {
            asyncSnapshot = s.data.customerNotification;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                      asyncSnapshot.length,
                      (index) => notificationTile(
                          customerLedger: asyncSnapshot[index], index: index))
                ],
              ),
            );
          }
        });
  }

  Widget notificationTile({CustomerNotification customerLedger, int index}) {
    return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
                child: Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5),
              child: Container(
                margin: EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: kBlackColor, width: 0.5),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.notifications,
                            color: kPrimaryColor,
                          )),
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customerLedger.title,
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text(
                              customerLedger.description,
                              style: TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Text(
                            customerLedger.createAt,
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ))
                    ],
                  ),
                ),
              ),
            ))));
  }

  void clearNotification(customerId) async {
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),
    );
    pr.show();
    var response =
        await http.post(Uri.parse(Connection.clearCustomerNotification), body: {
      'secretkey': Connection.secretKey,
      'customer_id': customerId,
    });
    pr.hide();
    if (response.statusCode == 200) {
      print(response.body);
      var results = json.decode(response.body);
      print('response == $results  ${response.body}');
      pr.hide();
      if (results['status'] == true) {
        if(asyncSnapshot != null && asyncSnapshot.length > 0) {
          setState(() {
            asyncSnapshot.clear();
          });
        }
        Alerts.showAlertAndBack(context, "Success", results['message']);
      } else {
        print('error deleting address');
        Alerts.showAlertAndBack(context, 'Error', 'Address not Deleted.');
      }
    }
  }
}
