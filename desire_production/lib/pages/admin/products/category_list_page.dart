import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/category_list_bloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/category_list_model.dart';
import 'package:desire_production/pages/admin/products/category_edit_page.dart';
import 'package:desire_production/pages/dashboards/admin_dashboard_page.dart';
import 'package:desire_production/pages/dashboards/dashboard_page_admin.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/drawer_admin.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';


class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> with Validator{
  final productBloc = CategoryListBloc();

  List<Category> send = [];

  AsyncSnapshot<CategoryListModel> as;

  TextEditingController searchView;
  bool search = false;
  List<Category> _searchResult = [];
  List<Category> _order = [];

  bool isExpand = false;

  File _imageFile1;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    searchView = TextEditingController();
    productBloc.fetchCategories();
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
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => AdminDashboardPage()));
      },
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              // leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => SalesHomePage()));
              // },),
              title: Text("Category List", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
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
                            child: Text("Log Out", textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
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
      color: kPrimaryColor,
      onRefresh:(){
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => CategoryListPage()), (route) => false);
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
                  leading:  isExpand ? Icon(Icons.remove, color: kPrimaryColor,) : Icon(Icons.add, color:kPrimaryColor,),
                  title: Text('Add New Category', style: TextStyle(color: Colors.black45,fontSize: 18, fontWeight: FontWeight.w500),),
                  children: [
                    addNewCategory()
                  ],
                ),
              ),
            ),
            //SizedBox(height: 10,),
            StreamBuilder<CategoryListModel>(
                stream: productBloc.catStream,
                builder: (c, s) {

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
                    return Container(height: 300,
                      alignment: Alignment.center,
                      child: Text("Error Loading Data",),);
                  }
                  if (s.data.category.length == 0) {
                    print("as3 empty");
                    return Container(height: 300,
                      alignment: Alignment.center,
                      child: Text("No Details Found",),);
                  }

                  as=s;
                  _order = s.data.category;


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
                              for(int i=0; i<s.data.category.length;i++)
                                s.data.category.length == 0 ? Container(height: 300,
                                  alignment: Alignment.center,
                                  child: Text("No Orders Found",),) :
                                AnimationConfiguration.staggeredList(
                                  position: i,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Container(
                                        //height: 100,
                                        child: _cartCard(s.data.category[i]),
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

  Widget _cartCard(Category product){
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
                  child: SvgPicture.asset(
                    "assets/icons/regular.svg",
                    color: kPrimaryColor,
                    width: 30,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Text("Category Name: ${product.categoryName}", style: TextStyle(color: Colors.black, fontSize: 14), textAlign: TextAlign.start,),
            ),
            SizedBox(width: 10,),
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => CategoryEditPage(category: product,)));
                        },
                        icon: Icon(Icons.edit_outlined, color: Colors.black,)),
                    IconButton(
                        onPressed: (){
                          //deleteCategory();
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
      if (exp.categoryName.contains(text))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }

  Widget addNewCategory(){
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
                //controller: name,
                decoration: InputDecoration(
                  labelText: 'Category Name',
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
                //controller: name,
                decoration: InputDecoration(
                  labelText: 'Description',
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
                  Text("Category Image", style: TextStyle(color: Colors.grey, fontSize: 18),),
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
                      left: 25.0, right: 25.0, top: 10),
                  child: DefaultButton(
                    text: "Add Category",
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
