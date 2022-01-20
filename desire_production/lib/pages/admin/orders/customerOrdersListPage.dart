import 'dart:convert';

import 'package:desire_production/bloc/allCustomerOrdersBloc.dart';
import 'package:desire_production/model/customerOrdersModel.dart';
import 'package:desire_production/pages/admin/dispatchlist/orderDetailsByIdPage.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class CustomerOrdersListPage extends StatefulWidget {

  final salesManId;
  final salesManName;
  const CustomerOrdersListPage({Key key,this.salesManId,this.salesManName}) : super(key: key);

  @override
  _CustomerOrdersListPageState createState() => _CustomerOrdersListPageState();
}

class _CustomerOrdersListPageState extends State<CustomerOrdersListPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final AllCustomerOrderBloc allCustomerOrderBloc = AllCustomerOrderBloc();
  String salesManId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("SALESMAN ID :- "+widget.salesManId);

    allCustomerOrderBloc.fetchAllCustomerOrders(widget.salesManId);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    allCustomerOrderBloc.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: kWhite,
        iconTheme: IconThemeData(
          color: kBlackColor
        ),
        title: Text("Customer Orders",style: TextStyle(
          color: kBlackColor
        ),),
        centerTitle: true,
      ),
      body:  body()
    );
  }
  AsyncSnapshot<CustomerOrdersModel> asyncSnapshot;
  Widget body(){
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: (){
        return Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => CustomerOrdersListPage(
          salesManId: widget.salesManId,
          salesManName: widget.salesManName,

        )));
      },
      child: StreamBuilder<CustomerOrdersModel>(
          stream: allCustomerOrderBloc.allCustomerOrderStream,
          builder: (c,s){
            if (s.connectionState != ConnectionState.active) {
              print("all connection");
              return Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: kPrimaryColor,),
                  SizedBox(height: 10,),
                  Text("Please Wait....."),
                  SizedBox(height: 10,),
                  Text("Fetching All Customer Order's")
                ],
              ),);
            }
            else if (s.hasError) {
              print("as3 error");
              return Container(height: 300,
                alignment: Alignment.center,
                child: Text("Error Loading Data",),);
            }
            else if(s.data.data != null && s.data.data.length == 0 ){
              print("as3 error");
              return Container(height: 300,
                alignment: Alignment.center,
                child: Text("No Data Found",),);
            }
            else {
              asyncSnapshot = s;
             return asyncSnapshot.data.data != null && asyncSnapshot.data.data.length  == 0 ? ListView.builder(
                 shrinkWrap: true,
                 itemCount: asyncSnapshot.data.data.length,
                 itemBuilder: (c,i){
                   return Padding(
                     padding: const EdgeInsets.only(left: 5.0,right: 5,top: 5,bottom: 5),
                     child: Card(
                       borderOnForeground: true,
                       shadowColor: kSecondaryColor,
                       child: Padding(
                         padding: const EdgeInsets.all(10.0),
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text("Customer Name : "+ asyncSnapshot.data.data[i].customerName.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold)),
                             SizedBox(height: 10,),
                             Text("Order Number : "+ asyncSnapshot.data.data[i].orderNumber,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: kPrimaryColor),),
                             SizedBox(height: 10,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text("Quantity : ${asyncSnapshot.data.data[i].totalOrderQuantity}",style: TextStyle(fontWeight: FontWeight.bold),),
                                 Text("Ordered on : " + "${asyncSnapshot.data.data[i].orderDate.split(" ").first}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),

                               ],
                             ),
                             SizedBox(height: 10,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text("Total Amount : ${asyncSnapshot.data.data[i].orderAmount}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                                 Text("Status : "+asyncSnapshot.data.data[i].deliveryStatus,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.green),),

                               ],
                             ),
                             SizedBox(height: 10,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 TextButton(
                                     style:  TextButton.styleFrom(
                                       backgroundColor: kPrimaryColor,
                                     ),
                                     onPressed: (){

                                       Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderDetailsByIdPage(
                                         customerId: asyncSnapshot.data.data[i].customerId,
                                         customerName: asyncSnapshot.data.data[i].customerName,
                                         orderId: asyncSnapshot.data.data[i].orderId,
                                         orderName: asyncSnapshot.data.data[i].orderNumber,

                                       )));



                                     }, child: Text("View Order Details",style: TextStyle(color: kWhite),)),
                                 asyncSnapshot.data.data[i].departmentStatus  == "1" ?
                                 TextButton(
                                     style:  TextButton.styleFrom(
                                       backgroundColor: kSecondaryColor,
                                     ),
                                     onPressed: (){
                                       sendToDailyOrder(asyncSnapshot.data.data[i].customerId, asyncSnapshot.data.data[i].orderId);
                                     }, child: Text("Send To Production",style: TextStyle(color: kWhite),)) :Container()


                               ],
                             )
                           ],
                         ),
                       ),
                     ),
                   );
                 }):Container();
           }

          }),
    );
  }

  sendToDailyOrder(String customerId , String orderId)async {
    var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/SalesApiController/sendToDailyOrder"),
        body: {
          'secretkey': Connection.secretKey,
          'customer_id': customerId,
          "order_id":    orderId
        });
    print("Customer Id : "+customerId);
    print("Order Id : "+orderId);
    print("object ${response.body}");

    var results = json.decode(response.body);
    if (results["status"] == true) {
      final snackBar =
      SnackBar(content: Text("Order Sent to Production Successfully"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
       refreshPage();
    }
    else if (results["status"] == false) {
      final snackBar =
      SnackBar(content: Text(results["message"]));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else {
      final snackBar =
      SnackBar(content: Text(results["message"]));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }
  }

  refreshPage(){
    return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return CustomerOrdersListPage(
        salesManId: widget.salesManId,
        salesManName: widget.salesManName,
      );
    }));
  }

}



