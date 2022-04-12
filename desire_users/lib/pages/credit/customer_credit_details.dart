import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/customer_credit_details_bloc.dart';
import 'package:desire_users/models/customer_credit_details_model.dart';
import 'package:desire_users/models/modelList_model.dart';
import 'package:desire_users/pages/product/productFromModelPage.dart';
import 'package:desire_users/sales/bloc/model_list_bloc.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomerCreditDetails extends StatefulWidget {
  final customerId;
  final name;

  const CustomerCreditDetails({Key key, this.customerId, this.name})
      : super(key: key);

  @override
  _CustomerCreditDetailsState createState() => _CustomerCreditDetailsState();
}

class _CustomerCreditDetailsState extends State<CustomerCreditDetails> {
  final CustomerCreditDetailsBloc customercreditdetailsbloc =
      CustomerCreditDetailsBloc();
  AsyncSnapshot<CustomerCreditDetailsModel> asyncSnapshot;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    customercreditdetailsbloc.fetchCreditDetails(widget.customerId);
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
    super.dispose();
    customercreditdetailsbloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: kBlackColor),
        centerTitle: true,
        title: Text("Credit Details"),
        titleTextStyle: TextStyle(color: kBlackColor, fontSize: 18.0),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder<CustomerCreditDetailsModel>(
        stream: customercreditdetailsbloc.creditDetailStream,
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
              child: Card(
                child: Container(
                  height: 150,
                  margin: EdgeInsets.only(top: 20),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      textwidget("Credit Limit : ",
                          asyncSnapshot.data.data.creditLimit),
                      textwidget(
                          "Credit Days : ", asyncSnapshot.data.data.creditDays),
                      textwidget("Pending Credit Limit : ",
                          asyncSnapshot.data.data.pendingCreditLimit),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        width: 50,
                        child: Divider(
                          height: 1,
                          thickness: 10,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  Widget textwidget(String name, String value) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: name,
        style: TextStyle(color: Colors.grey, fontSize: 18),
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
