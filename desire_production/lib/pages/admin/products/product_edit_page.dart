import 'dart:io';

import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/pages/admin/products/product_list_page.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/drawer_admin.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:desire_production/model/product_model.dart';

class ProductEditPage extends StatefulWidget {

  final Product product;

  const ProductEditPage({@required this.product});

  @override
  _ProductEditPageState createState() => _ProductEditPageState();
}

class _ProductEditPageState extends State<ProductEditPage> with Validator{

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  File _imageFile1;

  TextEditingController profile;
  TextEditingController model;
  TextEditingController name;
  TextEditingController hsnCode;
  TextEditingController category;
  TextEditingController dimension;
  TextEditingController sPrice;
  TextEditingController dPrice;
  TextEditingController cPrice;

  @override
  void initState() {
    super.initState();
    profile = TextEditingController(text: widget.product.profileNo);
    model = TextEditingController(text: widget.product.modelNo);
    name = TextEditingController(text: widget.product.productName);
    hsnCode = TextEditingController(text: widget.product.id);
    category = TextEditingController(text: widget.product.category);
    dimension = TextEditingController(text: widget.product.dimensionId);
    sPrice = TextEditingController(text: widget.product.Salesmanprice);
    dPrice = TextEditingController(text: widget.product.Distributorprice);
    cPrice = TextEditingController(text: widget.product.Customerprice);
  }

  @override
  void dispose() {
    super.dispose();
    profile.dispose();
    model.dispose();
    name.dispose();
    hsnCode.dispose();
    category.dispose();
    sPrice.dispose();
    dPrice.dispose();
    cPrice.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => ProductListPage()));
      },
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              // leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => SalesHomePage()));
              // },),
              title: Text("Product Details", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
              centerTitle: true,
              leading: Builder(
                builder: (c){
                  return IconButton(icon: Image.asset("assets/images/logo_new.png"), onPressed: (){
                    Scaffold.of(c).openDrawer();
                  },);
                },
              ),
              actions: [
                PopupMenuButton(
                    icon: Icon(Icons.settings_outlined, color: Colors.black,),
                    itemBuilder: (b) =>[
                      PopupMenuItem(
                          child: TextButton(
                            child: Text("Log Out", textAlign: TextAlign.center,),
                            onPressed: (){
                              Alerts.showLogOut(context, "Log Out", "Are you sure?");
                            },
                          )
                      ),
                    ]
                )
              ],
            ),
            drawer: DrawerAdmin(),
            body: _body(),
          )),
    );
  }

  Widget _body(){
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      physics: AlwaysScrollableScrollPhysics(),
      child: product(),
    );
  }

  Widget product(){
    return Form(
      autovalidateMode: _autovalidateMode,
      key: _formkey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: profile,
                decoration: InputDecoration(
                  labelText: 'Profile No.',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: model,
                decoration: InputDecoration(
                  labelText: 'Model No.',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: name,
                decoration: InputDecoration(
                  labelText: 'Product Name',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: hsnCode,
                decoration: InputDecoration(
                  labelText: 'HSN/SAC',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: category,
                decoration: InputDecoration(
                  labelText: 'Product Category',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: dimension,
                decoration: InputDecoration(
                  labelText: 'Product Dimension',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: sPrice,
                decoration: InputDecoration(
                  labelText: 'Salesman Price',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: dPrice,
                decoration: InputDecoration(
                  labelText: 'Distributor Price',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                controller: cPrice,
                decoration: InputDecoration(
                  labelText: 'Customer Price',
                  hoverColor: Color(0xFFFF7643),
                  labelStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 30, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Product Image", style: TextStyle(color: Colors.grey, fontSize: 18),),
                  GestureDetector(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Icon(Icons.collections, color: Colors.black, size: 30,)),
                      onTap: () {
                        //futureShowChoiceDialog();
                      }
                  ),
                  widget.product.image[0].isEmpty ? _imageFile1 == null ? Container() : Image.file(_imageFile1, height: 100, width: 100, fit: BoxFit.cover) : SizedBox(
                    width: 80,
                    child: AspectRatio(
                      aspectRatio: 0.88,
                      child: Hero(
                        tag: widget.product.image,
                        child: Image.network("${widget.product.imagepath}${widget.product.image[0]}",),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Center(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10),
                  child: DefaultButton(
                    text: "Edit Product",
                    press: (){
                      //addAddress();
                    },
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
