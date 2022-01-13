import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/productFromModelBloc.dart';
import 'package:desire_users/bloc/readystockModelBloc.dart';
import 'package:desire_users/models/productFromModelNoModel.dart';
import 'package:desire_users/models/product_details_model.dart';
import 'package:desire_users/models/readyStockModel.dart';
import 'package:desire_users/pages/product/productFromModelDetailPage.dart';
import 'package:desire_users/pages/product/product_detail_page.dart';
import 'package:desire_users/sales/pages/products/salesProductFromModelDetailPage.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ReadyStockFromModelPage extends StatefulWidget {
  final customerId;
  final modelNoId;
  final type;


  const ReadyStockFromModelPage({Key key,this.customerId,this.modelNoId, this.type}) : super(key: key);

  @override
  _ProductFromModelPageState createState() => _ProductFromModelPageState();
}

class _ProductFromModelPageState extends State<ReadyStockFromModelPage> {

  final readyStockModelBloc = ReadyStockModelBloc();




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkConnectivity();
    readyStockModelBloc.fetchReadyProductFromModel(widget.modelNoId, widget.customerId);
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    readyStockModelBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: kBlackColor
        ),
        title: Text("Model No. "+ widget.modelNoId,style: TextStyle(color: kBlackColor),),
        backgroundColor: kWhiteColor,
        centerTitle: true,
      ),
      body: view(),
    );
  }

  Widget view(){
    return StreamBuilder<ReadyStockModel>(
        stream: readyStockModelBloc.readyproductFromModelStream,
        builder: (c,s){

          if (s.connectionState != ConnectionState.active) {
            print("all connection ${s.connectionState}");
            return Container(height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50, child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),));
          }
          print("object of s ${s.connectionState}");
          if (s.hasError) {
            print("as3 error");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("Error Loading Data",),);
          }
          if (s.data
              .toString()
              .isEmpty) {
            print("as3 empty");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("No Data Found",),);
          }
          return s.data.status == false ? Center(
              child: Text("No Products")
          ):StaggeredGridView.countBuilder(
            padding: EdgeInsets.all(15),
            physics: BouncingScrollPhysics(),
            crossAxisCount: 2,
            itemCount: s.data.readyStockProductList.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: (){
                widget.type == "sales" ? {} : Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductFromModelDetailPage(
                  customerId: widget.customerId,
                  productId: s.data.readyStockProductList[index].productId,

                )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network("${s.data.productImageUrl}${s.data.readyStockProductList[index].image}",),
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Text(
                    s.data.readyStockProductList[index].productName.toUpperCase(),
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
                  SizedBox(height: 5,),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       "MRP: " "₹${s.data.readyStockProductList[index].customerprice}",
                  //       style: TextStyle(
                  //         decoration:   s.data.readyStockProductList[index].customernewprice == "" ?TextDecoration.none: TextDecoration.lineThrough,
                  //         fontSize: s.data.readyStockProductList[index].customernewprice == "" ? 14:12,
                  //         fontWeight: FontWeight.w600,
                  //         color: s.data.readyStockProductList[index].customernewprice == "" ? kPrimaryColor :kSecondaryColor,
                  //       ),
                  //     ),
                  //     Text(
                  //       s.data.readyStockProductList[index].customernewprice =="" ? "": "Your Price "+"₹${s.data.data[index].customernewprice}",
                  //       style: TextStyle(
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.w600,
                  //         color:kPrimaryColor,
                  //       ),
                  //     ),
                  //   ],
                  // )
                ],
              ),
            ),
            staggeredTileBuilder: (int index) =>
                StaggeredTile.fit(1),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          );


        });

  }
}
