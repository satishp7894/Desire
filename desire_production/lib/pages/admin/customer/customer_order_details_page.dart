import 'dart:convert';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/customer_order_bloc.dart';
import 'package:desire_production/model/order_model.dart';
import 'package:desire_production/pages/admin/customer/customer_list_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/drawer_admin.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

import 'edit_order_page.dart';
import 'order_detail_page.dart';


class CustomerOrderDetailPage extends StatefulWidget {

  final String customerId;
  final String customerName;
  const CustomerOrderDetailPage({@required this.customerId, @required this.customerName,});

  @override
  _CustomerOrderDetailPageState createState() => _CustomerOrderDetailPageState();

}

class _CustomerOrderDetailPageState extends State<CustomerOrderDetailPage> {

  final bloc = CustomerOrderBloc();

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    bloc.fetchCustomerOrders(widget.customerId);
  }

  checkConnectivity() async{
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerListPage()), (route) => false);
      },
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              // leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
              //   return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerListPageOrder(salesId: widget.salesId,)), (route) => false);
              // },),
              title: Text("Customer Orders", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
              centerTitle: true,
              leading: Builder(
                builder: (c){
                  return IconButton(icon: Icon(Icons.list, color: Colors.black,), onPressed: (){
                    Scaffold.of(c).openDrawer();
                  },);
                },
              ),
              actions: [
                IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
                  Navigator.of(context).pop();
                  },),
              ],
            ),
            drawer: DrawerAdmin(),
            body: _body(),
          )),
    );
  }

  Widget _body(){
    return RefreshIndicator(
      onRefresh: (){
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CustomerOrderDetailPage(customerId: widget.customerId, customerName: widget.customerName,)), (route) => false);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
              child: Text("Customer Name: ${widget.customerName}",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),),
            ),
            StreamBuilder<OrderModel>(
                stream: bloc.newCustomerOrderStream,
                builder: (c, s) {
                  if (s.connectionState != ConnectionState.active) {
                    print("all connection");
                    return Container(height: 300,
                        alignment: Alignment.center,
                        child: Center(
                          heightFactor: 50, child: CircularProgressIndicator(),));
                  }
                  if (s.hasError) {
                    print("as3 error");
                    return Container(height: 300,
                      alignment: Alignment.center,
                      child: Text("Error Loading Data",),);
                  }
                  if (s.data.order == null) {
                    print("as3 empty");
                    return Container(height: 300,
                      alignment: Alignment.center,
                      child: Text("No Orders Found",),);
                  }
                  print("object length ${s.data.order.length}");

                  List<Order> orders =[];

                  for(int i=0; i<s.data.order.length;i++){
                      orders.add(s.data.order[i]);
                  }
                  return ListView.separated(
                      padding: EdgeInsets.all(20),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: orders.length,
                      itemBuilder: (c, i) {
                        return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (builder) => OrderDetailPage(id: widget.customerId, orderId: orders[i].orderId, orderName: orders[i].orderNumber, totalAmount: orders[i].orderAmount, totalQty: orders[i].totalOrderQuantity, orderCount: 0, status: false, name: widget.customerName, )));
                              },
                                child: _cartCard(orders[i]))
                        );
                      },
                      separatorBuilder: (c, i) {
                        return Divider(indent: 20, color: Colors.grey.withOpacity(.8),);
                      });
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartCard(Order product){
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(Icons.list, color: Colors.black,),
            ),
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Number:\n${product.orderNumber}", style: TextStyle(color: Colors.black, fontSize: 16)),
            SizedBox(height: 10),
            Text("Total Amount: ${product.orderAmount}",style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
            SizedBox(height: 10,),
            Text("Total Quantity: ${product.totalOrderQuantity}",style: Theme.of(context).textTheme.bodyText1),
            SizedBox(height: 10,),
            Text("Status: ${product.deliveryStatus}",style: Theme.of(context).textTheme.bodyText1),

          ],
        ),
        product.departmentStatus == "1" ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(icon: Icon(Icons.edit_outlined), onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (builder) => EditOrderPage(customerId: widget.customerId, customerName: widget.customerName, orderId: product.orderId, orderName: product.orderNumber,)));
            }),
            IconButton(icon: Icon(Icons.next_plan_outlined, color: kPrimaryColor,), onPressed: (){
              product.editOrderApproval == "0" ? Alerts.showAlertAndBack(context, "Approval Pending", "Your Order is not approved yet.") :
              sendToProduction(widget.customerId,product.orderId);
            })
          ],
        ) : Container(),
      ],
    );
  }

  sendToProduction(String customerId, String orderId) async{
    print("object ids $customerId $orderId");
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    var response;
    response = await http.post(Uri.parse(Connection.sendToProduction), body: {
      'secretkey':Connection.secretKey,
      'customerid':customerId,
      'order_id':orderId,
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true){
      print("object send to production");
      Alerts.showAlertProduction(context, widget.customerId, widget.customerName,);
    } else{
      Alerts.showAlertAndBack(context, "Kyc Approved", "Something went wrong");
    }
  }

}
