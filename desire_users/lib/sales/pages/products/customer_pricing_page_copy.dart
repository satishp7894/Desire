import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/models/modelList_model.dart';
import 'package:desire_users/sales/bloc/model_list_bloc.dart';
import 'package:desire_users/sales/pages/customer/customer_list_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/default_button.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/services/connection_sales.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CustomerPricingPage extends StatefulWidget {
  final String customerId;
  final String customerName;
  final String salesId;
  final String name, email;

  const CustomerPricingPage(
      {@required this.customerId,
      @required this.salesId,
      @required this.customerName,
      this.name,
      this.email});

  @override
  _CustomerPricingPageState createState() => _CustomerPricingPageState();
}

class _CustomerPricingPageState extends State<CustomerPricingPage> {
  final modelBloc = ModelListBloc();

  List<bool> check = [];
  bool checkAll = false;
  List<ModelList> send = [];

  List<TextEditingController> newPrice = [];
  AsyncSnapshot<ModelListModel> as;
  @override
  void initState() {
    super.initState();
    checkConnectivity();
    print("customers ${widget.customerId} ${widget.salesId}");
    modelBloc.fetchModelList(widget.customerId);
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
    modelBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kWhiteColor,
        iconTheme: IconThemeData(
          color: kBlackColor
        ),
        title: Text(
          "Customer Pricing List",
          style: TextStyle(color: Colors.black, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: _body(),
          bottomNavigationBar:  SafeArea(
            child: GestureDetector(
              onTap: (){
                print("send value ${send.length}");
                if (send.length > 0) {
                  submitPricing();
                } else {
                  final snackBar = SnackBar(
                      content: Text(
                        "No Products Selected",
                        textAlign: TextAlign.center,
                      ));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: kPrimaryColor,
                  ),

                  height: 50,
                  child: Center(child: Text("SAVE",textAlign: TextAlign.center,style: TextStyle(color: kWhiteColor,fontSize: 16),)),
                ),
              ),
            ),
          ),
    ));
  }

  Widget _body() {
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () {
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (builder) => CustomerPricingPage(
                      customerId: widget.customerId,
                      salesId: widget.salesId,
                      email: "${widget.name}",
                      name: "${widget.email}",
                  customerName: widget.customerName,
                    )),
            (route) => false);
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            StreamBuilder<ModelListModel>(
                stream: modelBloc.modelListStream,
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
                  }
                  if (s.hasError) {
                    print("as3 error");
                    return Container(
                      height: 300,
                      alignment: Alignment.center,
                      child: Text(
                        "Error Loading Data",
                      ),
                    );
                  }
                  if (s.data.modelList.length == 0) {
                    print("as3 empty");
                    return Container(
                      height: 300,
                      alignment: Alignment.center,
                      child: Text(
                        "No Details Found",
                      ),
                    );
                  }
                  as = s;

                  if (check.length == 0) {
                    for (int i = 0; i < s.data.modelList.length; i++) {
                      if (s.data.modelList[i].checked == true) {
                        check.add(true);
                        send.add(s.data.modelList[i]);
                      } else {
                        check.add(false);
                      }

                      newPrice.add(TextEditingController(
                          text: s.data.modelList[i].listPrice));
                      print("checked value ${check[i]}");
                    }
                  }
                  print(
                      "object length ${s.data.modelList.length} ${check.length}");

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 50,
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(),
                                    child: Checkbox(
                                      value: checkAll,
                                      checkColor: Colors.white,
                                      activeColor: kPrimaryColor,
                                      onChanged: (value) {
                                        setState(() {
                                          checkAll = value;
                                        });
                                        print("object remember $checkAll");
                                        if (checkAll == true) {
                                          for (int i = 0;
                                              i < s.data.modelList.length;
                                              i++) {
                                            check[i] = true;
                                            send.add(s.data.modelList[i]);
                                          }
                                        } else {
                                          for (int i = 0;
                                              i < s.data.modelList.length;
                                              i++) {
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
                                        child: Text(
                                          'Model Name', //style: content1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        alignment: Alignment.center,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text(
                                          'MRP', //style: content1,
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        alignment: Alignment.center,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text(
                                          'Sales Price', //style: content1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        alignment: Alignment.center,
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        child: Text(
                                          'New Price', //style: content1,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: kPrimaryColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        alignment: Alignment.center,
                                      )),
                                ],
                              ),
                            ),
                            for (int i = 0; i < s.data.modelList.length; i++)
                              s.data.modelList.length == 0
                                  ? Container(
                                      height: 300,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "No Orders Found",
                                      ),
                                    )
                                  : AnimationConfiguration.staggeredList(
                                      position: i,
                                      duration:
                                          const Duration(milliseconds: 375),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: Container(
                                            height: 50,
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: Checkbox(
                                                    value: check[i],
                                                    activeColor: kPrimaryColor,
                                                    onChanged: (value) {
//check.clear();
                                                      setState(() {
                                                        check[i] = value;
                                                      });
                                                      print(
                                                          "object remember ${check[i]}");
                                                      if (check[i] == true) {
                                                        print("object added");
                                                        send.add(s
                                                            .data.modelList[i]);
                                                      } else {
                                                        print("object removed");
                                                        send.remove(s
                                                            .data
                                                            .modelList[i]
                                                            .modelNoId);
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: Text(
                                                        '${s.data.modelList[i].modelNo}',
                                                        style: TextStyle(
                                                            color: kBlackColor,
                                                            fontSize:
                                                                12), //style: content1,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: Text(
                                                        '${s.data.modelList[i].customerPrice}',
                                                        style: TextStyle(
                                                            color: kBlackColor,
                                                            fontSize:
                                                                12), //style: content1,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: Text(
                                                        '${s.data.modelList[i].salesPrice}',
                                                        style: TextStyle(
                                                            color: kBlackColor,
                                                            fontSize:
                                                                12), //style: content1,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
                                                Expanded(
                                                    flex: 2,
                                                    child: Container(
                                                      child: TextFormField(
                                                        cursorColor:
                                                            kBlackColor,
                                                        controller: newPrice[i],
                                                        style: TextStyle(
                                                            color: kBlackColor,
                                                            fontSize: 12),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                          LengthLimitingTextInputFormatter(
                                                              4)
                                                        ],
                                                        decoration: InputDecoration(
                                                            focusedBorder:
                                                                UnderlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                kPrimaryColor))),
//style: content1,
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                    )),
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
                }),
          ],
        ),
      ),
    );
  }

  submitPricing() async {
    List<Map<String, String>> pricingList = [];
    for (int i = 0; i < send.length; i++) {
      String price;
      for (int j = 0; j < newPrice.length; j++) {
        if (send[i].modelNoId == as.data.modelList[j].modelNoId) {
          price = newPrice[i].text;
        }
      }
      print(
          "object values to be added ${send[i].modelNo} ${send[i].listOldPrice} ${newPrice[i].text} $price");
      var prices = {
        '"model_no_id"': "\"${send[i].modelNoId}\"",
        '"price"': "\"$price\"",
        '"old_price"': send[i].listOldPrice == ""
            ? "\"${newPrice[i].text}\""
            : "\"${send[i].listOldPrice}\"",
      };
      pricingList.add(prices);
    }

    print("pricing list ${pricingList}");
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),
    );
    pr.show();
    var response = await http
        .post(Uri.parse(ConnectionSales.postCustomerPriceList), body: {
      'secretkey': Connection.secretKey,
      "sales_id": widget.salesId == null ? "2" : widget.salesId,
      "customer_id": widget.customerId,
      "terms_and_condition": "${widget.customerName} price changed",
      "product_list": "$pricingList",
      "price_list": "TRUE",
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true) {
      final snackBar = SnackBar(
          content: Text(
        "Status Updated",
        textAlign: TextAlign.center,
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => CustomerPricingPage(
                  customerId: widget.customerId, salesId: widget.salesId,customerName: widget.customerName,)),
          (Route<dynamic> route) => false);
    } else {
      print('error deleting address');
      Alerts.showAlertAndBack(context, 'Error', 'Address not Deleted.');
    }
  }
}
