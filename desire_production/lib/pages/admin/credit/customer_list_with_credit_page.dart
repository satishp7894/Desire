import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/customer_list_with_credit_bloc.dart';
import 'package:desire_production/bloc/customer_outstanding_list_bloc.dart';
import 'package:desire_production/model/customer_list_with_credit_model.dart';
import 'package:desire_production/model/customer_outstanding_list_model.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomerListWithCreditPage extends StatefulWidget {
  final screenType;
  final userType;

  const CustomerListWithCreditPage({Key key, this.screenType, this.userType})
      : super(key: key);

  @override
  _CustomerListWithCreditPageState createState() =>
      _CustomerListWithCreditPageState();
}

class _CustomerListWithCreditPageState
    extends State<CustomerListWithCreditPage> {
  CustomerListWithCreditBloc creditlistbloc = CustomerListWithCreditBloc();
  CustomerOutstandingListBloc outstandingList = CustomerOutstandingListBloc();
  AsyncSnapshot<CustomerListWithCreditModel> asyncSnapshot;
  AsyncSnapshot<CustomerOutstandingListModel> asyncSnapshotOutstanding;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();
    if (widget.screenType == "credit") {
      creditlistbloc.fetchlistWithCredit();
    } else {
      outstandingList.fetchCustomerOutstandingList(widget.userType);
    }
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
    // TODO: implement dispose
    super.dispose();
    creditlistbloc.dispose();
    outstandingList.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhite,
          iconTheme: IconThemeData(color: kBlackColor),
          title: Text(widget.screenType == "credit"
              ? "List With Credit"
              : "Total Outstanding"
                  ""),
          titleTextStyle: TextStyle(
              color: kBlackColor, fontSize: 18, fontWeight: FontWeight.bold),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: () {
            return Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (builder) => CustomerListWithCreditPage()));
          },
          child: widget.screenType == "credit" ? _body() : _outstandingBody(),
        ));
  }

  Widget _body() {
    return StreamBuilder<CustomerListWithCreditModel>(
        stream: creditlistbloc.withlistCreditStream,
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
          } else if (s.data.customerListWithCredit.length == 0) {
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
                      asyncSnapshot.data.customerListWithCredit.length,
                      (index) => ModelListTile(
                          credit:
                              asyncSnapshot.data.customerListWithCredit[index]))
                ],
              ),
            );
          }
        });
  }

  Widget _outstandingBody() {
    return StreamBuilder<CustomerOutstandingListModel>(
        stream: outstandingList.customerOutstandingListStream,
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
          } else if (s.data.totalOutstanding.length == 0) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          } else {
            asyncSnapshotOutstanding = s;
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ...List.generate(
                      asyncSnapshotOutstanding.data.totalOutstanding.length,
                      (index) => ModelOutstandingListTile(
                          outstanding: asyncSnapshotOutstanding
                              .data.totalOutstanding[index]))
                ],
              ),
            );
          }
        });
  }
}

class ModelListTile extends StatelessWidget {
  final CustomerListWithCredit credit;

  const ModelListTile({Key key, this.credit}) : super(key: key);

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
        color: kWhite,
        child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(credit.customerName, "Customer Name : "),
                textWidget(credit.firstname, "Salesman Name : "),
                textWidget(credit.creditLimit, "Credit Limit : "),
                textWidget(credit.creditDays, "Credit Days : "),
                textWidget(credit.pendingCreditLimit, "Pending Credit :"),
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
          TextSpan(text: credit, style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}

class ModelOutstandingListTile extends StatelessWidget {
  final TotalOutstanding outstanding;

  const ModelOutstandingListTile({Key key, this.outstanding}) : super(key: key);

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
          color: kWhite,
          child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  textWidget(outstanding.customerName, "Customer Name : "),
                  textWidget(
                      outstanding.totalOutstanding, "Total Outstanding : "),
                  textWidget(
                      outstanding.immediatePayment, "Immediate Payment : "),
                ],
              )),
        ));
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
