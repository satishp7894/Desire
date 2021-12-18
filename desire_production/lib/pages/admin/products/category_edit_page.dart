import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/model/category_list_model.dart';
import 'package:desire_production/pages/admin/products/category_list_page.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/drawer_admin.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:flutter/material.dart';

class CategoryEditPage extends StatefulWidget {

  final Category category;

  const CategoryEditPage({this.category});

  @override
  _CategoryEditPageState createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> with Validator{

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController name;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.category.categoryName);
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => CategoryListPage()));
      },
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              // leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => SalesHomePage()));
              // },),
              title: Text("Category Details", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
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
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      physics: AlwaysScrollableScrollPhysics(),
      child: category(),
    );
  }

  Widget category(){
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
                controller: name,
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
            // Padding(
            //   padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10),
            //   child: TextFormField(
            //     validator: validateRequired,
            //     controller: desc,
            //     decoration: InputDecoration(
            //       labelText: 'Description',
            //       hoverColor: Color(0xFFFF7643),
            //       labelStyle: TextStyle(color: Colors.grey),
            //       border: UnderlineInputBorder(
            //         borderSide: BorderSide(color: Colors.grey),
            //       ),
            //       enabledBorder: UnderlineInputBorder(
            //         borderSide: BorderSide(color: Colors.grey),
            //       ),
            //     ),
            //   ),),
            // Padding(
            //   padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 30, bottom: 30),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Text("Category Image", style: TextStyle(color: Colors.grey, fontSize: 18),),
            //       GestureDetector(
            //           child: ClipRRect(
            //               borderRadius: BorderRadius.circular(10),
            //               child: Icon(Icons.collections, color: Colors.black, size: 30,)),
            //           onTap: () {
            //             //futureShowChoiceDialog();
            //           }
            //       ),
            //       widget.category.catImage.isEmpty ? _imageFile1 == null ? Container() : Image.file(_imageFile1, height: 100, width: 100, fit: BoxFit.cover) : SizedBox(
            //         width: 80,
            //         child: AspectRatio(
            //           aspectRatio: 0.88,
            //           child: Hero(
            //             tag: widget.category.catImage,
            //             child: Image.network("http://loccon.in/desiremoulding/upload/Image/Category/${widget.category.catImage}",),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Center(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 10),
                  child: DefaultButton(
                    text: "Edit Category",
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
