import 'package:desire_users/bloc/productFromModelBloc.dart';
import 'package:desire_users/models/allModel.dart';
import 'package:desire_users/models/productFromModelNoModel.dart';
import 'package:desire_users/pages/product/productFromModelDetailPage.dart';
import 'package:desire_users/sales/pages/products/salesProductFromModelDetailPage.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SalesProductFromModelPage extends StatefulWidget {
  final customerId;
  final customerName;
  final modelNoId;
  final modelNo;


  const SalesProductFromModelPage({Key key,this.customerId,this.modelNoId,this.modelNo,this.customerName}) : super(key: key);

  @override
  _ProductFromModelPageState createState() => _ProductFromModelPageState();
}

class _ProductFromModelPageState extends State<SalesProductFromModelPage> {

  final productFromModelBloc = ProductFromModelBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.modelNoId);
    print(widget.customerId);
    productFromModelBloc.fetchProductFromModel(widget.modelNoId,widget.customerId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    productFromModelBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: Text("Model No. "+ widget.modelNo,style: TextStyle(color: kBlackColor),),
        iconTheme: IconThemeData(
          color: kBlackColor
        ),
        centerTitle: true,
      ),
      body: view(),
    );
  }
  AsyncSnapshot<ProductFromModelNoModel> asyncSnapshot;
  Widget view(){
    return StreamBuilder<ProductFromModelNoModel>(
        stream: productFromModelBloc.productFromModelStream,
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
          if (s.hasError) {
            print("as3 error");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("Error Loading Data",),);
          }
          else {
          asyncSnapshot = s;
          return  s.data.status == false ?
          Center(child: Text("No Products of ${widget.modelNo}"),):
          StaggeredGridView.countBuilder(
            padding: EdgeInsets.all(15),
            crossAxisCount:4,
            itemCount: asyncSnapshot.data.data.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesProductFromModelDetailPage(
                  customerId: widget.customerId,
                  productId: asyncSnapshot.data.data[index].id,
                  customerName: widget.customerName,
                )));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.network("${asyncSnapshot.data.imagepath}${s.data.data[index].image[0]}",),
                  ),
                  Text(
                    asyncSnapshot.data.data[index].productName.toUpperCase(),
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    maxLines: 2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MRP: " "₹${asyncSnapshot.data.data[index].customerprice}",
                        style: TextStyle(
                          decoration:   asyncSnapshot.data.data[index].customernewprice == "" ?TextDecoration.none: TextDecoration.lineThrough,
                          fontSize: asyncSnapshot.data.data[index].customernewprice == "" ? 14:12,
                          fontWeight: FontWeight.w600,
                          color: asyncSnapshot.data.data[index].customernewprice == "" ? kPrimaryColor :kSecondaryColor,
                        ),
                      ),
                      Text(
                        asyncSnapshot.data.data[index].customernewprice =="" ? "": "Your Price "+"₹${s.data.data[index].customernewprice}",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:kPrimaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            staggeredTileBuilder: (int index) =>
                StaggeredTile.fit(2),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          );

        }


        });

  }


}