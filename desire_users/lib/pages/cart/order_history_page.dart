import 'dart:convert';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/pages/home/home_page.dart';
import 'package:desire_users/sales/pages/orders/orderDetailsByIdPage.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/order_bloc.dart';
import 'package:desire_users/models/order_model.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/services/check_block.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistoryPage extends StatefulWidget {

  final String customerId;
  final bool status;
  final int orderCount;

  const OrderHistoryPage({@required this.customerId, @required this.status, @required this.orderCount});

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {

  final OrderBloc orderBloc = OrderBloc();

  bool refresh = false;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    if(widget.status)
    {
      getDetails();
    }
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

  getDetails() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     mob = prefs.getString("Mobile_no");
     id = prefs.getString("customer_id");
     name = prefs.getString("Customer_name");
     email = prefs.getString("Email");
    print("object $mob");
    final checkBloc = CheckBlocked(mob);
    checkBloc.getDetailsCart(context, widget.customerId,"history");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        iconTheme: IconThemeData(
          color: kBlackColor
        ),
        title: Text("Orders",style: TextStyle(color: Colors.black),),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        color: kPrimaryColor,
        onRefresh: (){
          return Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => OrderHistoryPage(customerId: widget.customerId,status: true,orderCount: widget.orderCount)));
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
            return SingleChildScrollView(
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
                        getInvoice(data.orderId);

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

  getInvoice(String orderId) async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Downloading...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    var response = await http.post(Uri.parse(Connection.getInvoice), body: {
      'secretkey': '${Connection.secretKey}',
      'order_id': '$orderId',
    });
    var decodedData = json.decode(response.body);
    print("object response ${decodedData["data"]}\n\n $decodedData");
    pr.hide();
    if (decodedData['status'] == true) {
      print("object invoice ${decodedData['data'][0]} ${decodedData['data'][0]['invoice_file']}");

      imageUrl="${decodedData['imagepath']}${decodedData['data'][0]['invoice_file']}";
      downloadFile(decodedData['data'][0]['invoice_file']);
      if(downloading == false) {
        pr.hide();
      }
    } else {
      Alerts.showAlertAndBack(context, "Something went wrong", "No files found");
    }
  }


  var  imageUrl;
  String downloadingStr="No data";
  double download=0.0;
  bool downloading=true;

  Future downloadFile(String id) async {
    try{
      _reqPer(Permission.storage);
      Dio dio=Dio();
      var dir=await DownloadsPathProvider.downloadsDirectory;
      print("object directory path ${dir.path}");

      dio.download(imageUrl, "${dir.path}/$id",onReceiveProgress: (rec,total){
        setState(() {
          downloading=true;
          download=(rec/total)*100;
          downloadingStr="Downloading Image : "+(download).toStringAsFixed(0);
        });

        print("object download str $download $downloading $downloadingStr");

        setState(() {
          downloading=false;
          downloadingStr="Completed";
          final snackBar = SnackBar(content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('PDF Downloaded Successfully'),
              TextButton(
                  onPressed: (){
                    OpenFile.open("${dir.path}/$id");
                  }, child: Text("View Pdf", style: TextStyle(color: kPrimaryColor),))
            ],
          ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });

        //OpenFile.open("${dir.path}/$id.pdf");

      });
    }catch( e)
    {
      print(e.getMessage());
    }
  }

  Future<bool> _reqPer(Permission permission) async{
    if(await permission.isGranted){
      return true;
    } else{
      var res = await permission.request();

      // ignore: unrelated_type_equality_checks
      if(res == permission.isGranted){
        return true;
      }else{
        return false;
      }
    }
  }

}
