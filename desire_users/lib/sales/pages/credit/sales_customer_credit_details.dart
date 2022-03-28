import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/customer_credit_details_bloc.dart';
import 'package:desire_users/models/customer_credit_details_model.dart';
import 'package:desire_users/models/modelList_model.dart';
import 'package:desire_users/models/sales_customer_credit_list_model.dart';
import 'package:desire_users/pages/product/productFromModelPage.dart';
import 'package:desire_users/sales/bloc/model_list_bloc.dart';
import 'package:desire_users/sales/bloc/sales_customer_credit_list_bloc.dart';
import 'package:desire_users/sales/pages/customerCredit/add_credits_page.dart';
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
  List<CreditList> _searchResult = [];
  TextEditingController searchView;
  bool search = false;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    searchView = TextEditingController();
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
          title: Text("Customer Credit List"),
          titleTextStyle: TextStyle(color: kBlackColor, fontSize: 18.0),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(50), child: _searchView()),
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
          child: _body(widget.salemanId),
        ));
  }

  Widget _body(salemanId) {
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
              child: searchView.text.length == 0
                  ? Column(
                      children: [
                        ...List.generate(
                            asyncSnapshot.data.creditList.length,
                            (index) => ModelOutstandingListTile(
                                creditList:
                                    asyncSnapshot.data.creditList[index]))
                      ],
                    )
                  : _searchResult.length == 0
                      ? Container(
                          alignment: Alignment.center,
                          child: Text(
                            "No Data Found",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800),
                          ))
                      : Column(
                          children: [
                            ...List.generate(
                                _searchResult.length,
                                (index) => ModelOutstandingListTile(
                                    creditList: _searchResult[index]))
                          ],
                        ),
            );
          }
        });
  }

  Widget _searchView() {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(left: 15, right: 15, top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.black,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              controller: searchView,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              onChanged: (value) {
                setState(() {
                  search = true;
                  onSearchTextChangedICD(value);
                });
              },
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
              ),
            ),
          ),
        ],
      ),
    );
  }

  onSearchTextChangedICD(String text) async {
    _searchResult.clear();
    print("$text value from search");
    if (text.isEmpty) {
      setState(() {
        search = false;
      });
      return;
    }

    asyncSnapshot.data.creditList.forEach((exp) {
      if (exp.customerName.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
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
  final salesId;

  const ModelOutstandingListTile({Key key, this.creditList, this.salesId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: double.infinity,
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => AddCreditsPage(
                          salesId: salesId,
                          custId: creditList.customerId,
                        )));
          },
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
                    textWidget(creditList.pendingCreditLimit,
                        "Pending Credit Limit : "),
                    textWidget(creditList.creditDays, "Credit Days : "),
                  ],
                )),
          )),
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
