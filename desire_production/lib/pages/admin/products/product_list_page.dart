import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/product_list.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/product_model.dart';
import 'package:desire_production/pages/admin/products/product_edit_page.dart';
import 'package:desire_production/pages/dashboards/dashboard_page_admin.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/drawer_admin.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> with Validator{

  final productBloc = ProductListBloc();

  List<Product> send = [];

  AsyncSnapshot<ProductModel> as;

  TextEditingController searchView;
  bool search = false;
  List<Product> _searchResult = [];
  List<Product> _order = [];

  bool isExpand = false;

  File _imageFile1;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
    checkConnectivity();
    searchView = TextEditingController();
    productBloc.fetchProductList();
    profile = TextEditingController();
    model = TextEditingController();
    name = TextEditingController();
    hsnCode = TextEditingController();
    category = TextEditingController();
    dimension = TextEditingController();
    sPrice = TextEditingController();
    dPrice = TextEditingController();
    cPrice = TextEditingController();
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
    searchView.dispose();
    productBloc.dispose();
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
        return  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => DashboardPageAdmin()));
      },
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              // leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => SalesHomePage()));
              // },),
              title: Text("Product List", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
              centerTitle: true,
              leading: Builder(
                builder: (c){
                  return IconButton(icon: Image.asset("assets/images/logo.png"), onPressed: (){
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
    return RefreshIndicator(
      onRefresh:(){
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => ProductListPage()), (route) => false);
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              color: Colors.white70,
              //height: 80,
              padding: EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  backgroundColor: Colors.transparent,
                  trailing: SizedBox.shrink(),
                  onExpansionChanged: (bool expanding) => setState(() => this.isExpand = expanding),
                  leading:  isExpand ? Icon(Icons.remove, color: Color(0xFFFF7643),) : Icon(Icons.add, color: Color(0xFFFF7643),),
                  title: Text('Add New Product', style: TextStyle(color: Colors.black45,fontSize: 18, fontWeight: FontWeight.w500),),
                  children: [
                    addNewProduct()
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            StreamBuilder<ProductModel>(
                stream: productBloc.productStream,
                builder: (c, s) {

                  if (s.connectionState != ConnectionState.active) {
                    print("all connection");
                    return Container(height: 300,
                        alignment: Alignment.center,
                        child: Center(
                          heightFactor: 50, child: CircularProgressIndicator(),));
                  }
                  if (s.hasError) {
                    print("as3 error");
                    return Container(height: 300,
                      alignment: Alignment.center,
                      child: Text("Error Loading Data",),);
                  }
                  if (s.data.product.length == 0) {
                    print("as3 empty");
                    return Container(height: 300,
                      alignment: Alignment.center,
                      child: Text("No Details Found",),);
                  }

                  as=s;
                  _order = s.data.product;


                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _searchView(),
                        _searchResult.length == 0 ? Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for(int i=0; i<s.data.product.length;i++)
                                s.data.product.length == 0 ? Container(height: 300,
                                  alignment: Alignment.center,
                                  child: Text("No Orders Found",),) :
                                AnimationConfiguration.staggeredList(
                                  position: i,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Container(
                                        //height: 40,
                                        child: _cartCard(s.data.product[i]),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ) :
                        Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              for(int i=0; i<_searchResult.length;i++)
                                AnimationConfiguration.staggeredList(
                                  position: i,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Container(
                                        //height: 40,
                                        child: _cartCard(_searchResult[i]),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartCard(Product product){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                width: 80,
                child: AspectRatio(
                  aspectRatio: 0.88,
                  child: Hero(
                    tag: product.image,
                    child: Image.network("${product.imagepath}${product.image[0]}",),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Text("Product Name: ${product.productName}", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
            ),
            SizedBox(width: 10,),
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => ProductEditPage(product: product)));
                        },
                        icon: Icon(Icons.edit_outlined, color: Colors.black,)),
                    IconButton(
                        onPressed: (){
                          //deleteProduct();
                        },
                        icon: Icon(Icons.delete_outline_outlined, color: kPrimaryColor,)),
                  ],
                ))
          ],
        ),
      ],
    );
  }

  Widget _searchView() {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.black,),
          SizedBox(width: 8,),
          Expanded(
            child: TextField(
              controller: searchView,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              onChanged: (value){
                setState(() {
                  search = true;
                  onSearchTextChangedICD(value);
                });
              },
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
              ),
            ),
          ),
        ],
      ),
    );
  }

  onSearchTextChangedICD(String text) async {
    _searchResult.clear();
    print("$text value from search");
    if (text.isEmpty) {
      setState(() {
        search = false;
      });
      return;
    }

    _order.forEach((exp) {
      if (exp.productName.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }

  Widget addNewProduct(){
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
                  _imageFile1 == null ? Container() : Image.file(_imageFile1, height: 100, width: 100, fit: BoxFit.cover)
                ],
              ),
            ),
            Center(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10),
                  child: DefaultButton(
                    text: "Add Product",
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
