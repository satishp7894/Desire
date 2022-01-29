import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/customer_credit_details_bloc.dart';
import 'package:desire_users/models/customer_credit_details_model.dart';
import 'package:desire_users/models/modelList_model.dart';
import 'package:desire_users/models/sales_customer_credit_list_model.dart';
import 'package:desire_users/pages/product/productFromModelPage.dart';
import 'package:desire_users/sales/bloc/model_list_bloc.dart';
import 'package:desire_users/sales/bloc/sales_customer_credit_list_bloc.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';

class SalesCustomerCreditDetails extends StatefulWidget {
  final salemanId;

  const SalesCustomerCreditDetails({Key key, this.salemanId}) : super(key: key);

  @override
  _SalesCustomerCreditDetailsState createState() =>
      _SalesCustomerCreditDetailsState();
}

class _SalesCustomerCreditDetailsState
    extends State<SalesCustomerCreditDetails> {
  final SalesCustomerCreditListBloc salescustomercreditlistbloc =
      SalesCustomerCreditListBloc();
  AsyncSnapshot<SalesCustomerCredirListModel> asyncSnapshot;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    salescustomercreditlistbloc.fetchSalesCredit(widget.salemanId);
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
    salescustomercreditlistbloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0.0,
          iconTheme: IconThemeData(color: kBlackColor),
          centerTitle: true,
          title: Text("Credit List"),
          titleTextStyle: TextStyle(color: kBlackColor, fontSize: 18.0),
        ),
        body: RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: () {
            return Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (builder) => SalesCustomerCreditDetails(
                          salemanId: widget.salemanId,
                        )));
          },
          child: _body(),
        ));
  }

  Widget _body() {
    return StreamBuilder<SalesCustomerCredirListModel>(
        stream: salescustomercreditlistbloc.salesCreditStream,
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
          } else if (s.data.creditList != null &&
              s.data.creditList.length == 0) {
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
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ...List.generate(
                      asyncSnapshot.data.creditList.length,
                      (index) => ModelOutstandingListTile(
                          creditList: asyncSnapshot.data.creditList[index]))
                ],
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

class ModelOutstandingListTile extends StatelessWidget {
  final CreditList creditList;

  const ModelOutstandingListTile({Key key, this.creditList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: kPrimaryColor, width: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        color: kWhiteColor,
        child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(creditList.customerName, "Customer Name : "),
                textWidget(creditList.creditLimit, "Credit Limit : "),
                textWidget(
                    creditList.pendingCreditLimit, "Pending Credit Limit : "),
                textWidget(creditList.creditDays, "Credit Days : "),
              ],
            )),
      ),
    );
  }

  Widget textWidget(String credit, String name) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        text: name,
        style: TextStyle(color: Colors.grey, fontSize: 15),
        children: <TextSpan>[
          TextSpan(
            text: credit,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}
