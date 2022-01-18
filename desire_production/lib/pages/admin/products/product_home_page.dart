import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/accesory_bloc.dart';
import 'package:desire_production/bloc/category_bloc.dart';
import 'package:desire_production/bloc/customer_bloc.dart';
import 'package:desire_production/bloc/product_bloc.dart';
import 'package:desire_production/model/category_model.dart';
import 'package:desire_production/model/product_model.dart';
import 'package:desire_production/pages/admin/customer/customer_cart_page.dart';
import 'package:desire_production/pages/dashboards/dashboard_page_admin.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/drawer_admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'sales_accessory_list_page.dart';
import 'sales_acessory_detail_page.dart';
import 'sales_product_category_page.dart';
import 'sales_product_detail_page.dart';
import 'sales_product_list_page.dart';
import 'sales_product_search_page.dart';

class ProductHomePage extends StatefulWidget {

  final String customerId;
  final String salesId;
  final String customerName;

  const ProductHomePage({@required this.customerId, @required this.salesId, @required this.customerName});


  @override
  _ProductHomePageState createState() => _ProductHomePageState();
}

class _ProductHomePageState extends State<ProductHomePage> {

  final newProductBloc = ProductBloc();
  final bestProductBloc = ProductBloc();
  final futureProductBloc = ProductBloc();
  final categoryBloc = CategoryBloc();
  final accessorBloc = AccesoryBloc();
  final customerBloc = CustomerListBloc();

  TextEditingController searchController;


