import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/customer_list_with_credit_bloc.dart';
import 'package:desire_production/bloc/customer_outstanding_list_bloc.dart';
import 'package:desire_production/bloc/today_invoice_dispatch_details_bloc.dart';
import 'package:desire_production/bloc/today_order_details_page_bloc.dart';
import 'package:desire_production/model/customer_list_with_credit_model.dart';
import 'package:desire_production/model/customer_outstanding_list_model.dart';
import 'package:desire_production/model/today_dispatch_invoice_details_model.dart';
import 'package:desire_production/model/today_order_details_page_model.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class TodayOrderDetailsPage extends StatefulWidget {
  final screenType;

  const TodayOrderDetailsPage({Key key, this.screenType}) : super(key: key);

  @override
  _TodayOrderDetailsPageState createState() => _TodayOrderDetailsPageState();
}

class _TodayOrderDetailsPageState extends State<TodayOrderDetailsPage> {
  TodayOrderDetailsPageBloc todayorderdetailspagebloc =
      TodayOrderDetailsPageBloc();
  TodayInvoiceDispatchDetailsBloc todayinvoicedispatchdetailsbloc = TodayInvoiceDispatchDetailsBloc();

  AsyncSnapshot<TodayOrderDetailsPageModel> asyncSnapshot;
  AsyncSnapshot<TodayDispatchInvoiceDetailsModel> asyncSnapshotDispatch;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();
    if(widget.screenType == "oDetail") {
      todayorderdetailspagebloc.fetchTodayOrderDetails();
    }else{
      todayinvoicedispatchdetailsbloc.fetchTodayDispatchDetails();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhite,
          iconTheme: IconThemeData(color: kBlackColor),
          title: Text(widget.screenType == "oDetail" ? "Order Details" : "Invoice Details"),
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
                    builder: (builder) => TodayOrderDetailsPage()));
          },
          child: widget.screenType == "oDetail" ? _body() : _dispatchBody(),
        ));
  }

  Widget _body() {
    return StreamBuilder<TodayOrderDetailsPageModel>(
        stream: todayorderdetailspagebloc.todayOrderDetailsStream,
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
          } else if (s.data.todayOrder.length == 0) {
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
                      asyncSnapshot.data.todayOrder.length,
                      (index) => ModelListTile(
                          order: asyncSnapshot.data.todayOrder[index]))
                ],
              ),
            );
          }
        });
  }
  Widget _dispatchBody() {
    return StreamBuilder<TodayDispatchInvoiceDetailsModel>(
        stream: todayinvoicedispatchdetailsbloc.todayDispatchDetailsStream,
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
          } else if (s.data.todayDispatchInvoice.length == 0) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          } else {
            asyncSnapshotDispatch = s;
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  ...List.generate(
                      asyncSnapshotDispatch.data.todayDispatchInvoice.length,
                          (index) => ModelListDispatchTile(
                          order: asyncSnapshotDispatch.data.todayDispatchInvoice[index]))
                ],
              ),
            );
          }
        });
  }
}

class ModelListTile extends StatelessWidget {
  final TodayOrder order;

  const ModelListTile({Key key, this.order}) : super(key: key);

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
                textWidget(order.customerName, "Customer Name : "),
                textWidget(order.orderNumber, "Order Number : "),
                textWidget(order.totalOrderQuantity, "Total Order Quantity : "),
                textWidget(order.orderAmount, "Order Amount : "),
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

class ModelListDispatchTile extends StatelessWidget {
  final TodayDispatchInvoice order;

  const ModelListDispatchTile({Key key, this.order}) : super(key: key);

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
                textWidget(order.customerName, "Customer Name : "),
                textWidget(order.invoiceNumber, "Invoice Number : "),
                textWidget(order.clientInvoiceNumber, "Client Invoice : "),
                textWidget(order.invoiceAmount, "Invoice Amount : "),
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
