import 'package:desire_production/model/all_category.dart';
import 'package:desire_production/model/all_product_list_model.dart';
import 'package:desire_production/pages/admin/add_products/all_dimensions_page.dart';
import 'package:desire_production/pages/admin/add_products/all_model_no_page.dart';
import 'package:desire_production/pages/admin/add_products/all_product_category_list.dart';
import 'package:desire_production/pages/admin/add_products/all_product_page.dart';
import 'package:desire_production/pages/admin/products/model_list_page.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Products",style: TextStyle(
            color: Colors.black
        ),),
        centerTitle: true,
        backgroundColor: Colors.white,

      ),
      body: productView(),
    );
  }


  Widget productView(){
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10,bottom: 10),
      child: ListView(

        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return AllModelNoPage();
              }));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 1,
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/model_list.png",height: 40,width:40,color: kPrimaryColor,),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("All Model",style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 5),
                        Text("Get list of all models",style: TextStyle(
                          color:kSecondaryColor,
                          fontSize: 14,

                        ),),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return AllProductCategoryList();
              }));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 1,
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/category.png",height: 40,width:40,color: kPrimaryColor,),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("All Category",style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 5),
                        Text("Get list of all categories",style: TextStyle(
                          color:kSecondaryColor,
                          fontSize: 14,

                        ),),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return AllDimensionsPage();
              }));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 1,
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/dimensions.png",height: 40,width:40,color: kPrimaryColor,),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Dimensions",style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 5),
                        Text("Get list of all dimensions",style: TextStyle(
                          color:kSecondaryColor,
                          fontSize: 14,

                        ),),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return AllProductPage();
              }));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 1,
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/product_list.png",height: 40,width:40,color: kPrimaryColor,),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("All Products",style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 5),
                        Text("Get list of all products",style: TextStyle(
                          color:kSecondaryColor,
                          fontSize: 14,

                        ),),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
