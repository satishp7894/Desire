import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/product_detail_bloc.dart';
import 'package:desire_users/models/product_details_model.dart';
import 'package:desire_users/models/product_model.dart';
import 'package:desire_users/models/sales_customer_list_model.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/custom_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsClickPage extends StatefulWidget {

  final String productId, productName, customerId;

  const ProductDetailsClickPage({@required this.productId,this.productName,this.customerId});

  @override
  _ProductDetailsClickPageState createState() => _ProductDetailsClickPageState();
}

class _ProductDetailsClickPageState extends State<ProductDetailsClickPage> {

  String id;
  String name;
  List<UserModel> customerList = [];

  SharedPreferences prefs;

  String salesId;

  String salesEmail,salesName;

  String page;

  AsyncSnapshot<ProductModel> as;

  final productBloc = ProductDetailBloc();

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    getDetails();
    print("object product id ${widget.productId}");
    productBloc.fetchDetailProduct(widget.productId,widget.customerId);
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

  getDetails() async{
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString("customer_id");
    name = prefs.getString("customer_name");
    salesId = prefs.getString("sales_id");
    salesEmail = prefs.getString("sales_email");
    salesName = prefs.getString("sales_name");
  }

  @override
  void dispose() {
    super.dispose();
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.productName.toUpperCase()),
      ),
      body: _body(),
    );
  }


  Widget _body(){
    return StreamBuilder<ProductDetailModel>(
      stream: productBloc.newProductDetailStream,
      builder: (c, s) {

        if (s.connectionState != ConnectionState.active) {
          print("all connection");
          return Container(height: 300,
              alignment: Alignment.center,
              child: Center(
                heightFactor: 50, child: CircularProgressIndicator(color: kPrimaryColor,),));
        }
        if (s.hasError) {
          print("as3 error");
          return Container(height: 300,
            alignment: Alignment.center,
            child: Text("Error Loading Data",),);
        }
        if (s.data == null) {
          print("as3 empty");
          return Container(height: 300,
            alignment: Alignment.center,
            child: Text("No Data Found",),);
        }

        as = s as AsyncSnapshot<ProductModel>;

        return ListView(
          children: [
            _productImages(),
            _topRoundedContainer(Colors.white, Column(
              children: [
                _productDescription(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                        child: Text("Price: ₹${as.data.product[0].customernewprice}",
                          maxLines: 3,
                          style: appbarStyle,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: CustomStepper(initialValue: 1, maxValue: 100, onChanged: (val){
                          setState(() {
                            totQty = val;
                          });
                        }),
                      ),
                    ),
                  ],
                ),
                _topRoundedContainer(Color(0xFFF6F7F9), Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                      child: Text("Profile No.: ${as.data.product[0].profileNo}",
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                      child: Text("Model No.: ${as.data.product[0].modelNo}",
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                      child: Text("Dimensions: ${as.data.product[0].dimensionId}",
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                      child: Text("Category: ${as.data.product[0].category}",
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
                ),
              ],
            ),
            ),
          ],
        );
      }
    );
  }

  int selectedImage = 0;

  Widget _productImages(){
    return Column(
      children: [
        SizedBox(
          width: 238,
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: as.data.product[0].id.toString(),
              child: Image.network(Connection.image+as.data.product[0].image[selectedImage]),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(as.data.product[0].image.length,
                    (index) => buildSmallProductPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(Connection.image+as.data.product[0].image[index]),
      ),
    );
  }

  Widget _topRoundedContainer(Color color, Widget child){
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(top: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: child,
    );
  }

  bool fav = true;
  int totQty = 1;

  Widget _productDescription(){
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        as.data.product[0].productName,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

}
