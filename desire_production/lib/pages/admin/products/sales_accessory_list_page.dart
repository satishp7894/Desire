import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/accesory_bloc.dart';
import 'package:desire_production/model/product_model.dart';
import 'package:desire_production/model/sales_customer_list_model.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

import 'sales_acessory_detail_page.dart';

class SalesAccessoryListPage extends StatefulWidget {
  final List<Product> snapshot;
  final String title;
  final String customerId;
  final String customerName;
  final String salesId;
  final bool refresh;


  SalesAccessoryListPage({@required this.snapshot, @required this.title, @required this.refresh, @required this.customerId, @required this.customerName, @required this.salesId});

  @override
  _SalesAccessoryListPageState createState() => _SalesAccessoryListPageState();
}

class _SalesAccessoryListPageState extends State<SalesAccessoryListPage> {
  List<Product> product;
  List<CustomerModel> customerList;

  final bloc =  AccesoryBloc();

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    print("object for refresh is ${widget.refresh}");
    if(widget.refresh){
      bloc.fetchAccessory(widget.customerId);
    } else{
      setState(() {
        product = widget.snapshot;
      });
    }
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
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Navigator.push(context, MaterialPageRoute(builder: (c) => SalesAccessoryListPage(snapshot: product, title: widget.title, refresh: true, customerId: widget.customerId, customerName: widget.customerName, salesId: widget.salesId,)));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("${widget.title}"),
            centerTitle: true,
            backgroundColor: Colors.white,
            titleTextStyle: headingStyle,
            textTheme: Theme.of(context).textTheme,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: (){
              Navigator.of(context).pop();
            },),
            elevation: 0,
          ),
          body: _body(),
        ),
      ),
    );
  }

  Widget iconBtnWithCounter(String svgSrc, int numOfItem, Function() press,){
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: press,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(svgSrc),
          ),
          if (numOfItem != 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  color: Color(0xFFFF4848),
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.5, color: Colors.white),
                ),
                child: Center(
                  child: Text(
                    "$numOfItem",
                    style: TextStyle(
                      fontSize: 10,
                      height: 1,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  bool fav = false;


  Widget _body(){
    return widget.refresh ?
    StreamBuilder<ProductModel>(
        stream: bloc.newAccessoryStream,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.active) {
            print("all connection ${s.connectionState}");
            return Container(height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50, child: CircularProgressIndicator(),));
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
          print("object of s ${s.data.message}");
          return StaggeredGridView.countBuilder(
            padding: EdgeInsets.all(15),
            crossAxisCount:4,
            itemCount: s.data.product.length,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (c) => SalesAccessoryDetailPage(product: product[index], customerName: widget.customerName, customerId: widget.customerId, salesId: widget.salesId,)));
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
                    child: Hero(
                      tag: s.data.product[index].image[0]+"$index",
                      child: Image.network("${s.data.product[index].imagepath}${s.data.product[index].image[0]}",),
                    ),
                  ),
                  Text(
                    s.data.product[index].productName,
                    style: TextStyle(color: Colors.black),
                    maxLines: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹${s.data.product[index].Customernewprice}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            staggeredTileBuilder: (int index) =>
                StaggeredTile.fit(2),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          );
        }
    ) : StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(15),
      crossAxisCount:4,
      itemCount: product.length,
      itemBuilder: (BuildContext context, int index) => GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (c) => SalesAccessoryDetailPage(product: product[index], customerName: widget.customerName, customerId: widget.customerId, salesId: widget.salesId,)));
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
              child: Hero(
                tag: product[index].image[0]+"$index",
                child: Image.network("${product[index].imagepath}${product[index].image[0]}",),
              ),
            ),
            Text(
              product[index].productName,
              style: TextStyle(color: Colors.black),
              maxLines: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${product[index].Customernewprice}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      staggeredTileBuilder: (int index) =>
          StaggeredTile.fit(2),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
    );
  }

}
