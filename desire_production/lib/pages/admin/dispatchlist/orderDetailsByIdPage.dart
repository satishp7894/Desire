import 'package:desire_production/bloc/orderDetailsByIdBloc.dart';
import 'package:desire_production/model/orderDetailsByIdModel.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';


class OrderDetailsByIdPage extends StatefulWidget {
  final customerName , customerId;
  final orderId, orderName;


  const OrderDetailsByIdPage({Key key,this.customerId,this.customerName, this.orderId, this.orderName}) : super(key: key);

  @override
  _OrderDetailsByIdPageState createState() => _OrderDetailsByIdPageState();
}

class _OrderDetailsByIdPageState extends State<OrderDetailsByIdPage> {

  final OrderDetailsByIdBloc orderDetailsByIdBloc = OrderDetailsByIdBloc();
  AsyncSnapshot<OrderDetailsByIdModel>asyncSnapshot;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    orderDetailsByIdBloc.fetchOrderDetailsById(widget.orderId);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    orderDetailsByIdBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: kBlackColor
        ),
        title:widget.customerName == null ?
        Text("Order No. : " + widget.orderName,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: kBlackColor),): Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.customerName,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: kBlackColor),),
            Text("Order No. : " + widget.orderName,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: kBlackColor),),
          ],
        ),
      ),
      body: StreamBuilder<OrderDetailsByIdModel>(
        stream: orderDetailsByIdBloc.orderDetailsByIdStream,
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
                Text("Fetching Order Details")
              ],
            ),);
          }
          else if (s.hasError) {
            print("as3 error");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("Error Loading Data",),);
          }
          else {
            asyncSnapshot = s;
            return asyncSnapshot.data.message == "Data Not Found."? Center(
              child: Text("No Order Details"),
            ): SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: asyncSnapshot.data.address.length,
                      itemBuilder: (c,i){
                        return Container(
                          decoration: BoxDecoration(
                              color: kWhite
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(child: Text("Address",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                                    SizedBox(width: 10,),
                                    Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(color: kPrimaryColor),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5),
                                          child: Text("${asyncSnapshot.data.address[i].addressType}",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                        )),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Text("Name : "+asyncSnapshot.data.address[i].name + " | "+  "Mobile No."+s.data.address[i].mobileNo ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                SizedBox(height: 10,),
                                Text("${asyncSnapshot.data.address[i].address}, "+ "${s.data.address[i].locality}, " + "${s.data.address[i].landmark}, " +"${s.data.address[i].area}, "+ "${s.data.address[i].city}, "+ "${s.data.address[i].district}, "+"${s.data.address[i].state}, "+"${s.data.address[i].pincode}")
                              ],
                            ),
                          ),
                        );

                      }),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10),
                    child: Text("Order Details",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  ),
                  SizedBox(height: 10,),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: asyncSnapshot.data.data.length,
                      itemBuilder: (c,i){
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: kWhite
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 5),
                              child: Column(
                                children: [
                                  asyncSnapshot.data.data[i].image == null ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: kPrimaryColor)
                                      ),
                                      child: Center(child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset("images/app_logo.png",height: 100),
                                      )))
                                      : Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: kPrimaryColor)
                                      ),
                                      child: Center(child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.network(Connection.image + asyncSnapshot.data.data[i].image,height: 100),
                                      ))),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Product Name ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                          Text("Model Number ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                          Text("Size ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14,),),
                                          Text("Quantity ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14,),),
                                          Text("MRP ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14,),),
                                          Text("Total Amount ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14,),),
                                          Text("Order Status ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14,),),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(": ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                          Text(": ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14,),),
                                          Text(": ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14,),),
                                          Text(": ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14,),),
                                          Text(": ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14,),),
                                          Text(": ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14,),),
                                          Text(": ",style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 14,),),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          asyncSnapshot.data.data[i].productName == null ?Text("Empty"):    Text(s.data.data[i].productName,style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                          asyncSnapshot.data.data[i].modelNo == null ?Text("Empty"):     Text(s.data.data[i].modelNo,style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                          asyncSnapshot.data.data[i].size == null ?Text("Empty"):      Text(s.data.data[i].size,style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                          asyncSnapshot.data.data[i].productQuantity == null ?Text("Empty"):        Text(s.data.data[i].productQuantity,style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                          asyncSnapshot.data.data[i].mrpPrice == null ?Text("Empty"):      Text(s.data.data[i].mrpPrice,style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                          asyncSnapshot.data.data[i].totalAmount == null ?Text("Empty"):      Text(s.data.data[i].totalAmount,style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                          asyncSnapshot.data.data[i].orderTrackingDetails == null ?Text("Empty"):        Text(s.data.data[i].orderTrackingDetails,style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                        ],
                                      ),
                                      SizedBox(height: 10,)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                        color: kWhite
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10,bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Order Date",style: TextStyle(fontSize: 16,color: kSecondaryColor),),
                              SizedBox(height: 10,),
                              Text("Total Quantity",style: TextStyle(fontSize: 16,color: kSecondaryColor),),
                              SizedBox(height: 10,),
                              Text("Total Amount",style: TextStyle(fontSize: 16,color: kSecondaryColor),),

                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(asyncSnapshot.data.orderDate.split(" ").first,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: kBlackColor,),),
                              SizedBox(height: 10,),
                              Text(asyncSnapshot.data.orderQuantity,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: kBlackColor,),),
                              SizedBox(height: 10,),
                              Text("Rs."+asyncSnapshot.data.orderAmount+"/-",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: kBlackColor),),

                            ],




                          )
                        ],
                      ),
                    ),
                  ),



                ],
              ),
            );
          }
        },
      ),
    );
  }
}
