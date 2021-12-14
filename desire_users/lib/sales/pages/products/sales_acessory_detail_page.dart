import 'dart:convert';
import 'dart:io';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/models/product_model.dart';
import 'package:desire_users/models/sales_customer_list_model.dart';
import 'package:desire_users/sales/pages/customerCart/customer_cart_page.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:http/http.dart' as http;
import 'package:desire_users/components/custom_app_bar.dart';
import 'package:desire_users/sales/pages/products/product_home_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/custom_stepper.dart';
import 'package:desire_users/sales/utils_sales/default_button.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesAccessoryDetailPage extends StatefulWidget {

  final Product product;

  final String page;

  final List<Product> snapshot;

  final List<UserModel> customerList;


  SalesAccessoryDetailPage({@required this.product, @required this.page, @required this.snapshot, @required this.customerList});

  @override
  _SalesAccessoryDetailPageState createState() => _SalesAccessoryDetailPageState();
}

class _SalesAccessoryDetailPageState extends State<SalesAccessoryDetailPage> {
  Product products;
  String id;

  String name;
  List<UserModel> customerList = [];

  String _verticalGroupValue1;
  List<String> _status1 = [];
  SharedPreferences prefs;

  String salesId;

  String salesEmail,salesName;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    products = widget.product;
    getDetails();
    print(widget.customerList.length);
    customerList = widget.customerList;
    _verticalGroupValue1 = "Select your customer";
    _status1.add(customerList[0].customerName);
    for(int i=1; i<customerList.length;i++){
      _status1.add(customerList[i].customerName);
    }
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
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(rating: double.parse(widget.product.id), press: (){
        Navigator.of(context).pop();
      },),
      body: _body(),
    );
  }

  Widget _body(){
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
                    child: Text("Price: ₹${widget.product.customerprice}",
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
            _topRoundedContainer(Color(0xFFF6F7F9),
              Column(
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
                FutureBuilder(
                  future: Hive.openBox(Connection.cartList),
                  builder: (c, ss) {
                    if (ss.connectionState != ConnectionState.done) {
                      return CupertinoButton(color: Colors.black87,
                        child: Container(width: 15, height: 15,
                            child: CircularProgressIndicator(strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )),
                        onPressed: () {},
                      );
                    } else {
                      if (ss.hasError) {
                        return CupertinoButton(color: Colors.black87,
                          child: Text('Add To Cart', style:
                          TextStyle(color: Colors.white, fontFamily: 'Archivo',),),
                          onPressed: () {
                            Alerts.showAlertAndBack(context, 'Alert',
                                'Something went wrong. Please try again later.');
                          },
                        );
                      } else {
                        return ValueListenableBuilder(
                            valueListenable: Hive.box(Connection.cartList).listenable(),
                            builder: (context, box, widget) {
                              return box.containsKey(products.id) ?
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                                child: DefaultButton2(
                                  text: 'View Cart',
                                  press: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerCartPage(customerId: id, customerName:name)));
                                  },
                                ),
                              ) :
                              Padding(
                                padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                                child: DefaultButton(
                                  text: 'Add To Cart',
                                  press: () async{


                                    print("object customerID $id ${customerList.length}");

                                    if(id == null){
                                      showDialog(context: context, builder: (builder) {
                                        return Platform.isIOS ? CupertinoAlertDialog(
                                          title: Text('Select Your Customer'),
                                          content: SingleChildScrollView(
                                            physics: BouncingScrollPhysics(),
                                            child: RadioGroup<String>.builder(
                                              direction: Axis.vertical,
                                              spacebetween: 70,
                                              groupValue: _verticalGroupValue1,
                                              onChanged: (value) {
                                                setState(() {
                                                  _verticalGroupValue1 = value;
                                                  print("object address type $value");
                                                  for(int i=0; i<customerList.length;i++){
                                                    if(customerList[i].customerName == _verticalGroupValue1){
                                                      id = customerList[i].customerId;
                                                      name =customerList[i].customerName;
                                                      prefs.setString("customer_id", id);
                                                      prefs.setString("customer_name", name);
                                                    }
                                                  }
                                                  Map cartData = Map();
                                                  cartData['id'] = '${products.id}';
                                                  cartData['name'] = '${products.productName}';
                                                  cartData['image'] = '${ss.data.imagePath}${products.image[0]}';
                                                  cartData['mrp'] = products.id; // '${s.data.mrp}';
                                                  cartData['qty'] = totQty;
                                                  box.put('${products.id}', cartData);
                                                  addToCart();
                                                });
                                              },
                                              items: _status1,
                                              itemBuilder: (item) => RadioButtonBuilder(
                                                item,
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            CupertinoButton(
                                              child: Text("Ok", style: TextStyle(color: kPrimaryColor),),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        ) : AlertDialog(
                                          title: Text('Select your Customer'),
                                          content: SingleChildScrollView(
                                            physics: BouncingScrollPhysics(),
                                            child: RadioGroup<String>.builder(
                                              direction: Axis.vertical,
                                              spacebetween: 50,
                                              groupValue: _verticalGroupValue1,
                                              onChanged: (value) => setState((){
                                                _verticalGroupValue1 = value;
                                                print("object address type $value");
                                                for(int i=0; i<customerList.length;i++){
                                                  if(customerList[i].customerName == _verticalGroupValue1){
                                                    id = customerList[i].customerId;
                                                    name = customerList[i].customerName;
                                                    prefs.setString("customer_id", id);
                                                    prefs.setString("customer_name", customerList[i].customerName);
                                                  }
                                                }
                                                Map cartData = Map();
                                                cartData['id'] = '${products.id}';
                                                cartData['name'] = '${products.productName}';
                                                cartData['image'] = '${ss.data.imagePath}${products.image[0]}';
                                                cartData['mrp'] = products.id; // '${s.data.mrp}';
                                                cartData['qty'] = totQty;
                                                box.put('${products.id}', cartData);
                                                addToCart();
                                              }),
                                              items: _status1,
                                              itemBuilder: (item) => RadioButtonBuilder(
                                                item,
                                              ),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("Ok", style: TextStyle(color: kPrimaryColor),),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });


                                    } else {
                                      Map cartData = Map();
                                      cartData['id'] = '${products.id}';
                                      cartData['name'] = '${products.productName}';
                                      cartData['image'] = '${ss.data.imagePath}${products.image[0]}';
                                      cartData['mrp'] = products.id; // '${s.data.mrp}';
                                      cartData['qty'] = totQty;
                                      box.put('${products.id}', cartData);
                                      addToCart();
                                    }
                                    // Map cartData = Map();
                                    // cartData['id'] = '${products.id}';
                                    // cartData['name'] = '${products.productName}';
                                    // cartData['image'] = '${products.imagepath}${products.image[0]}';
                                    // cartData['mrp'] = products.id; // '${s.data.mrp}';
                                    // cartData['qty'] = totQty;
                                    // box.put('${products.id}', cartData);
                                    // addToCart();
                                  },
                                ),
                              );
                            });
                      }
                    }
                  },
                )
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
              child: Image.network("http://loccon.in/desiremoulding/upload/Image/Product/"+widget.product.image[selectedImage]),
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
        widget.product.dimensionId,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  addToCart() async {
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator(
        color: kPrimaryColor,
      )),);
    pr.show();
    var response;
    response = await http.post(Uri.parse(Connection.addCart), body: {
      'secretkey': Connection.secretKey,
      'customer_id': id,
      'product_id': widget.product.id,
      'quantity': totQty.toString(),
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true) {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (builder) => ProductHomePage()), (
          route) => false);
    } else {
      Alerts.showAlertAndBack(context, "User Not Found",
          "Please enter registered mobile no or email id");
    }
  }
}