import 'dart:convert';

import 'package:desire_production/bloc/dispatchOrderDetailsListBloc.dart';
import 'package:desire_production/model/dispatchOrderDetailsModel.dart';
import 'package:desire_production/pages/warehouse/readyToDispatchListPage.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;


class DispatchOrderDetailsPage extends StatefulWidget {
  final orderId,customerId;
  final page;

  const DispatchOrderDetailsPage({Key key, this.orderId,this.customerId,this.page}) : super(key: key);

  @override
  _DispatchOrderDetailsPageState createState() => _DispatchOrderDetailsPageState();
}

class _DispatchOrderDetailsPageState extends State<DispatchOrderDetailsPage> {

  final DispatchOrderDetailsListBloc dispatchOrderDetailsListBloc = DispatchOrderDetailsListBloc();
  TextEditingController searchViewController = TextEditingController();
  TextEditingController invoiceController = TextEditingController();
  TextEditingController lrNoController = TextEditingController();
  TextEditingController eWayBillViewController = TextEditingController();
  AsyncSnapshot<DispatchOrderDetailsModel> asyncSnapshot;

  List<bool> check = [];
  bool checkAll = false;
  List<String> send = [];
  bool search = false;
  List<Data> _searchResult = [];
  List<Data> _list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dispatchOrderDetailsListBloc.fetchDispatchOrderDetailsList(widget.orderId);
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    dispatchOrderDetailsListBloc.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return widget.page == "warHouse" ? Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (b) => ReadyToDispatchListPage(page: 'warHouse',)), (route) => false): Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => ReadyToDispatchListPage(page: 'admin',)),);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            "Dispatch Orders Details List",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: _searchView(),
          ),
        ),
        body: _body(),
      ),
    );
  }


  Widget _body(){
    return RefreshIndicator(
        color: kPrimaryColor,
        onRefresh: (){
          return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => DispatchOrderDetailsPage(orderId: widget.orderId,page: widget.page,)), (route) => false);
        },
        child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                StreamBuilder<DispatchOrderDetailsModel>(
                    stream: dispatchOrderDetailsListBloc.dispatchOrderDetailsStream,
                    builder: (c, s) {
                      if (s.connectionState != ConnectionState.active) {
                        print("all connection");
                        return Container(height: 300,
                            alignment: Alignment.center,
                            child: Center(
                              heightFactor: 50, child: CircularProgressIndicator(
                              color: kPrimaryColor,
                            ),));
                      }
                      else if (s.hasError) {
                        print("as3 error");
                        return Container(height: 300,
                          alignment: Alignment.center,
                          child: Text("Error Loading Data",),);
                      }

                      else {
                        _list = s.data.data;
                        _list == null ? print("0"): print("Length"+ _list.length.toString());
                        for(int i=0; i<s.data.data.length; i++){
                          check.add(false);
                        }

                        print("object length ${s.data.data.length} ${check.length}");
                        return  _list == null ?  Center(
                          child: Text("No Items are ready to dispatch"),
                        ) : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _searchResult.length == 0 ?
                            Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            border: Border(top: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                          ),
                                          child: Checkbox(
                                            value: checkAll,
                                            checkColor:kPrimaryColor,
                                            activeColor: Colors.white,
                                            onChanged: (value) {
                                              setState(() {
                                                checkAll = value;
                                              });
                                              print("object remember $checkAll");
                                              if(checkAll == true){
                                                for(int i=0; i<s.data.data.length; i++){
                                                  check[i] = true;
                                                  send.add(s.data.data[i].wdId);
                                                }
                                              } else{
                                                for(int i=0; i<s.data.data.length; i++){
                                                  check[i] = false;
                                                  send = [];
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex:2,
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              border: Border(left: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                            ),
                                            child: Text('Customer Name', //style: content1,
                                                textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                            //alignment: Alignment.center,
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('Product Name', //style: content1,
                                                  textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                              alignment: Alignment.center,
                                            )
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('Order Number', //style: content1,
                                                  textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                              alignment: Alignment.center,
                                            )
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('Model No', //style: content1,
                                                  textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                              alignment: Alignment.center,
                                            )
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                            ),
                                            child: Text('Qty', //style: content1,
                                              textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                                            //alignment: Alignment.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  for(int i=0; i<s.data.data.length;i++)
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
                                                Container(
                                                  width: 50,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    //color: bg,
                                                    border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                                  ),
                                                  child: Checkbox(
                                                    value: check[i],
                                                    activeColor: kPrimaryColor,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        check[i] = value;
                                                      });
                                                      print("object remember ${check[i]}");
                                                      if(check[i] == true){
                                                        send.add(s.data.data[i].wdId);
                                                      } else{
                                                        send.remove(s.data.data[i].wdId);
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      //color: bg,
                                                      border: Border(left: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                                    ),
                                                    child: Text(s.data.data[i].customerName, //style: content1,
                                                      textAlign: TextAlign.center,),
                                                    //alignment: Alignment.center,
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                                      ),
                                                      child: Text('${s.data.data[i].productName}', //style: content1,
                                                        textAlign: TextAlign.center,),
                                                      alignment: Alignment.center,
                                                    )
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                                      ),
                                                      child: Text('${s.data.data[i].orderNumber}', //style: content1,
                                                        textAlign: TextAlign.center,),
                                                      alignment: Alignment.center,
                                                    )
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                                      ),
                                                      child: Text('${s.data.data[i].modelNo}', //style: content1,
                                                        textAlign: TextAlign.center,),
                                                      alignment: Alignment.center,
                                                    )
                                                ),
                                                Expanded(
                                                  flex: 1,

                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                                      ),
                                                      child: Text('${s.data.data[i].qty}', //style: content1,
                                                        textAlign: TextAlign.center,),
                                                      alignment: Alignment.center,
                                                    )
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ) :
                            Container(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            border: Border(top: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                          ),
                                          child: Checkbox(
                                            value: checkAll,
                                            checkColor:kPrimaryColor,
                                            activeColor: Colors.white,
                                            onChanged: (value) {
                                              setState(() {
                                                checkAll = value;
                                              });
                                              print("object remember $checkAll");
                                              if(checkAll == true){
                                                for(int i=0; i<s.data.data.length; i++){
                                                  check[i] = true;
                                                  send.add(s.data.data[i].wdId);
                                                }
                                              } else{
                                                for(int i=0; i<s.data.data.length; i++){
                                                  check[i] = false;
                                                  send = [];
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                        Expanded(
                                          flex:2,
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              border: Border(left: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                            ),
                                            child: Text('Customer Name', //style: content1,
                                                textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                            //alignment: Alignment.center,
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('Product Name', //style: content1,
                                                  textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                              alignment: Alignment.center,
                                            )
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('Order Number', //style: content1,
                                                  textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                              alignment: Alignment.center,
                                            )
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('Model No', //style: content1,
                                                  textAlign: TextAlign.center,style: TextStyle(color: Colors.white)),
                                              alignment: Alignment.center,
                                            )
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            width: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: kPrimaryColor,
                                              border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                            ),
                                            child: Text('Qty', //style: content1,
                                              textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                                            //alignment: Alignment.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  for(int i=0; i<_searchResult.length;i++)
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
                                                Container(
                                                  width: 50,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    //color: bg,
                                                    border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                                  ),
                                                  child: Checkbox(
                                                    value: check[i],
                                                    activeColor: kPrimaryColor,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        check[i] = value;
                                                      });
                                                      print("object remember ${check[i]}");
                                                      if(check[i] == true){
                                                        send.add(_searchResult[i].wdId);
                                                      } else{
                                                        send.remove(_searchResult[i].wdId);
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      //color: bg,
                                                      border: Border(left: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                                    ),
                                                    child: Text(_searchResult[i].customerName, //style: content1,
                                                      textAlign: TextAlign.center,),
                                                    //alignment: Alignment.center,
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                                      ),
                                                      child: Text('${_searchResult[i].productName}', //style: content1,
                                                        textAlign: TextAlign.center,),
                                                      alignment: Alignment.center,
                                                    )
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                                      ),
                                                      child: Text('${_searchResult[i].orderNumber}', //style: content1,
                                                        textAlign: TextAlign.center,),
                                                      alignment: Alignment.center,
                                                    )
                                                ),
                                                Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                                      ),
                                                      child: Text('${_searchResult[i].modelNo}', //style: content1,
                                                        textAlign: TextAlign.center,),
                                                      alignment: Alignment.center,
                                                    )
                                                ),
                                                Expanded(
                                                    flex: 1,

                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                                      ),
                                                      child: Text('${_searchResult[i].qty}', //style: content1,
                                                        textAlign: TextAlign.center,),
                                                      alignment: Alignment.center,
                                                    )
                                                ),

                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                    }
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: invoiceController,
                  decoration: InputDecoration(
                    labelText: "Invoice No",
                    hintText: "Enter Invoice No.",
                    labelStyle: TextStyle(color: kPrimaryColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey
                      )
                    ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: kPrimaryColor
                          )
                      )

                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: lrNoController,
                  decoration: InputDecoration(
                    labelText: "LR No",
                    hintText: "Enter LR No.",
                    labelStyle: TextStyle(color: kPrimaryColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey
                      )
                    ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: kPrimaryColor
                          )
                      )

                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  controller: eWayBillViewController,
                  decoration: InputDecoration(
                    labelText: "EWay Bill No",
                    hintText: "Enter EWay Bill No.",
                    labelStyle: TextStyle(color: kPrimaryColor),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey
                      )
                    ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: kPrimaryColor
                          )
                      )

                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                    style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor
                    ),
                    onPressed: (){
                  if(invoiceController.text.isEmpty && lrNoController.text.isEmpty && eWayBillViewController.text.isEmpty){
                    print("Field cant be empty");
                  }
                  else {
                    sendToDispatch(send.toString(), widget.orderId, widget.customerId);
                  }
                }, child: Text("Submit"))
              ],
            )
        )
    );
  }

  sendToDispatch(String wdId, String orderId, String customerId) async{
    print("WD Id "+wdId);
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator(color: kPrimaryColor,)),);
    pr.show();
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/ProductionApiController/submitDispatch"), body: {
      'secretkey':Connection.secretKey,
      'dispatch_ids':"$wdId",
      'order_id': orderId,
      "customer_id": customerId,
      "invoice_no": invoiceController.text,
      "lr_no": lrNoController.text,
      "eway_bill_no": eWayBillViewController.text,
    });
    print("object ${response.body}");

    var results = json.decode(response.body);
    print("object $results");
    pr.hide();
    if (results['status'] == true) {
      print("user details ${results['data']}");
      Alerts.showAlertAndBack(context, "Success", "Successfully Sent To Dispatch");
    } else {
      Alerts.showAlertAndBack(context, "Something Went Wrong", "Could not send to Dispatch",);
    }
  }

  Widget _searchView() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.black,),
          SizedBox(width: 8,),
          Expanded(
            child: TextField(
              controller: searchViewController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              onChanged: (value){
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

    _list.forEach((exp) {
      if (exp.modelNo.contains(text))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }
}
