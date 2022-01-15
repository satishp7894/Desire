import 'package:desire_users/models/return_material_detail_sales_model.dart';
import 'package:desire_users/sales/bloc/return_material_sales_details_bloc.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ReturnMaterialDetailSalesPage extends StatefulWidget {
  final materialId;

  @override
  _ReturnMaterialDetailSalesPageState createState() =>
      _ReturnMaterialDetailSalesPageState();

  const ReturnMaterialDetailSalesPage({Key key, this.materialId})
      : super(key: key);
}

class _ReturnMaterialDetailSalesPageState
    extends State<ReturnMaterialDetailSalesPage> {
  ReturnMaterialSalesDetailsBloc returnMaterialDetailbloc =
      ReturnMaterialSalesDetailsBloc();

  ReturnMaterialDetailSalesModel asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    returnMaterialDetailbloc.fetchReturnmaterialList(widget.materialId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    returnMaterialDetailbloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        iconTheme: IconThemeData(color: kBlackColor),
        title: Text("Details"),
        titleTextStyle: TextStyle(
            color: kBlackColor, fontSize: 18, fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder<ReturnMaterialDetailSalesModel>(
        stream: returnMaterialDetailbloc.returnMaterialDetailStream,
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
          } else if (s.data.returnMaterialProductDetails.length == 0) {
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                s.data.message,
              ),
            );
          } else {
            asyncSnapshot = s.data;

            return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 40,
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    border: Border(
                                        left: BorderSide(color: Colors.black),
                                        right: BorderSide(color: Colors.black),
                                        bottom: BorderSide(color: Colors.black),
                                        top: BorderSide(color: Colors.black)),
                                  ),
                                  child: Text('Product Name',
                                      //style: content1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white)),
                                  alignment: Alignment.center,
                                )),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    border: Border(
                                        right: BorderSide(color: Colors.black),
                                        bottom: BorderSide(color: Colors.black),
                                        top: BorderSide(color: Colors.black)),
                                  ),
                                  child: Text('Order Id',
                                      //style: content1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white)),
                                  alignment: Alignment.center,
                                )),
                            Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    border: Border(
                                        right: BorderSide(color: Colors.black),
                                        bottom: BorderSide(color: Colors.black),
                                        top: BorderSide(color: Colors.black)),
                                  ),
                                  child: Text('Model No', //style: content1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white)),
                                  alignment: Alignment.center,
                                )),
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  border: Border(
                                      right: BorderSide(color: Colors.black),
                                      bottom: BorderSide(color: Colors.black),
                                      top: BorderSide(color: Colors.black)),
                                ),
                                child: Text(
                                  'Qty', //style: content1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                                //alignment: Alignment.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      for (int i = 0;
                          i < asyncSnapshot.returnMaterialProductDetails.length;
                          i++)
                        AnimationConfiguration.staggeredList(
                          position: i,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Container(
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                                left:BorderSide(color: Colors.black),
                                                right: BorderSide(
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                          child: Text(
                                            '${asyncSnapshot.returnMaterialProductDetails[i].productName}',
                                            //style: content1,
                                            textAlign: TextAlign.center,
                                          ),
                                          alignment: Alignment.center,
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                          child: Text(
                                            '${asyncSnapshot.returnMaterialProductDetails[i].productId}',
                                            //style: content1,
                                            textAlign: TextAlign.center,
                                          ),
                                          alignment: Alignment.center,
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                          child: Text(
                                            '${asyncSnapshot.returnMaterialProductDetails[i].modelNoId}',
                                            //style: content1,
                                            textAlign: TextAlign.center,
                                          ),
                                          alignment: Alignment.center,
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                                right: BorderSide(
                                                    color: Colors.black),
                                                bottom: BorderSide(
                                                    color: Colors.black)),
                                          ),
                                          child: TextFormField(
                                              onChanged: (text) {},
                                              initialValue: asyncSnapshot
                                                  .returnMaterialProductDetails[
                                                      i]
                                                  .returnQty,
                                              maxLines: 1,
                                              enabled: false,
                                              textAlign: TextAlign.center,
                                              maxLength: 4,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                counter: Offstage(),
                                              )),
                                          // child: Text(
                                          //   '${data.orderDetails[i].invoiceQty}', //style: content1,
                                          //   textAlign:
                                          //   TextAlign
                                          //       .center,
                                          // ),
                                          alignment: Alignment.center,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ));
          }
        });
  }
}
