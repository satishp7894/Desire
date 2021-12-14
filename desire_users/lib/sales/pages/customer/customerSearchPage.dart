import 'package:desire_users/bloc/userSearchingBloc.dart';
import 'package:desire_users/models/userSearchingModel.dart';
import 'package:desire_users/sales/pages/products/salesProductFromModelDetailPage.dart';
import 'package:desire_users/sales/pages/products/sales_model_from_category_page.dart';
import 'package:desire_users/sales/pages/products/sales_product_from_model_page.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomerSearchPage extends StatefulWidget {
  final customerId,customerName;
  final searchKeyword;
  const CustomerSearchPage({Key key,this.customerId,this.searchKeyword,this.customerName}) : super(key: key);

  @override
  _CustomerSearchPageState createState() => _CustomerSearchPageState();
}

class _CustomerSearchPageState extends State<CustomerSearchPage> {

  final userSearchedBloc = UserSearchingBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userSearchedBloc.fetchSearchResults(widget.searchKeyword, widget.customerId);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userSearchedBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Result"),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: _searchField(),
        ),
      ),
      body: body(),



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
        textInputAction: TextInputAction.search,
        cursorColor: kBlackColor,
        readOnly: true,
        decoration: InputDecoration(
            hintText: widget.searchKeyword,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            prefixIcon: Icon(Icons.search,color: kPrimaryColor,)),
      ),
    );
  }
  AsyncSnapshot<UserSearchingModel> userSearchedSnapshot;
  Widget body(){
    return StreamBuilder(
        stream: userSearchedBloc.userSearchingStream,
        builder: (c, s){
          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50, child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),));
          }
          else if (s.hasError) {
            print("as3 error");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("Error Loading Data",),);
          }
          else if (s.data
              .toString()
              .isEmpty) {
            print("as3 empty");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("No Data Found",),);
          }
          userSearchedSnapshot = s;
          return userSearchedSnapshot.data.status  == false ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text("No Category, Model No. or Product has found from " +"${widget.searchKeyword}".toUpperCase(),textAlign: TextAlign.center,style: TextStyle(
                  color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14
              ),),
            ),
          ): SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                userSearchedSnapshot.data.categoryList.length != 0 ? Padding(
                  padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Category",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...List.generate(
                              userSearchedSnapshot.data.categoryList.length,
                                  (index) {
                                return CategoryCard(categoryList: userSearchedSnapshot.data.categoryList[index],customerId: widget.customerId,customerName: widget.customerName,);
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ): Container(),
                SizedBox(height: 20),
                userSearchedSnapshot.data.modelNoList.length != 0 ?    Padding(
                    padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Model No",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(

                                userSearchedSnapshot.data.modelNoList.length,
                                    (index) {
                                  return ModelCard(modelNoList: userSearchedSnapshot.data.modelNoList[index],imagePath: "http://loccon.in/desiremoulding/upload/Image/Dimensions/",customerName: widget.customerName,customerId: widget.customerId,);
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    )
                ): Container(),
                SizedBox(height: 20),
                userSearchedSnapshot.data.productList.length != 0 ?  Padding(
                  padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Products",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...List.generate(

                              userSearchedSnapshot.data.productList.length,
                                  (index) {
                                return ProductCard(productList: userSearchedSnapshot.data.productList[index],customerId: widget.customerId,productId: userSearchedSnapshot.data.productList[index].id,);
                              },
                            ),SizedBox(height: 20),
                          ],
                        ),
                      )
                    ],
                  ),
                ): Container(),

              ],
            ),
          );
        });

  }


}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    this.categoryList,this.customerId , this.customerName
  }) : super(key: key);

  final CategoryList categoryList;
  final String customerId, customerName;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesModelFromCategoryPage(categoryId:categoryList.categoryId ,categoryName:categoryList.categoryName,customerId:customerId,customerName: customerName,)));
      },
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Color(0xFFFFECDF),
                borderRadius: BorderRadius.circular(10),
              ),
              child:SvgPicture.asset("assets/icons/sweetbox.svg"),
            ),
            SizedBox(height: 5),
            Text(categoryList.categoryName, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}




class ModelCard extends StatelessWidget {
  const ModelCard({
    this.width = 150,
    this.aspectRatio = 1.02,
    @required this.modelNoList,
    this.customerId,this.imagePath,
    this.customerName
  });


  final ModelNoList modelNoList;
  final double width, aspectRatio;
  final customerId,customerName;
  final imagePath;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: SizedBox(
        width: width,
        child: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesProductFromModelPage(
            customerId: customerId ,
            modelNo:modelNoList.modelNo ,
            modelNoId:  modelNoList.modelNoId,
            customerName: customerName,
          ))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Container(
                child: AspectRatio(
                  aspectRatio: 5/5,
                  child: Hero(
                    tag: modelNoList.modelNoId.toString(),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                            ),],
                            color: kWhiteColor
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network("$imagePath"+"${modelNoList.image}"),
                        )),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  "Model No." + modelNoList.modelNo.toUpperCase(),
                  style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),
                  //maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ProductCard extends StatelessWidget {
  const ProductCard({
    this.width = 150,
    this.aspectRatio = 1.02,
    @required this.productList,
    @required this.orderCount, this.customerId, this.productId});

  final double width, aspectRatio;
  final customerId , productId;
  final ProductList productList;
  final int orderCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: SizedBox(
        width: width,
        child: GestureDetector(
          onTap: () =>   Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesProductFromModelDetailPage(
            customerId: customerId,
            productId: productId,
          ))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Container(
                child: AspectRatio(
                  aspectRatio: 5/5,
                  child: Hero(
                    tag: productList.id.toString(),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                            ),],
                            color: kWhiteColor
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network("http://loccon.in/desiremoulding/upload/Image/Product/${productList.image[0]}"),
                        )),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: Text(
                  productList.productName.toUpperCase(),
                  style: TextStyle(color: kBlackColor,fontWeight: FontWeight.bold,fontSize: 14),
                  //maxLines: 1,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MRP: " "₹${productList.customerprice}",
                    style: TextStyle(
                      decoration:   productList.customernewprice == "" ?TextDecoration.none: TextDecoration.lineThrough,
                      fontSize:  productList.customernewprice == "" ? 14:12,
                      fontWeight: FontWeight.w600,
                      color: productList.customernewprice == "" ? kPrimaryColor :kSecondaryColor,
                    ),
                  ),
                  Text(
                    productList.customernewprice == "" ? "": "Your Price: "+"₹${productList.customernewprice}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:kPrimaryColor,
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

