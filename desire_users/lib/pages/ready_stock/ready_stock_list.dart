import 'package:desire_users/bloc/ready_stock_list_bloc.dart';
import 'package:desire_users/models/ready_stock_list_model.dart';
import 'package:desire_users/pages/product/productFromModelPage.dart';
import 'package:desire_users/pages/ready_stock/ready_Stock_from_model_page.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';

class ReadyStockListView extends StatefulWidget {
  final customerId;
  final type;

  const ReadyStockListView({Key key, this.customerId, this.type})
      : super(key: key);

  @override
  _ReadyStockListViewState createState() => _ReadyStockListViewState();
}

class _ReadyStockListViewState extends State<ReadyStockListView> {
  final ReadyStockListBloc readyStockListBloc = ReadyStockListBloc();
  AsyncSnapshot<ReadyStockListModel> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readyStockListBloc.fetchReadyStockList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    readyStockListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        iconTheme: IconThemeData(color: kBlackColor),
        title: Text("Ready Stock"),
        titleTextStyle: TextStyle(
            color: kBlackColor, fontSize: 18, fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder<ReadyStockListModel>(
        stream: readyStockListBloc.readyStockListStream,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.zero,
                                  border: Border.all(
                                      color: kBlackColor, width: 0.5)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Model No",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.zero,
                                  border: Border.all(
                                      color: kBlackColor, width: 0.5)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Quantity",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.zero,
                                  border: Border.all(
                                      color: kBlackColor, width: 0.5)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "View Products",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  ...List.generate(
                      asyncSnapshot.data.readyStockList.length,
                      (index) => ModelListTile(
                          readyStockList:
                              asyncSnapshot.data.readyStockList[index],
                          customerId: widget.customerId,
                          type: widget.type))
                ],
              ),
            );
          }
        });
  }
}

class ModelListTile extends StatelessWidget {
  final ReadyStockList readyStockList;
  final customerId;
  final type;

  const ModelListTile(
      {Key key, this.readyStockList, this.customerId, this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: kBlackColor, width: 0.5)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    readyStockList.modelNoId,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kBlackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: kBlackColor, width: 0.5)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    readyStockList.quantity,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kBlackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: kBlackColor, width: 0.5)),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ReadyStockFromModelPage(
                            customerId: customerId,
                            modelNoId: readyStockList.modelNoId,
                            type: type);
                      }));
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "View",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kWhiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: kWhiteColor,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
