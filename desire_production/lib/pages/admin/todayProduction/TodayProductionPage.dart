import 'package:desire_production/bloc/TodayProductionBloc.dart';
import 'package:desire_production/model/TodayProductionModel.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProductFromModelPage.dart';

class TodayProductionPage extends StatefulWidget {
  final type;
  final customerId;
  final customerName;

  const TodayProductionPage(
      {Key key, this.type, this.customerId, this.customerName})
      : super(key: key);

  @override
  _TodayProductionPageState createState() => _TodayProductionPageState();
}

class _TodayProductionPageState extends State<TodayProductionPage> {
  final TodayProductionBloc todayProductionBloc = TodayProductionBloc();
  AsyncSnapshot<TodayProductionModel> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (widget.type != "sales") {
    //   getUserDetails();
    // }
    todayProductionBloc.fetchTodayProduction();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    todayProductionBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
        iconTheme: IconThemeData(color: kBlackColor),
        title: Text("Today Production "),
        titleTextStyle: TextStyle(
            color: kBlackColor, fontSize: 18, fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder<TodayProductionModel>(
        stream: todayProductionBloc.todayProductionStream,
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
                          flex: 2,
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
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.zero,
                                border:
                                    Border.all(color: kBlackColor, width: 0.5)),
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
                      ],
                    ),
                  ),
                  ...List.generate(
                      asyncSnapshot.data.todaysProduction.length,
                      (index) => ModelListTile(
                            todaysProduction:
                                asyncSnapshot.data.todaysProduction[index],
                            customerId: widget.customerId,
                            customerName: widget.customerName,
                            type: widget.type,
                          ))
                ],
              ),
            );
          }
        });
  }
}

class ModelListTile extends StatelessWidget {
  final TodaysProduction todaysProduction;
  final customerId, customerName, type;

  const ModelListTile(
      {Key key,
      this.todaysProduction,
      this.customerId,
      this.customerName,
      this.type})
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
            flex: 2,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: kBlackColor, width: 0.5)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    todaysProduction.modelNo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kBlackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  border: Border.all(color: kBlackColor, width: 0.5)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProductFromModelPage(
                          customerId: customerId,
                          modelNo: todaysProduction.modelNo,
                          modelNoId: todaysProduction.modelNoId,
                          customerName: customerName,
                          type: type);
                    }));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "View Products",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: kWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              )),
        ],
      ),
    );
  }
}
