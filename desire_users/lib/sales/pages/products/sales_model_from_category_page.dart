import 'package:desire_users/bloc/modelFromCategoryBloc.dart';
import 'package:desire_users/models/modelNumberFromCategoryModel.dart';
import 'package:desire_users/sales/pages/products/sales_product_from_model_page.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';

class SalesModelFromCategoryPage extends StatefulWidget {
  final categoryId, categoryName,customerId,customerName;

  const SalesModelFromCategoryPage({Key key,this.categoryId,this.categoryName,this.customerId,this.customerName}) : super(key: key);

  @override
  _SalesModelFromCategoryPageState createState() => _SalesModelFromCategoryPageState();
}

class _SalesModelFromCategoryPageState extends State<SalesModelFromCategoryPage> {

  final modelFromCategoryBloc = ModelFromCategoryBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.customerId);
    modelFromCategoryBloc.fetchModelFromCategories(widget.categoryId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    modelFromCategoryBloc.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName,style: TextStyle(color: kBlackColor),),
        centerTitle: true,
        backgroundColor: kWhiteColor,
        iconTheme: IconThemeData(
          color: kBlackColor
        ),
      ),
      body: RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: (){
            return  Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesModelFromCategoryPage(categoryId:widget.categoryId ,categoryName: widget.categoryName,customerName: widget.customerName,customerId: widget.customerId,)));
          },
          child: view()),
    );
  }



  Widget view(){
    return StreamBuilder<ModelNoFromCategoryModel>(
        stream: modelFromCategoryBloc.modelFromCategoryStream,
        builder: (c,s){
          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50, child: CircularProgressIndicator(
                  color: kPrimaryColor,
                ),));
          }
          if (s.hasError) {
            print("as3 error");
            print(s.error);
            return Container(height: 300,
              alignment: Alignment.center,
              child: SelectableText("Error Loading Data ${s.error}",),);
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
            padding: const EdgeInsets.only(top: 20),
            child: GridView.count(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              childAspectRatio: 4/4,
              crossAxisCount: 3,
              children: List.generate(
                s.data.data.length,
                    (index) =>
                    CategoryCard(
                      text: s.data.data[index].modelNo,
                      text2: s.data.data[index].size,
                      image: "${s.data.imagepath}"+"${s.data.data[index].image}",
                      press: () {

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SalesProductFromModelPage(
                          customerId:widget.customerId ,
                          modelNo:s.data.data[index].modelNo ,
                          modelNoId: s.data.data[index].modelNoId,
                          customerName: widget.customerName,
                        )));

                      },
                    ),
              ),
            ),
          );




        }

    );


  }

}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key key,
    @required this.icon,
    @required this.text,
    @required this.press,
    @required this.text2,
    @required this.image,
  }) : super(key: key);

  final String icon, text, text2,image;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10,bottom: 10),
        child: GestureDetector(
          onTap: press,
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                  ),],
                  color: kWhiteColor
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(image,height: 60,width: 60,),
                    SizedBox(height: 10,),
                    Expanded(child: Text("Model No :" + text,style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: 12),))
                  ],
                ),
              )),
        )
    );
  }
}