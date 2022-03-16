import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/product_bloc.dart';
import 'package:desire_production/model/product_model.dart';
import 'package:desire_production/model/sales_customer_list_model.dart';
import 'package:desire_production/pages/admin/products/sales_product_detail_page.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SalesProductCategoryPage extends StatefulWidget {

  final String id;
  final String name;
  final String salesId;
  final String customerId;
  final String customerName;


  SalesProductCategoryPage({@required this.id, @required this.name, @required this.customerId, @required this.customerName, @required this.salesId});

  @override
  _SalesProductCategoryPageState createState() => _SalesProductCategoryPageState();
}

class _SalesProductCategoryPageState extends State<SalesProductCategoryPage> {
  final bloc = ProductBloc();

  bool fav = false;
  List<CustomerModel> customerList;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    print("object product id ${widget.id}");
    bloc.fetchCategoryWiseProduct(widget.id);
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.name}"),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: (){
            Navigator.of(context).pop();
          },),
          backgroundColor:kSecondaryColor.withOpacity(0),
          titleTextStyle: headingStyle,
          textTheme: Theme.of(context).textTheme,
        ),
        body: _body(),
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

  Widget _body(){
    return StreamBuilder<ProductModel>(
        stream: bloc.categoryWiseProductStream,
        builder: (c,s){

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

          return RefreshIndicator(
            onRefresh: (){
              return Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SalesProductCategoryPage(id:  widget.id, name: widget.name,  customerName: widget.customerName, customerId: widget.customerId, salesId: widget.salesId,)));
            },
            child: ListView.separated(
              padding: EdgeInsets.only(top: 30),
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: s.data.product.length,
              itemBuilder: (c,i){
                return Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          height: 80,
                          width: 80,
                          margin: EdgeInsets.only(right: 30),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Hero(
                            tag: s.data.product[i].productName.toString(),
                            child: Image.network("${s.data.product[i].imagepath}${s.data.product[i].image[0]}"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              s.data.product[i].productName,
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.black),
                              maxLines: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "₹${s.data.product[i].Customernewprice}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5, right: 5, top: 8,bottom: 8),
                                    child: DefaultButton(text: "View", press: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (c) => SalesProductDetailsPage(product: s.data.product[i],  customerName: widget.customerName, customerId: widget.customerId, salesId: widget.salesId,)));
                                    },),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }, separatorBuilder: (BuildContext context, int index) {
              return Divider(color: Colors.black12, height: 2,);
            },),
          );
        });
  }

}
