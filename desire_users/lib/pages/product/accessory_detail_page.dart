import 'dart:convert';
import 'dart:ui';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/models/product_model.dart';
import 'package:desire_users/services/check_block.dart';
import 'package:http/http.dart' as http;

import 'package:desire_users/components/custom_app_bar.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/custom_stepper.dart';
import 'package:desire_users/utils/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AccessoryDetailPage extends StatefulWidget {

  final Product product;

  final String page;

  final List<Product> snapshot;

  final bool status;

  final int orderCount;

  AccessoryDetailPage({@required this.product, @required this.page, @required this.snapshot,@required this.status, @required this.orderCount});

  @override
  _AccessoryDetailPageState createState() => _AccessoryDetailPageState();
}

class _AccessoryDetailPageState extends State<AccessoryDetailPage> {

  Product products;
  String id;
  bool countStats = true;
  SharedPreferences prefs;


  @override
  void initState() {
    super.initState();
    checkConnectivity();
    getDetails();
    if(widget.status)
    {
      getDetailsB();
    }
    products = widget.product;
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
    prefs.getBool("countStats") == null ? countStats = true :
    setState(() {
      countStats = prefs.getBool("countStats");
    });
  }


  getDetailsB() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mob = prefs.getString("Mobile_no");
    print("object $mob");
    final checkBloc = CheckBlocked(mob);
    checkBloc.getDetailsAccessory(context,widget.page,"detail",widget.snapshot,widget.product);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(rating: double.parse(widget.product.id), press: (){
        Navigator.of(context).pop();
        },),
      body: _body(),
      //bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home, numOfItem: count,),
    );
  }

  Widget _body(){
    print("object staus $countStats");
    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
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
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Text(
                      "MRP: ₹${widget.product.customerprice}",
                      maxLines: 3,
                      style: TextStyle(
                        color: widget.product.customernewprice==""?kPrimaryColor:kSecondaryColor,
                        decoration: widget.product.customernewprice==""?TextDecoration.none:TextDecoration.lineThrough,
                        fontSize:  widget.product.customernewprice==""?20:16,
                      ),
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
            widget.product.customernewprice == "" ?  Container():Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Text(
                  "Your Price: ₹${widget.product.customernewprice}",
                  maxLines: 3,
                  style: appbarStyle,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            _topRoundedContainer(Colors.grey.shade300, Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Text("Name: ${widget.product.productName}",
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Text("Description: ${widget.product.dimensionId}",
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: DefaultButton(
                    text: 'Add To Basket',
                    press: () {
                      addToCart();
                    },
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
            ),
          ],
        ),
        ),
      ],
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
              tag: widget.product.id.toString(),
              child: PhotoView(imageProvider: NetworkImage("http://loccon.in/desiremoulding/upload/Image/Product/"+widget.product.image[selectedImage]), backgroundDecoration: BoxDecoration(color: Colors.transparent,),),
            ),
          ),
        ),
        // SizedBox(height: getProportionateScreenWidth(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(widget.product.image.length,
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
        child: Image.network("http://loccon.in/desiremoulding/upload/Image/Product/"+widget.product.image[index]),
      ),
    );
  }

  Widget _topRoundedContainer(Color color, Widget child){
    return Container(
      margin: EdgeInsets.only(top: 20),
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
        widget.product.productName,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  addToCart() async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    var response;
    response = await http.post(Uri.parse(Connection.addCart), body: {
      'secretkey':Connection.secretKey,
      'customer_id':id,
      'product_id': widget.product.id,
      'quantity':totQty.toString(),
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true){
      final snackBar = SnackBar(content: Row(
        children: [
          Text('Added to Basket Successfully'),
          TextButton(onPressed: (){
           // Navigator.push(context, MaterialPageRoute(builder: (builder) => CartPage(id: id, status: true, orderCount: widget.orderCount,)));
          }, child: Text("View Cart", style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),))
        ],
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>AccessoryDetailPage(product: widget.product,page: widget.page,snapshot: widget.snapshot,status: true, orderCount: widget.orderCount,)), (route) => false);
    } else{
      Alerts.showAlertAndBack(context, "User Not Found", "Please enter registered mobile no or email id");
    }
  }
}
