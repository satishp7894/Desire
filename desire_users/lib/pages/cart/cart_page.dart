import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/cart_bloc.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/models/cart_model.dart';
import 'package:desire_users/pages/home/home_page.dart';
import 'package:desire_users/pages/product/product_detail_page.dart';
import 'package:desire_users/pages/profile/address_view_page.dart';
import 'package:desire_users/sales/pages/products/product_details_click_page.dart';
import 'package:desire_users/services/check_block.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/coustom_bottom_nav_bar.dart';
import 'package:desire_users/utils/custom_stepper.dart';
import 'package:desire_users/utils/enums.dart';
import 'package:desire_users/utils/progress_dialog.dart';
import 'package:desire_users/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';


import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {

  final String id;
  final bool status;
  final int orderCount;

  const CartPage({this.id,@required this.status,@required this.orderCount});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with Validator{
  
  String name , email , mobile , id;

  final bloc = CartBloc();
  List<bool> _status = [];

  List<TextEditingController> price;
  List<TextEditingController> qty;

  List<double> amount = [];
  List<int> quantity = [];

  String address = "";
  String addressId = "";

  double totalAmount = 0 ;
  int totalQty = 0;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    price = [];
    qty = [];
    if(widget.status)
    {
      getDetails();
    }
    getSelectedAddress();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobile = prefs.getString("Mobile_no");
    name = prefs.getString("Customer_name");
    email = prefs.getString("Email");
    print("object $mobile");
    final checkBloc = CheckBlocked(mobile);
    checkBloc.getDetailsCart(context, widget.id,"Cart");
  }
 String customerId = " ";
  getSelectedAddress() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString("add");
      addressId = prefs.getString("add_id");
      customerId = prefs.getString("customer_id");
    });
    bloc.fetchCartDetails(customerId);
    print("Address Id : "+ addressId);
    print("address shares $address $addressId");
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
    for(int i=0 ; i<price.length; i++){
      price[i].dispose();
      qty[i].dispose();
    }
    Hive.close();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){
        return  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomePage(status: true,customerName: name,customerId: widget.id,mobileNo: mobile,customerEmail: email,)), (route) => false);
      },
      child: RefreshIndicator(
        color: kPrimaryColor,
        onRefresh: (){
          return Navigator.push(context, MaterialPageRoute(builder: (builder) => CartPage(id: widget.id, status: true,orderCount: widget.orderCount)),);
        },
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(

            elevation: 0,
            centerTitle: false,
            backgroundColor: Colors.white,
            title: Text("Your Basket", style: TextStyle(color: Colors.black),
            ),
          ),
          body: _body(),
         //   bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.cart, numOfItem: widget.orderCount,),
        ),
      ),
    );
  }


  Widget _body(){
    return StreamBuilder<CartModel>(
        stream: bloc.newCartStream,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Center(child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),);
          }
         else if (s.hasError) {
            print("as3 error ${s.error}");
            return Center(
              child: Text("Error Loading Data${s.error}",),);
          }
        else  if (s.data.data == null) {
            print("as3 empty");
            return Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("No Products Found",),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: DefaultButton(text: "Start Shopping",press: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomePage(status: true,customerName: name,customerId: widget.id,mobileNo: mobile,customerEmail: email,)), (route) => false);
                    },),
                  )
                ],
              ),);
          } else
         {
           print("object length ${s.data.data.length}");
           for(int i=0; i< s.data.data.length; i++)
             price.add(TextEditingController());
           qty.add(TextEditingController());
           _status.add(true);
           return SingleChildScrollView(
             physics: AlwaysScrollableScrollPhysics(),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 SizedBox(height: 10,),
                 addressView(),
                 for(int i=0; i<s.data.data.length;i++)
                   Padding(
                     padding: const EdgeInsets.only(bottom: 10.0),
                     child: Container(
                       decoration: BoxDecoration(
                           color: Colors.white
                       ),
                       child: Padding(
                           padding: EdgeInsets.all(10),
                           child: GestureDetector(
                               onTap: (){
                                 // Navigator.push(context, MaterialPageRoute(builder: (builder) => ProductDetailsClickPage(productId: s.data.data[i].productId,productName: s.data.data[i].productName,)));
                               },
                               child: cartCard(s.data.data[i],i)
                           )
                       ),
                     ),
                   ),
                 Align(
                   alignment: Alignment.bottomCenter,
                   child: checkoutCard(),
                 )

               ],
             ),
           );
         }
        }
    );
  }
  // _cartCard(s.data.data[i],i)
  //_checkoutCard()
  Widget cartCard(Cart product, int i){
    price[i].text = product.customerprice;
    qty[i].text = product.quantity;

    amount.add(double.parse(product.customerprice));
    quantity.add(int.parse(product.quantity));

    totalAmount = totalAmount + (double.parse(product.boxPrice.toString())*int.parse(product.quantity));
    totalQty = totalQty +int.parse(product.quantity);
    print("object ${price[i].text} ${qty[i].text} samt $totalAmount qty $totalQty");


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: SizedBox(
            width: 80,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Hero(
                tag: product.image,
                child: Image.network("${Connection.image}${product.image}",),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${product.productName.toUpperCase()}", style: TextStyle(color: Colors.black, fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Text("Price per stick: ",style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black))),
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      readOnly: true,
                     style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black,fontSize: 14),
                      keyboardType: TextInputType.number,
                      validator: validateEmail,
                      decoration: InputDecoration(
                          border: InputBorder.none
                      ),
                      controller: price[i],

                    ),
                  ),
                 

                ],
              ),
              Text("Stick per Box: ${product.perBoxStick}",style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black,fontSize: 14)),
              SizedBox(height: 10,),
              Text("Box Price: ${product.boxPrice}",style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black,fontSize: 14)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(child: Text("Qty:",style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black))),
                  Flexible(
                    child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5, top: 2.0),
                        child: TextFormField(
                          readOnly: true,
                          keyboardType: TextInputType.number,
                          validator: validateEmail,
                          decoration: InputDecoration(
                              border: InputBorder.none
                          ),
                          controller: qty[i],

                        )
                    ),
                  ),
                  SizedBox(width: 10,),
                  CustomStepper(
                      initialValue: int.parse(product.quantity), maxValue: 100, onChanged: (val){
                    setState(() {
                      changeQty(product.productId, val.toString());
                    });
                  }),
                  SizedBox(width: 20,),
                  Expanded(child: IconButton(icon: Icon(Icons.delete,color: kPrimaryColor,),onPressed: (){
                    removeCart(product.productId);
                  },))
                ],
              ),
            ],
          ),
        ),

      ],
    );
  }




  changeQty(String id, String qty) async{
    var response = await http.post(Uri.parse(Connection.changeQty), body: {
      'secretkey':Connection.secretKey,
      'customer_id':"${widget.id}",
      'product_id' :"$id",
      'newQty':"$qty"
    });

    var results = json.decode(response.body);
    // pr.hide();
    if (results['status'] == true) {

      Navigator.push(context, MaterialPageRoute(builder: (builder) => CartPage(id: widget.id,status: true,orderCount: widget.orderCount)),);
    } else {
      Alerts.showAlertAndBack(context, 'Failed', 'Failed to change quantity. Please contact sales person.');
    }
  }

  removeCart(String productId) async{
    await Hive.openBox(Connection.cartList);
    Box box = Hive.box(Connection.cartList);
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    var response = await http.post(Uri.parse(Connection.removeCart), body: {
      'secretkey':Connection.secretKey,
      'customer_id':widget.id,
      "product_id":productId,
    });
    var results = json.decode(response.body);
    pr.hide();
    if (results['status'] == true) {
      box.delete(productId);
      final snackBar = SnackBar(content: Text('Removed from Basket Successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CartPage(id: widget.id,status: true,orderCount: widget.orderCount)), (route) => false);
    } else {
      Alerts.showAlertAndBack(context, 'Failed', 'Failed to place order. Please try again later.');
    }
  }

  Widget checkoutCard(){
    return Container(
      height: 70,
      color: kWhiteColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10,bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 2,),
                    child: Text("Total Quantity: $totalQty",style: TextStyle(fontSize: 14),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Text("Total Amount: $totalAmount",style: TextStyle(fontSize: 14),),
                  ),

                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: TextButton(
                style: TextButton.styleFrom(

                  backgroundColor:kPrimaryColor,


                ),
                child: Text("Place Order Now",style: TextStyle(color: kWhiteColor,fontSize: 16),),
                onPressed: () {
                  if(address == null){
                    final snackBar = SnackBar(content: Text('Please Select Delivery Address'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    Alerts.showAlertCheckOut(context, totalAmount.toString(), totalQty.toString(), widget.id, addressId);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addressView(){
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Deliver to",style: TextStyle(
                color: kPrimaryColor,fontSize: 16,fontWeight: FontWeight.bold
              ),),
              address == null ? Text("Address: No address selected", maxLines: 3,textAlign: TextAlign.left,style: TextStyle(color: kBlackColor,fontSize: 12,))
                 :Text("$address",maxLines: 3,style: TextStyle(color: Colors.grey,fontSize: 12,),),
              address == null ? Center(
                child: TextButton(
                  style: TextButton.styleFrom(side: BorderSide(color: kPrimaryColor)),
                  child: Text("Select Address",style: TextStyle(color: kPrimaryColor),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => AddressViewPage(userId: widget.id, page: "cart",status: true,orderCount: widget.orderCount)));
                  },
                ),
              ) :Center(
                child: TextButton(
                  style: TextButton.styleFrom(side: BorderSide(color: kPrimaryColor)),
                  child: Text("Change Address",style: TextStyle(color: kPrimaryColor),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => AddressViewPage(userId: widget.id, page: "cart",status: true,orderCount: widget.orderCount)));
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }


}
