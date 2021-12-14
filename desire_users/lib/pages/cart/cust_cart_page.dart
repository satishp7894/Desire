import 'dart:convert';
import 'package:desire_users/bloc/cart_bloc.dart';
import 'package:desire_users/models/cart_model.dart';
import 'package:desire_users/pages/home/home_page.dart';
import 'package:desire_users/pages/profile/address_view_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/custom_stepper.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustCartPage extends StatefulWidget {

  final customerId;
  final customerName;
  final customerMobile;
  final customerEmail;

  const CustCartPage({Key key,this.customerId, this.customerName, this.customerMobile, this.customerEmail}) : super(key: key);

  @override
  _CustCartPageState createState() => _CustCartPageState();
}

class _CustCartPageState extends State<CustCartPage> {

  final CartBloc cartBloc = CartBloc();


  String address = "";
  String addressId = "";
  String customerId = " ";
  String customerName = "";
  String customerEmail = " ";
  String customerMobile = " ";
  getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    customerMobile = prefs.getString("Mobile_no");
    customerId = prefs.getString("customer_id");
    customerName = prefs.getString("Customer_name");
    customerEmail = prefs.getString("Email");
  }

  getSelectedAddress() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString("add");
      addressId = prefs.getString("add_id");
    });
    print("Address Id : "+ addressId);
    print("address shares $address $addressId");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartBloc.fetchCartDetails(widget.customerId);
    getSelectedAddress();
    getUserDetails();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cartBloc.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: kBlackColor
        ),
        centerTitle: true,
        title: Text("My Basket",style: TextStyle(color: kBlackColor),),
      ),
      body: body(),
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
              SizedBox(height: 10,),
              address == null ? Text("Address: No address selected", maxLines: 3,textAlign: TextAlign.left,style: TextStyle(color: kBlackColor,fontSize: 12,))
                  :Text("$address",style: TextStyle(color: Colors.black,fontSize: 14,),),
              address == null ? Center(
                child: TextButton(
                  style: TextButton.styleFrom(side: BorderSide(color: kPrimaryColor)),
                  child: Text("Select Address",style: TextStyle(color: kPrimaryColor),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => AddressViewPage(userId: widget.customerId, page: "cart",status: true,orderCount: 0)));
                  },
                ),
              ) :Center(
                child: TextButton(
                  style: TextButton.styleFrom(side: BorderSide(color: kPrimaryColor)),
                  child: Text("Change Address",style: TextStyle(color: kPrimaryColor),),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => AddressViewPage(userId: widget.customerId, page: "cart",status: true,orderCount: 0)));
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  AsyncSnapshot<CartModel> asyncSnapshot;
  Widget body(){
     return StreamBuilder<CartModel>(
         stream: cartBloc.newCartStream,
         builder: (c,s){
           if(s.connectionState!= ConnectionState.active){
             return Center(
               child: CircularProgressIndicator(
                 color: kPrimaryColor,
               ),
             );
           }
           else if(s.hasError){
             return Center(
               child: Text("Something went wrong"),
             );
           }
           else {
             asyncSnapshot = s;
             return  asyncSnapshot.data.message == "Cart is Empty" ?  Center(child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 Text("No Items in Basket",style: TextStyle(
                   color: kPrimaryColor,
                   fontSize: 20,
                   fontWeight: FontWeight.bold
                 ),),
                 SizedBox(height: 10,),
                 FloatingActionButton.extended(
                     backgroundColor: kPrimaryColor,
                     onPressed: (){
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => HomePage(customerId: widget.customerId,customerName: widget.customerName,customerEmail: widget.customerEmail,mobileNo: widget.customerMobile,status: true)));

                 }, icon: Icon(Icons.home),label: Text("Continue to Home Page"))
               ],
             ))
                 : SingleChildScrollView(
               physics: BouncingScrollPhysics(),

                   child: Column(
               children: [
                   addressView(),
                   ...List.generate(asyncSnapshot.data.data.length, (index) => CartItemsTile(
                     cart: asyncSnapshot.data.data[index],
                     customerId: widget.customerId,
                     customerMobile: widget.customerMobile,
                     customerEmail: widget.customerEmail,
                     customerName: widget.customerName,
                   )),
                   Container(
                     decoration: BoxDecoration(
                       color: Colors.white
                     ),
                     child: Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: [
                           Flexible(
                             flex: 1,
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text("Total Quantity",style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                 SizedBox(height: 10,),
                                 Text("Total Amount",style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),),

                               ],
                             ),
                           ),
                           Flexible(
                             flex: 1,
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.start,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(asyncSnapshot.data.totalQuantity.toString(),style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold,fontSize: 14),),
                                 SizedBox(height: 10,),
                                 Text("Rs."+asyncSnapshot.data.totalAmount.toString()+"/-",style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold,fontSize: 14),),
                               ],
                             ),
                           ),
                           Flexible(
                               flex:1,
                               child: FloatingActionButton.extended(
                                 elevation: 0.0,
                                 isExtended: true,
                                 splashColor: kWhiteColor,
                                 backgroundColor: kPrimaryColor,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(10)
                                 ),
                                 onPressed: (){

                                   placeOrder(widget.customerId, asyncSnapshot.data.totalQuantity.toString(), asyncSnapshot.data.totalAmount.toString());

                           }, label: Text("PLACE ORDER",style: TextStyle(fontSize: 12),),
                           ))

                         ],
                       ),
                     ),
                   )
               ],
             ),
                 );
           }
         });
  }


  placeOrder(String customerId, String quantity, String totalAmount) async{
    var response = await http.post(Uri.parse(Connection.checkOut), body: {
      'secretkey':Connection.secretKey,
      'customer_id':"$customerId",
      'total_order_quantity':"$quantity",
      'order_amount':"$totalAmount",
      'discounted_total':"234",
      'coupon_code':"12",
      'selectedAddress':"$addressId",
      'bdOrderNote':"qwert"
    });

    print("object response ${response.body}");
    var results = json.decode(response.body);
    if (results['status'] == true) {
      final snackBar = SnackBar(content: Text("Your Order is Placed Successfully"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      navigateHome();

    }
    else if(results['status'] == false){
      print("Failed to Place Order");
      final snackBar = SnackBar(content: Text("Failed to Place Order"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if(results['message'] == "Your cart is empty."){
      print("Failed to Place Order");
      final snackBar = SnackBar(content: Text("Failed to Place Order"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else {
      final snackBar =
      SnackBar(content: Text("Failed to Place Order"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  navigateHome(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(
      status: true,
      customerEmail: widget.customerEmail == null ? customerEmail :widget.customerEmail ,
      customerName:  widget.customerName == null ? customerName : widget.customerName,
      customerId: widget.customerId== null ? customerId : widget.customerId,
      mobileNo: widget.customerMobile== null ? customerMobile : widget.customerMobile,
    )));
  }

}

class CartItemsTile extends StatefulWidget {

  final Cart cart;
  final customerId;
  final customerName;
  final customerMobile;
  final customerEmail;


  const CartItemsTile({Key key,this.cart,this.customerId, this.customerName, this.customerMobile, this.customerEmail}) : super(key: key);

  @override
  _CartItemsTileState createState() => _CartItemsTileState();
}

class _CartItemsTileState extends State<CartItemsTile> {

  List<int> quantity = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0,bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: kWhiteColor,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0,top: 10,right: 10,bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      flex:1,
                      child: widget.cart.image == null ? Image.network("images/app_logo.png"):Image.network(Connection.image+widget.cart.image,height: 150,width: 150,)
                  ),
                  SizedBox(width: 10,),
                  Flexible(
                      flex: 1,
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.cart.productName.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: kBlackColor),),
                      SizedBox(height: 10,),
                      Text("Price : "+ "Rs."+ widget.cart.customerprice+"/stick" ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Text("Stick per Box : "+widget.cart.perBoxStick+" stick"),
                      SizedBox(height: 10,),
                      Text("Box Price : "+ "Rs."+ widget.cart.boxPrice.toString()+"/-"),
                      SizedBox(height: 10,),
                      Text("Amount : "+ "Rs."+ widget.cart.totAmount.toString()+"/-"),


                    ],
                  )
                  )
                ],
              ),
              Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kPrimaryColor)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("Box Quantity : "+ widget.cart.quantity.toString()),
                        ))),
                    Center(
                      child: CustomStepper(
                        initialValue: int.parse(widget.cart.quantity),
                        maxValue: 100,
                        onChanged: (value){
                          setState(() {
                            changeQty(value.toString());
                          });

                        },
                      ),
                    ),
                    Center(
                      child: FloatingActionButton.extended(

                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        onPressed: (){
                        removeCart();
                      }, icon: Icon(Icons.delete,color: kWhiteColor,),
                      label: Text("Delete"),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  changeQty(String quantity) async{

    print(quantity);
    var response = await http.post(Uri.parse(Connection.changeQty), body: {
      'secretkey':Connection.secretKey,
      'customer_id':"${widget.customerId}",
      'product_id' :"${widget.cart.productId}",
      'newQty':"$quantity"
    });

    var results = json.decode(response.body);
    if (results['status'] == true) {
      final snackBar = SnackBar(content: Text('Quantity Changed Successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => CustCartPage(customerId: widget.customerId,customerName: widget.customerName,customerEmail: widget.customerEmail,customerMobile: widget.customerMobile)));

    } else {
      final snackBar = SnackBar(content: Text('Quantity Changing Not Successful'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  removeCart() async{
    await Hive.openBox(Connection.cartList);
    Box box = Hive.box(Connection.cartList);
    var response = await http.post(Uri.parse(Connection.removeCart), body: {
      'secretkey':Connection.secretKey,
      'customer_id':widget.customerId,
      "product_id":widget.cart.productId,
    });
    var results = json.decode(response.body);
    if (results['status'] == true) {
      box.delete(widget.cart.productId);
      final snackBar = SnackBar(content: Text('Removed from Basket Successfully'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => CustCartPage(customerId: widget.customerId,customerName: widget.customerName,customerEmail: widget.customerEmail,customerMobile: widget.customerMobile)));
    } else {
      Alerts.showAlertAndBack(context, 'Failed', 'Failed to remover item. Please try again later.');
    }
  }


}
