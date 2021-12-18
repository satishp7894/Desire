
import 'dart:convert';

import 'package:desire_production/bloc/modelWiseListBloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/modelNoWiseListModel.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;

class DailyProductionListByModelNumber extends StatefulWidget {

  final modelNo , modelNoId, dailyProductionId;
  const DailyProductionListByModelNumber({Key key, this.modelNo, this.modelNoId, this.dailyProductionId}) : super(key: key);

  @override
  _DailyProductionListByModelNumberState createState() => _DailyProductionListByModelNumberState();
}

class _DailyProductionListByModelNumberState extends State<DailyProductionListByModelNumber> {


  final ModelWiseListBloc modelWiseListBloc = ModelWiseListBloc();
  TextEditingController searchViewController = TextEditingController();
  AsyncSnapshot<ModelNoWiseListModel> asyncSnapshot;

  List<bool> check = [];
  bool checkAll = false;
  List<String> send = [];
  bool search = false;
  List<Data> _searchResult = [];
  List<Data> _order = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modelWiseListBloc.fetchModelWiseProductionOrderList(widget.modelNoId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    modelWiseListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: Text("Model No. "+widget.modelNo,style: TextStyle(
          color: Colors.black
        ),),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: _searchView(),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: (){
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => DailyProductionListByModelNumber(
          dailyProductionId: widget.dailyProductionId,
          modelNo: widget.modelNo,
          modelNoId: widget.modelNoId,

        )), (route) => false);
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: StreamBuilder<ModelNoWiseListModel>(
            stream: modelWiseListBloc.modelWiseDailyProductionListStream,
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
              if (s.hasError) {
                print("as3 error");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("Error Loading Data",),);
              }
              if (s.data.data == null) {
                print("as3 empty");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("No Orders Found",),);
              }

              asyncSnapshot = s;
              _order = s.data.data;

              for(int i=0; i<s.data.data.length; i++){
                check.add(false);
              }

              print("object length ${s.data.data.length} ${check.length}");

              return _order.length == 0 ? Center(
                heightFactor: 20,
                child: Text("No Orders of Model No - ${widget.modelNo} in Production",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),): Container(
                padding: EdgeInsets.all(10),
                child: Column(
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
                                          send.add(s.data.data[i].orderdetailId);
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
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                      ),
                                      child: Text('Customer Name', //style: content1,
                                        textAlign: TextAlign.center,style: TextStyle(color: Colors.white,),),
                                      alignment: Alignment.center,
                                    )
                                ),
                                Expanded(
                                  flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                      ),
                                      child: Text('Product Name', //style: content1,
                                        textAlign: TextAlign.center,style: TextStyle(color: Colors.white,),),
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
                                      child: Text('Qty', //style: content1,
                                        textAlign: TextAlign.center,style: TextStyle(color: Colors.white,),),
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
                                      child: Text('Sticks', //style: content1,
                                        textAlign: TextAlign.center,style: TextStyle(color: Colors.white,),),
                                      alignment: Alignment.center,
                                    )
                                ),
                              ],
                            ),
                          ),

                          for(int i=0; i<s.data.data.length;i++)
                            s.data.data.length == 0 ? Container(height: 300,
                              alignment: Alignment.center,
                              child: Text("No Orders Found",),) :
                            AnimationConfiguration.staggeredList(
                              position: i,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Container(
                                    height: 40,
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
                                                send.add(s.data.data[i].orderdetailId);
                                              } else{
                                                send.remove(s.data.data[i].orderdetailId);
                                              }
                                            },
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('${s.data.data[i].customerName}', //style: content1,
                                                textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold),),
                                              alignment: Alignment.center,
                                            )
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('${s.data.data[i].productName}', //style: content1,
                                                textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold),
                                              ),
                                              alignment: Alignment.center,
                                            )
                                        ),Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('${s.data.data[i].productQuantity}', //style: content1,
                                                textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold),
                                              ),
                                              alignment: Alignment.center,
                                            )
                                        ),Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('${s.data.data[i].perBoxStick}', //style: content1,
                                                textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold),
                                              ),
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
                                          send.add(s.data.data[i].orderdetailId);
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
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                      ),
                                      child: Text('Customer Name', //style: content1,
                                        textAlign: TextAlign.center,style: TextStyle(color: Colors.white,),),
                                      alignment: Alignment.center,
                                    )
                                ),
                                Expanded(
                                    flex: 3,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                      ),
                                      child: Text('Product Name', //style: content1,
                                        textAlign: TextAlign.center,style: TextStyle(color: Colors.white,),),
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
                                      child: Text('Qty', //style: content1,
                                        textAlign: TextAlign.center,style: TextStyle(color: Colors.white,),),
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
                                      child: Text('Sticks', //style: content1,
                                        textAlign: TextAlign.center,style: TextStyle(color: Colors.white,),),
                                      alignment: Alignment.center,
                                    )
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
                                    height: 40,
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
                                                send.add(_searchResult[i].orderdetailId);
                                              } else{
                                                send.remove(_searchResult[i].orderdetailId);
                                              }
                                            },
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('${_searchResult[i].customerName}',style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold),//style: content1,
                                                textAlign: TextAlign.center,),
                                              alignment: Alignment.center,
                                            )
                                        ),
                                        Expanded(
                                          flex: 3,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('${_searchResult[i].productName}',style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold), //style: content1,
                                                textAlign: TextAlign.center,),
                                              alignment: Alignment.center,
                                            )
                                        ), Expanded(
                                          flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('${_searchResult[i].productQuantity}',style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold), //style: content1,
                                                textAlign: TextAlign.center,),
                                              alignment: Alignment.center,
                                            )
                                        ), Expanded(
                                          flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('${_searchResult[i].perBoxStick}',style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.bold), //style: content1,
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
                    send.length > 0 ? Padding(
                      padding: const EdgeInsets.all(50),
                      child: DefaultButton(
                        text: "Submit",
                        press: () async{
                           sendToWareHouse(send.toString());
                        },
                      ),
                    ) : Container()
                  ],
                ),
              );
            }
        ),
      ),
    );
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

    _order.forEach((exp) {
      if (exp.productName.contains(text))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }

  sendToWareHouse(String orderDetailId) async{
    print("Order D Id "+orderDetailId);
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator(color: kPrimaryColor,)),);
    pr.show();
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/ProductionApiController/dailyProductionToWarehouse"), body: {
      'secretkey':Connection.secretKey,
      'id':"$orderDetailId",
      'model_no_id': widget.modelNoId,
      "daily_production_id": widget.dailyProductionId,
      "production_status": "1"
    });
    print("object ${response.body}");

    var results = json.decode(response.body);
    print("object $results");
    pr.hide();
    if (results['status'] == true) {
      print("user details ${results['data']}");
      Alerts.showAlertAndBack(context, "Success", "Successfully Order Sent To WareHouse");
    } else {
      Alerts.showAlertAndBack(context, "Something Went Wrong", "Could not send to Warehouse",);
    }
  }


}
