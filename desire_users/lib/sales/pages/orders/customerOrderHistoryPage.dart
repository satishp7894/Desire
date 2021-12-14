import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/order_bloc.dart';
import 'package:desire_users/models/order_model.dart';
import 'package:desire_users/pages/cart/order_history_page.dart';
import 'package:desire_users/sales/pages/orders/orderDetailsByIdPage.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomerOrderHistoryPage extends StatefulWidget {
  final customerId;
  final customerName;
  const CustomerOrderHistoryPage({Key key, this.customerId, this.customerName}) : super(key: key);

  @override
  _CustomerOrderHistoryPageState createState() => _CustomerOrderHistoryPageState();
}

class _CustomerOrderHistoryPageState extends State<CustomerOrderHistoryPage> {
  final OrderBloc orderBloc = OrderBloc();

  bool refresh = false;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    orderBloc.fetchOrder(widget.customerId);
  }

  checkConnectivity() async{
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }
  String mob;
  String id ;
  String name;
  String email;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          iconTheme: IconThemeData(
              color: kBlackColor
          ),
          title: Column(
            children: [
           widget.customerName == null ?Text("Customer")  :  Text(widget.customerName,style: TextStyle(color: Colors.black),),
              Text("Orders",style: TextStyle(color: Colors.black),),
            ],
          ),
          centerTitle: true,
        ),
        body: RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: (){
            return Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => CustomerOrderHistoryPage(customerId: widget.customerId,customerName: widget.customerName,)));
          },
          child: _body(),
        )
    );
  }
  AsyncSnapshot<OrderModel> asyncSnapshot;
  Widget _body(){
    return StreamBuilder<OrderModel>(
        stream: orderBloc.newOrderStream,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(height: 600,
                alignment: Alignment.center,
                child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text("Please wait...",style: TextStyle(color: kBlackColor,fontSize: 16),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text("Fetching your Orders",style: TextStyle(color: kBlackColor,fontSize: 16),),
                    ),
                  ],
                ),));
          }
          else if (s.hasError) {
            print("as3 error");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("Error Loading Data",),);
          }
          else {
            asyncSnapshot = s;
            return asyncSnapshot.data.data.length == 0 ? Center(child: Text("No Orders",style: TextStyle(color: kBlackColor,fontSize: 20),),):
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  ...List.generate(asyncSnapshot.data.data.length, (index) => _cartCard(asyncSnapshot.data.data[index]))
                ],
              ),
            );
          }

        }
    );
  }

  Widget _cartCard(Data data){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Card(
        color: kWhiteColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order Number", style: TextStyle(color: kSecondaryColor, fontSize: 14,fontWeight: FontWeight.bold)),
                        Text("Total Amount",style: TextStyle(fontWeight: FontWeight.bold, color: kSecondaryColor,fontSize: 14)),
                        Text("Total Quantity",style: TextStyle(fontWeight: FontWeight.bold, color: kSecondaryColor,fontSize: 14)),
                        Text("Order Date",style: TextStyle(fontWeight: FontWeight.bold, color: kSecondaryColor,fontSize: 14)),
                        Text("Shipping Status", style: TextStyle(color: kSecondaryColor, fontSize: 14,fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(" : ", style: TextStyle(color: kBlackColor, fontSize: 14,fontWeight: FontWeight.bold)),
                        Text(" : ",style: TextStyle(fontWeight: FontWeight.bold, color: kBlackColor,fontSize: 14)),
                        Text(" : ",style: TextStyle(fontWeight: FontWeight.bold, color: kBlackColor,fontSize: 14)),
                        Text(" : ",style: TextStyle(fontWeight: FontWeight.bold, color: kBlackColor,fontSize: 14)),
                        Text(" : ", style: TextStyle(color:kBlackColor, fontSize: 14,fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${data.orderNumber}", style: TextStyle(fontWeight: FontWeight.bold,color:kBlackColor, fontSize: 14)),
                        Text("₹.${data.orderAmount} /-", style: TextStyle(fontWeight: FontWeight.bold,color:kBlackColor, fontSize: 14)),
                        Text("${data.totalOrderQuantity}", style: TextStyle(fontWeight: FontWeight.bold,color:kBlackColor, fontSize: 14)),
                        Text("${data.orderDate}".split(" ").first, style: TextStyle(fontWeight: FontWeight.bold,color:kBlackColor, fontSize: 14)),
                        Text(" ${data.deliveryStatus}", style: TextStyle(fontWeight: FontWeight.bold,color: kBlackColor, fontSize: 14)),
                      ],
                    ),

                  ],
                ),
                SizedBox(height: 20, child: Divider(color: Colors.grey,height: 0.0,thickness: 0.5,),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: kPrimaryColor)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(" Download Invoice", style: TextStyle(color: kBlackColor, fontSize: 14)),
                          )),
                      onTap: (){
                      //  getInvoice(data.orderId);

                      },
                    ),
                    GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderDetailsByIdPage(
                            customerId: widget.customerId,
                            orderId: data.orderId,
                            orderName: data.orderNumber,

                          )));
                        },
                        child:  Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: kPrimaryColor)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("View Order Details",style: TextStyle(color: kBlackColor, fontSize: 14)),
                            ))
                    )],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
