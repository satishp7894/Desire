import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/accesory_bloc.dart';
import 'package:desire_users/bloc/all_model_bloc.dart';
import 'package:desire_users/bloc/category_bloc.dart';
import 'package:desire_users/bloc/product_bloc.dart';
import 'package:desire_users/models/allModel.dart';
import 'package:desire_users/models/category_model.dart';
import 'package:desire_users/models/product_model.dart';
import 'package:desire_users/models/sales_customer_list_model.dart';
import 'package:desire_users/pages/home/modelFromCategoryPage.dart';
import 'package:desire_users/pages/home/model_list_page.dart';
import 'package:desire_users/pages/product/productFromModelPage.dart';
import 'package:desire_users/sales/bloc/customer_bloc.dart';
import 'package:desire_users/sales/pages/customer/customerSearchPage.dart';
import 'package:desire_users/sales/pages/customerCart/customer_cart_page.dart';
import 'package:desire_users/sales/pages/products/salesProductFromModelDetailPage.dart';
import 'package:desire_users/sales/pages/products/sales_accessory_list_page.dart';
import 'package:desire_users/sales/pages/products/sales_model_from_category_page.dart';
import 'package:desire_users/sales/pages/products/sales_product_detail_page.dart';
import 'package:desire_users/sales/pages/products/sales_product_from_model_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/sales/utils_sales/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sales_acessory_detail_page.dart';
import 'sales_product_category_page.dart';
import 'sales_product_list_page.dart';
import 'sales_product_search_page.dart';

class ProductHomePage extends StatefulWidget {
  final customerId, customerName;

  ProductHomePage({this.customerId, this.customerName});

  @override
  _ProductHomePageState createState() => _ProductHomePageState();
}

class _ProductHomePageState extends State<ProductHomePage> {
  final newProductBloc = ProductBloc();
  final allModelBloc = AllModelBloc();
  final bestProductBloc = ProductBloc();
  final futureProductBloc = ProductBloc();
  final categoryBloc = CategoryBloc();
  final accessorBloc = AccesoryBloc();
  final customerBloc = CustomerListBloc();

  TextEditingController searchController;

  List<UserModel> customersList = [];

  String salesId;
  String customerId;
  String customerName;

