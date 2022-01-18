
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/model_list_bloc.dart';
import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/model_listing_model.dart';
import 'package:desire_production/pages/admin/products/model_edit_page.dart';
import 'package:desire_production/pages/dashboards/dashboard_page_admin.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/drawer_admin.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';

class ModelListPage extends StatefulWidget {

  final String userId;

  const ModelListPage({@required this.userId});



  @override
  _ModelListPageState createState() => _ModelListPageState();
}

class _ModelListPageState extends State<ModelListPage> with Validator{
  final productBloc = ModelListBloc();

  AsyncSnapshot<ModelListingModel> as;

  TextEditingController searchView;
  bool search = false;
  List<ModelList> _searchResult = [];
  List<ModelList> _order = [];

  bool isExpand = false;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController model;
  TextEditingController sPrice;
  TextEditingController dPrice;
  TextEditingController cPrice;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    searchView = TextEditingController();
    productBloc.fetchModelList1();
    model = TextEditingController();
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
    model.dispose();
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
              title: Text("Model List", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
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
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => ModelListPage(userId: widget.userId,)), (route) => false);
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
                  leading:  isExpand ? Icon(Icons.remove, color: kPrimaryColor,) : Icon(Icons.add, color: kPrimaryColor,),
                  title: Text('Add New Models', style: TextStyle(color: Colors.black45,fontSize: 18, fontWeight: FontWeight.w500),),
                  children: [
                    addNewProduct()
                  ],
                ),
              ),
            ),
            StreamBuilder<ModelListingModel>(
                stream: productBloc.productStream1,
                builder: (c, s) {

                  if (s.connectionState != ConnectionState.active) {
                    print("all connection");
                    return Container(height: 300,
                        alignment: Alignment.center,
                        child: Center(
                          heightFactor: 50, child: CircularProgressIndicator(color: kPrimaryColor,),));
                  }
                  if (s.hasError) {
                    print("as3 error");
                    return Container(height: 300,
                      alignment: Alignment.center,
                      child: Text("Error Loading Data",),);
                  }
                  if (s.data.modelList.length == 0) {
                    print("as3 empty");
                    return Container(height: 300,
                      alignment: Alignment.center,
                      child: Text("No Details Found",),);
                  }

                  as=s;
                  _order = s.data.modelList;


                  return Container(
                    padding: EdgeInsets.all(5),
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
                              for(int i=0; i<s.data.modelList.length;i++)
                                s.data.modelList.length == 0 ? Container(height: 300,
                                  alignment: Alignment.center,
                                  child: Text("No Models Found",),) :
                                AnimationConfiguration.staggeredList(
                                  position: i,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 120,
                                            child: _cartCard(s.data.modelList[i]),
                                          ),
                                          Divider(height: 1,thickness: 1, color: Colors.grey,),
                                          SizedBox(height: 10,)
                                        ],
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
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 120,
                                            child: _cartCard(_searchResult[i]),
                                          ),
                                          Divider(height: 1,thickness: 1, color: Colors.grey,),
                                          SizedBox(height: 10,)
                                        ],
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

  Widget _cartCard(ModelList product){
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
                    tag: "product.image",
                    child: SvgPicture.asset(
                      "assets/icons/sweetbox.svg",
                      color: kPrimaryColor,
                      width: 30,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Model Name: ${product.modelNo}", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.start,),
                  SizedBox(height: 10,),
                  Text("Customer Price: 100", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
                  Text("Sales Price: 120", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
                  //Text("Old Price: ${product.listOldPrice}", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400), textAlign: TextAlign.start,),
                ],
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (builder) => ModelEditPage(model: product, userId: widget.userId,)));
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
      if (exp.modelNo.toLowerCase().contains(text.toLowerCase()))
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
              padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
              child: TextFormField(
                validator: validateRequired,
                keyboardType: TextInputType.number,
                controller: dPrice,
                decoration: InputDecoration(
                  labelText: 'Price',
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
            Center(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10),
                  child: DefaultButton(
                    text: "Add Model",
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