  @override
  void initState() {
    super.initState();
    checkConnectivity();
    newProductBloc.fetchNewProduct(widget.customerId);
    bestProductBloc.fetchBestProduct(widget.customerId);
    futureProductBloc.fetchFutureProduct(widget.customerId);
    categoryBloc.fetchCategories();
    accessorBloc.fetchAccessory(widget.customerId);
    searchController = TextEditingController();
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
    newProductBloc.dispose();
    bestProductBloc.dispose();
    futureProductBloc.dispose();
    categoryBloc.dispose();
    accessorBloc.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => ProductHomePage(customerId: widget.customerId, salesId: widget.salesId, customerName: widget.customerName,)));
      },
      child: WillPopScope(
        onWillPop: () {
          return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => DashboardPageAdmin()), (route) => false);
        },
        child: SafeArea(
          child: Scaffold(
              drawerEnableOpenDragGesture: false,
              appBar: AppBar(
                title: Text("Product Home Page"),
                centerTitle: true,
                elevation: 0,
                backgroundColor:kSecondaryColor.withOpacity(0),
                titleTextStyle: headingStyle,
                textTheme: Theme.of(context).textTheme,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5, right: 20),
                    child: iconBtnWithCounter("assets/icons/Cart Icon.svg",0,()async{
                      Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerCartPage(customerId: widget.customerId, customerName: widget.customerName, salesId: widget.salesId,)));
                    }),
                  ),
                ],
                leading: Builder(
                  builder: (c){
                    return IconButton(icon: Image.asset("assets/images/logo_new.png"), onPressed: (){
                      Scaffold.of(c).openDrawer();
                    },);
                  },
                ),
              ),
              drawer: DrawerAdmin(),
              body: _body(),

          ),
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
              _categories(),
              SizedBox(height: 10),
              _newArrival(),
              SizedBox(height: 10),
              _bestProduct(),
              SizedBox(height: 10),
              _futureProduct(),
              SizedBox(height: 10),
              _accessoryProduct(),
              SizedBox(height: 10,),
            ],
          )
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
          Navigator.push(context, MaterialPageRoute(builder: (c) => SalesProductSearchPage(search: searchController.text, customerId: widget.customerId, salesId: widget.salesId, customerName: widget.customerName,)));
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
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: kSecondaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(svgSrc,width: 20, height: 20,),
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

  Widget _categories(){
    return StreamBuilder<CategoryModel>(
        stream: categoryBloc.catStream,
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
          if (s.data
              .toString()
              .isEmpty) {
            print("as3 empty");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("No Data Found",),);
          }

          return Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    s.data.category.length,
                        (index) => CategoryCard(
                      icon: "assets/icons/sweetbox.svg",
                      text: s.data.category[index].categoryName,
                      press: () {
                        Navigator.push(context, MaterialPageRoute(builder: (builder) => SalesProductCategoryPage(id: s.data.category[index].categoryId, name: s.data.category[index].categoryName, salesId: widget.salesId, customerName: widget.customerName, customerId: widget.customerId,)));
                      },
                    ),
                  ),
                ),
              );
            }
          );
  }

  AsyncSnapshot<ProductModel> news;

  Widget _newArrival(){
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 20),
          child: _sectionTile("New Arrival Products", () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => SalesProductListPage(snapshot: news.data.product, title: "New Products", refresh: false,  salesId: widget.salesId, customerName: widget.customerName, customerId: widget.customerId,)));
          }),
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<ProductModel>(
              stream: newProductBloc.newProductStream,
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
                if (s.data
                    .toString()
                    .isEmpty) {
                  print("as3 empty");
                  return Container(height: 300,
                    alignment: Alignment.center,
                    child: Text("No Data Found",),);
                }
                news = s;
                print("object value for new arrival ${news.data.product.first.id}");
                return Row(
                  children: [
                    ...List.generate(
                      news.data.product.length,
                          (index) {
                        return ProductCard(product: news.data.product[index],  customerName: widget.customerName, customerId: widget.customerId, salesId: widget.salesId,);
                      },
                    ),
                    SizedBox(width: 20),
                  ],
                );
              }
          ),
        )
      ],
    );
  }

  AsyncSnapshot<ProductModel> bests;

  Widget _bestProduct(){
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 20),
          child: _sectionTile("Best Seller Products", () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => SalesProductListPage(snapshot: bests.data.product, title: "Best Seller Products", refresh: false,  salesId: widget.salesId, customerName: widget.customerName, customerId: widget.customerId,)));
          }),
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<ProductModel>(
              stream: bestProductBloc.bestProductStream,
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
                if (s.data.product == null) {
                  print("as3 empty");
                  return Container(height: 300,
                    alignment: Alignment.center,
                    child: Text("No Data Found",),);
                }
                bests = s;
                print("object value for new arrival ${bests.data.product.first.id}");
                return Row(
                  children: [
                    ...List.generate(
                      bests.data.product.length,
                          (index) {
                        return ProductCard(product: bests.data.product[index],  customerName: widget.customerName, customerId: widget.customerId, salesId: widget.salesId,);
                      },
                    ),
                    SizedBox(width: 20),
                  ],
                );
              }
          ),
        )
      ],
    );
  }

  AsyncSnapshot<ProductModel> futures;

  Widget _futureProduct(){
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 20),
          child: _sectionTile("UpComing Products", () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => SalesProductListPage(snapshot: futures.data.product, title: "UpComing Products", refresh: false,  salesId: widget.salesId, customerName: widget.customerName, customerId: widget.customerId,)));
          }),
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<ProductModel>(
              stream: futureProductBloc.futureProductStream,
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
                if (s.data.product == null) {
                  print("as3 empty");
                  return Container(height: 300,
                    alignment: Alignment.center,
                    child: Text("No Data Found",),);
                }
                futures = s;
                print("object value for new arrival ${futures.data.product.first.id}");
                return Row(
                  children: [
                    ...List.generate(
                      futures.data.product.length,
                          (index) {
                        return ProductCard(product: futures.data.product[index],  customerName: widget.customerName, customerId: widget.customerId, salesId: widget.salesId,);
                      },
                    ),
                    SizedBox(width: 20),
                  ],
                );
              }
          ),
        )
      ],
    );
  }

  AsyncSnapshot<ProductModel> accessories;

  Widget _accessoryProduct(){
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 20),
          child: _sectionTile("Accessories", () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => SalesAccessoryListPage( title: "Accessories List",snapshot: accessories.data.product,refresh: false, salesId: widget.salesId, customerName: widget.customerName, customerId: widget.customerId,)));
          }),
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<ProductModel>(
              stream: accessorBloc.newAccessoryStream,
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
                if (s.data
                    .toString()
                    .isEmpty) {
                  print("as3 empty");
                  return Container(height: 300,
                    alignment: Alignment.center,
                    child: Text("No Data Found",),);
                }
                accessories = s;
                print("object value for new arrival ${accessories.data.product.first.id}");
                return Row(
                  children: [
                    ...List.generate(
                      accessories.data.product.length,
                          (index) {
                        return GestureDetector(
                            onTap: (){
                              //Navigator.push(context, MaterialPageRoute(builder: (c) => ProductDetailPage()));
                            },
                            child: AccessoryCard(product: accessories.data.product[index], customerName: widget.customerName, customerId: widget.customerId, salesId: widget.salesId,));
                      },
                    ),
                    SizedBox(width: 20),
                  ],
                );
              }
          ),
        )
      ],
    );
  }

  Widget _sectionTile(String title, Function press){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            "See More",
            style: TextStyle(color: Color(0xFFBBBBBB)),
          ),
        ),
      ],
    );
  }

}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(icon),
            ),
            SizedBox(height: 5),
            Text(text, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({
    this.width = 140,
    this.aspectRatio = 1.02,
    @required this.product, @required this.customerId, @required this.customerName, @required this.salesId,
  });

  final double width, aspectRatio;
  final Product product;
  final String customerId;
  final String customerName;
  final String salesId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: SizedBox(
        width: width,
        child: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => SalesProductDetailsPage(product: product, customerName: customerName, customerId: customerId, salesId: salesId,))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Hero(
                    tag: product.id.toString(),
                    child: Image.network("http://loccon.in/desiremoulding/upload/Image/Product/${product.image[0]}"),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.productName,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹${product.Customernewprice}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AccessoryCard extends StatelessWidget {
  const AccessoryCard({
    this.width = 140,
    this.aspectRatio = 1.02,
    @required this.product, @required this.customerId, @required this.customerName, @required this.salesId,
  });

  final double width, aspectRatio;
  final Product product;
  final String customerId;
  final String customerName;
  final String salesId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: SizedBox(
        width: width,
        child: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => SalesAccessoryDetailPage(product: product, customerName: customerName, customerId: customerId, salesId: salesId,))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.02,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Hero(
                    tag: product.id.toString(),
                    child: Image.network("http://loccon.in/desiremoulding/upload/Image/Product/${product.image[0]}"),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.productName,
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹${product.Customernewprice}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