  String salesEmail, salesName;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    getID();
    print(widget.customerId);
    newProductBloc.fetchNewProduct(widget.customerId);
    allModelBloc.fetchAllModel(widget.customerId);
    bestProductBloc.fetchBestProduct(widget.customerId);
    futureProductBloc.fetchFutureProduct(widget.customerId);
    categoryBloc.fetchCategories(widget.customerId);
    accessorBloc.fetchAccessory(widget.customerId);
    print("object customer list ${customersList.length}");
    searchController = TextEditingController();
  }

  checkConnectivity() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(
          context, "No Internet Connection", "Please check your internet");
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

  getID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      salesId = prefs.getString("sales_id");
      customerId = prefs.getString("customer_id");
      customerName = prefs.getString("customer_name");
      salesEmail = prefs.getString("sales_email");
      salesName = prefs.getString("sales_name");
    });
    print("object $customerId");
    customerBloc.fetchCustomerList(salesId ?? " ");
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () {
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (c) => ProductHomePage(
                      customerId: widget.customerId,
                      customerName: widget.customerName,
                    )));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kWhiteColor,
            iconTheme: IconThemeData(color: kBlackColor),
            title: Text(
              "Products for ${widget.customerName}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kBlackColor),
            ),
            centerTitle: true,
            textTheme: Theme.of(context).textTheme,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(30),
              child: _searchField(),
            ),
          ),
          body: _body(),
        ),
      ),
    );
  }

  AsyncSnapshot<AllModel> allModelSnapshot;

  Widget allModelView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _sectionTile("All Model", () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => ModelListPage(
                          customerId: widget.customerId,
                          customerName: widget.customerName,
                        )));
          }, "1"),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          child: StreamBuilder<AllModel>(
              stream: allModelBloc.allModelStream,
              builder: (c, s) {
                if (s.connectionState != ConnectionState.active) {
                  print("all connection");
                  return Container(
                      height: 300,
                      alignment: Alignment.center,
                      child: Center(
                        heightFactor: 50,
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      ));
                }
                if (s.hasError) {
                  print("as3 error");
                  return Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: Text(
                      "Error Loading Data",
                    ),
                  );
                }
                if (s.data.toString().isEmpty) {
                  print("as3 empty");
                  return Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: Text(
                      "No Data Found",
                    ),
                  );
                }
                allModelSnapshot = s;
                print(
                    "object value for new arrival ${allModelSnapshot.data.data.first.modelNoId}");
                return Row(
                  children: [
                    ...List.generate(
                      allModelSnapshot.data.data.length,
                      (index) {
                        return ModelCard(
                          data: allModelSnapshot.data.data[index],
                          snapshot: allModelSnapshot.data.data,
                          orderCount: 0,
                          customerId: widget.customerId,
                          imagePath: allModelSnapshot.data.imagepath,
                          customerName: widget.customerName,
                        );
                      },
                    ),
                    SizedBox(width: 20),
                  ],
                );
              }),
        )
      ],
    );
  }

  Widget _body() {
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            _categories(),
            SizedBox(height: 10),
            allModelView(),
            SizedBox(height: 10),
            _newArrival(),
            SizedBox(height: 10),
            _bestProduct(),
            SizedBox(height: 10),
          ],
        ));
  }

  Widget _searchField() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kSecondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: searchController,
        cursorColor: kBlackColor,
        textInputAction: TextInputAction.search,
        onEditingComplete: () {
          print(searchController.text);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => CustomerSearchPage(
                        searchKeyword: searchController.text,
                        customerId: widget.customerId,
                        customerName: widget.customerName,
                      )));
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: "Search product",
            prefixIcon: Icon(
              Icons.search,
              color: kPrimaryColor,
            )),
      ),
    );
  }

  Widget iconBtnWithCounter(
    String svgSrc,
    int numOfItem,
    Function() press,
  ) {
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
            child: SvgPicture.asset(
              svgSrc,
              width: 20,
              height: 20,
            ),
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

  Widget _categories() {
    return StreamBuilder<CategoryModel>(
        stream: categoryBloc.catStream,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(
                height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50,
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ));
          }
          if (s.hasError) {
            print("as3 error");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "Error Loading Data",
              ),
            );
          }
          if (s.data.toString().isEmpty) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                s.data.data.length,
                (index) => CategoryCard(
                  icon: "assets/icons/sweetbox.svg",
                  text: s.data.data[index].categoryName,
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalesModelFromCategoryPage(
                                  categoryId: s.data.data[index].categoryId,
                                  categoryName: s.data.data[index].categoryName,
                                  customerId: widget.customerId,
                                  customerName: widget.customerName,
                                )));
                  },
                ),
              ),
            ),
          );
        });
  }

  AsyncSnapshot<ProductModel> news;

  Widget _newArrival() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _sectionTile("New Arrival Products", () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => SalesProductListPage(
                          snapshot: news.data.product,
                          title: "New Products",
                          refresh: false,
                          customerList: customersList,
                        )));
          }, "2"),
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<ProductModel>(
              stream: newProductBloc.newProductStream,
              builder: (c, s) {
                if (s.connectionState != ConnectionState.active) {
                  print("all connection");
                  return Container(
                      height: 300,
                      alignment: Alignment.center,
                      child: Center(
                        heightFactor: 50,
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      ));
                }
                if (s.hasError) {
                  print("as3 error");
                  return Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: Text(
                      "Error Loading Data",
                    ),
                  );
                }
                if (s.data.toString().isEmpty) {
                  print("as3 empty");
                  return Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: Text(
                      "No Data Found",
                    ),
                  );
                }
                news = s;
                print(
                    "object value for new arrival ${news.data.product.first.id}");
                return Row(
                  children: [
                    ...List.generate(
                      news.data.product.length,
                      (index) {
                        return ProductCard(
                          product: news.data.product[index],
                          customerList: customersList,
                          snapshot: news.data.product,
                          productId: news.data.product[index].id,
                          customerId: widget.customerId,
                        );
                      },
                    ),
                    SizedBox(width: 20),
                  ],
                );
              }),
        )
      ],
    );
  }

  AsyncSnapshot<ProductModel> bests;

  Widget _bestProduct() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: _sectionTile("Best Seller Products", () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => SalesProductListPage(
                          snapshot: bests.data.product,
                          title: "Best Seller Products",
                          refresh: false,
                          customerList: customersList,
                          customerId: widget.customerId,
                        )));
          }, "3"),
        ),
        SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: StreamBuilder<ProductModel>(
              stream: bestProductBloc.bestProductStream,
              builder: (c, s) {
                if (s.connectionState != ConnectionState.active) {
                  print("all connection");
                  return Container(
                      height: 300,
                      alignment: Alignment.center,
                      child: Center(
                        heightFactor: 50,
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                        ),
                      ));
                }
                if (s.hasError) {
                  print("as3 error");
                  return Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: Text(
                      "Error Loading Data",
                    ),
                  );
                }
                if (s.data.product == null) {
                  print("as3 empty");
                  return Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: Text(
                      "No Data Found",
                    ),
                  );
                }
                bests = s;
                print(
                    "object value for new arrival ${bests.data.product.first.id}");
                return Row(
                  children: [
                    ...List.generate(
                      bests.data.product.length,
                      (index) {
                        return ProductCard(
                          product: bests.data.product[index],
                          customerList: customersList,
                          snapshot: bests.data.product,
                          customerId: widget.customerId,
                          productId: bests.data.product[index].id,
                        );
                      },
                    ),
                    SizedBox(width: 20),
                  ],
                );
              }),
        )
      ],
    );
  }

  AsyncSnapshot<ProductModel> futures;

