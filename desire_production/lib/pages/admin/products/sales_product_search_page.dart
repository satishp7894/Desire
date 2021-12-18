import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/product_bloc.dart';
import 'package:desire_production/model/product_model.dart';
import 'package:desire_production/pages/admin/products/sales_product_detail_page.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

class SalesProductSearchPage extends StatefulWidget {

  final String search;
  final String customerId;
  final String customerName;
  final String salesId;

  SalesProductSearchPage({@required this.search, @required this.customerId, @required this.customerName, @required this.salesId});

  @override
  _SalesProductSearchPageState createState() => _SalesProductSearchPageState();
}

class _SalesProductSearchPageState extends State<SalesProductSearchPage> {
  final searchBloc = ProductBloc();
  final accBloc = ProductBloc();

  bool fav = true;

  TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    searchBloc.fetchSearchProduct(widget.search,widget.customerId);
    accBloc.fetchSearchAccessories(widget.search,widget.customerId);
    searchController = TextEditingController(text: widget.search);
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
    super.dispose();
    searchBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SalesProductSearchPage(search: widget.search, customerId: widget.customerId, customerName: widget.customerName, salesId: widget.salesId,)));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Search Results"),
            centerTitle: true,
            elevation: 0,
            backgroundColor:kSecondaryColor.withOpacity(0),
            titleTextStyle: headingStyle,
            textTheme: Theme.of(context).textTheme,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: (){
              Navigator.of(context).pop();
            },),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: iconBtnWithCounter("assets/icons/Cart Icon.svg",0,(){}),
              ),
            ],
          ),
          body: _body(),
        ),
      ),
    );
  }

  Widget _body(){
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          _homeHeader(),
          SizedBox(height: 10),
          _searches(),
        ],
      ),
    );
  }

  Widget _homeHeader(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: _searchField(),
    );
  }

  Widget _searchField(){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: searchController,
        textInputAction: TextInputAction.search,
        onEditingComplete: (){
          print(searchController.text);
          Navigator.push(context, MaterialPageRoute(builder: (c) => SalesProductSearchPage(search: searchController.text,  customerName: widget.customerName, customerId: widget.customerId, salesId: widget.salesId,)));
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Search product",
            prefixIcon: Icon(Icons.search)),
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

  Widget _searches(){
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Products",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 20),
        StreamBuilder<ProductModel>(
            stream: searchBloc.searchProductStream,
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
                  child: Text("No Products Found",),);
              }
              print("object of s ${s.data.message}");
              return StaggeredGridView.countBuilder(
                shrinkWrap: true,
                padding: EdgeInsets.all(15),
                crossAxisCount:4,
                itemCount: s.data.product.length,
                itemBuilder: (BuildContext context, int index) => GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c) => SalesProductDetailsPage(product: s.data.product[index],  customerName: widget.customerName, customerId: widget.customerId, salesId: widget.salesId,)));
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
        ),
        // Padding(
        //   padding:
        //   EdgeInsets.symmetric(horizontal: 20),
        //   child: Text(
        //     "Accessories",
        //     style: TextStyle(
        //       fontSize: 18,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        // SizedBox(height: 20),
        // StreamBuilder<ProductModel>(
        //     stream: accBloc.searchAccessoriesStream,
        //     builder: (c, s) {
        //       if (s.connectionState != ConnectionState.active) {
        //         print("all connection ${s.connectionState}");
        //         return Container(height: 300,
        //             alignment: Alignment.center,
        //             child: Center(
        //               heightFactor: 50, child: CircularProgressIndicator(),));
        //       }
        //       print("object of s ${s.connectionState}");
        //       if (s.hasError) {
        //         print("as3 error");
        //         return Container(height: 300,
        //           alignment: Alignment.center,
        //           child: Text("Error Loading Data",),);
        //       }
        //       if (s.data.toString().isEmpty) {
        //         print("as3 empty");
        //         return Container(height: 300,
        //           alignment: Alignment.center,
        //           child: Text("No Accessory Found",),);
        //       }
        //       print("object of s ${s.data.message}");
        //       return StaggeredGridView.countBuilder(
        //         shrinkWrap: true,
        //         padding: EdgeInsets.all(15),
        //         crossAxisCount:4,
        //         itemCount: s.data.product.length,
        //         itemBuilder: (BuildContext context, int index) => GestureDetector(
        //           onTap: (){
        //             //Navigator.push(context, MaterialPageRoute(builder: (c) => ProductDetailPage(product: s.data.product[index], page: "search", snapshot: s.data.product,)));
        //           },
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Container(
        //                 padding: EdgeInsets.all(20),
        //                 decoration: BoxDecoration(
        //                   color: kSecondaryColor.withOpacity(0.1),
        //                   borderRadius: BorderRadius.circular(15),
        //                 ),
        //                 child: Hero(
        //                   tag: s.data.product[index].image.length,
        //                   child: Image.network("${s.data.product[index].imagepath}${s.data.product[index].image}",),
        //                 ),
        //               ),
        //               Text(
        //                 s.data.product[index].productName,
        //                 style: TextStyle(color: Colors.black),
        //                 maxLines: 2,
        //               ),
        //               Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                 children: [
        //                   Text(
        //                     "₹${s.data.product[index].Customerprice}",
        //                     style: TextStyle(
        //                       fontSize: 18,
        //                       fontWeight: FontWeight.w600,
        //                       color: kPrimaryColor,
        //                     ),
        //                   ),
        //                   InkWell(
        //                     borderRadius: BorderRadius.circular(50),
        //                     onTap: () {},
        //                     child: Container(
        //                       padding: EdgeInsets.all(8),
        //                       height: 28,
        //                       width: 28,
        //                       decoration: BoxDecoration(
        //                         color: fav
        //                             ? kPrimaryColor.withOpacity(0.15)
        //                             : kSecondaryColor.withOpacity(0.1),
        //                         shape: BoxShape.circle,
        //                       ),
        //                       child: SvgPicture.asset(
        //                         "assets/icons/Heart Icon_2.svg",
        //                         color: fav
        //                             ? Color(0xFFFF4848)
        //                             : Color(0xFFDBDEE4),
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ),
        //         staggeredTileBuilder: (int index) =>
        //             StaggeredTile.fit(2),
        //         mainAxisSpacing: 10,
        //         crossAxisSpacing: 10,
        //       );
        //     }
        // ),
      ],
    );
  }

}