/*  Widget _futureProduct(){
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 20),
          child: _sectionTile("UpComing Products", () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => SalesProductListPage(snapshot: futures.data.product, title: "UpComing Products", refresh: false,customerList: customersList,)));
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
                        heightFactor: 50, child: CircularProgressIndicator( color: kPrimaryColor,),));
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
                        return ProductCard(product: futures.data.product[index], customerList: customersList, snapshot: futures.data.product,);
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
  }*/

  AsyncSnapshot<ProductModel> accessories;

  /*Widget _accessoryProduct(){
    return Column(
      children: [
        Padding(
          padding:
          EdgeInsets.symmetric(horizontal: 20),
          child: _sectionTile("Accessories", () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => SalesAccessoryListPage( title: "Accessories List",snapshot: accessories.data.product,refresh: false,customerId : widget.customerId,)));
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
                        heightFactor: 50, child: CircularProgressIndicator( color: kPrimaryColor,),));
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
                            child: AccessoryCard(product: accessories.data.product[index], customerList: customersList, snapshot: accessories.data.product,));
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
  }*/

  Widget _sectionTile(String title, Function press, String type) {
    return Card(
      margin: EdgeInsets.zero,
      color: type == "2" ? kPrimaryColor : kPrimaryLightColor,
      child: Container(
        margin: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: kWhiteColor,
              ),
            ),
            GestureDetector(
              onTap: press,
              child: Text(
                "See More",
                style:
                    TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
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
  const ProductCard(
      {this.width = 140,
      this.aspectRatio = 1.02,
      @required this.product,
      @required this.customerList,
      @required this.snapshot,
      this.productModel,
      this.customerId,
      this.productId});

  final double width, aspectRatio;
  final Product product;
  final ProductModel productModel;
  final List<Product> snapshot;
  final List<UserModel> customerList;
  final customerId, productId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => SalesProductFromModelDetailPage(
                      customerId: customerId,
                      productId: productId,
                    )));
      },
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                  "http://loccon.in/desiremoulding/upload/Image/Product/${product.image[0]}",
                  height: 150),
              // SizedBox(height: 10),
              Container(
                width: 110,
                child: Text(
                  product.productName.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: kBlackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  //maxLines: 1,
                ),
              ),
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MRP: " "₹${product.customerprice}",
                    style: TextStyle(
                      decoration: product.customernewprice == ""
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                      fontSize: product.customernewprice == "" ? 14 : 12,
                      fontWeight: FontWeight.w600,
                      color: product.customernewprice == ""
                          ? kPrimaryColor
                          : kSecondaryColor,
                    ),
                  ),
                  Text(
                    product.customernewprice == ""
                        ? ""
                        : "Your Price: " + "₹${product.customernewprice}",
                    style: TextStyle(
                      fontSize: 12,
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
  const AccessoryCard(
      {this.width = 140,
      this.aspectRatio = 1.02,
      @required this.product,
      @required this.customerList,
      @required this.snapshot,
      this.productModel});

  final double width, aspectRatio;
  final Product product;
  final ProductModel productModel;
  final List<Product> snapshot;
  final List<UserModel> customerList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: SizedBox(
        width: width,
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => SalesAccessoryDetailPage(
                        page: "home",
                        product: product,
                        customerList: customerList,
                        snapshot: snapshot,
                      ))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 5 / 5,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),
                      ],
                      color: kWhiteColor),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Hero(
                      tag: product.id.toString(),
                      child: Image.network(
                          "http://loccon.in/desiremoulding/upload/Image/Product/${product.image[0]}"),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.productName.toUpperCase(),
                style: TextStyle(color: Colors.black),
                maxLines: 2,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MRP: " "₹${product.customerprice}",
                    style: TextStyle(
                      decoration: product.customernewprice == ""
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                      fontSize: product.customernewprice == "" ? 14 : 12,
                      fontWeight: FontWeight.w600,
                      color: product.customernewprice == ""
                          ? kPrimaryColor
                          : kSecondaryColor,
                    ),
                  ),
                  Text(
                    product.customernewprice == ""
                        ? ""
                        : "Your Price " + "₹${product.customernewprice}",
                    style: TextStyle(
                      fontSize: 12,
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

class ModelCard extends StatelessWidget {
  const ModelCard(
      {this.width = 150,
      this.aspectRatio = 1.02,
      @required this.data,
      @required this.snapshot,
      @required this.orderCount,
      this.allModel,
      this.customerId,
      this.imagePath,
      this.customerName});

  final double width, aspectRatio;
  final Data data;
  final AllModel allModel;
  final List<Data> snapshot;
  final customerId;
  final customerName;
  final imagePath;
  final int orderCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: SizedBox(
        width: width,
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SalesProductFromModelPage(
                        customerId: customerId,
                        modelNo: data.modelNo,
                        modelNoId: data.modelNoId,
                        customerName: customerName,
                      ))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                child: AspectRatio(
                  aspectRatio: 5 / 5,
                  child: Hero(
                    tag: data.modelNoId.toString(),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                              ),
                            ],
                            color: kWhiteColor),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network("$imagePath" + "${data.image}"),
                        )),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Model No." + data.modelNo.toUpperCase(),
                style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                //maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
