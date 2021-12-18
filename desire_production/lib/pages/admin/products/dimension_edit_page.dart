import 'package:desire_production/components/default_button.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/drawer_admin.dart';
import 'package:desire_production/utils/validator.dart';
import 'package:flutter/material.dart';

import 'dimension_list_page.dart';

class DimensionEditPage extends StatefulWidget {

  @override
  _DimensionEditPageState createState() => _DimensionEditPageState();
}

class _DimensionEditPageState extends State<DimensionEditPage> with Validator{

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  //File _imageFile1;

  TextEditingController name;
  TextEditingController size;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: "Dimension Name");
    size = TextEditingController(text: "123x123");
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
    size.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => DimensionListPage()));
      },
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              // leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => SalesHomePage()));
              // },),
              title: Text("Dimension Details", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
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
                  labelText: 'Dimension Name',
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
                controller: size,
                decoration: InputDecoration(
                  labelText: 'Dimension Size',
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
                  Text("Dimension Image", style: TextStyle(color: Colors.grey, fontSize: 18),),
                  GestureDetector(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Icon(Icons.collections, color: Colors.black, size: 30,)),
                      onTap: () {
                        //futureShowChoiceDialog();
                      }
                  ),
                  // widget.category.catImage.isEmpty ? _imageFile1 == null ? Container() :
                  // Image.file(_imageFile1, height: 100, width: 100, fit: BoxFit.cover) :
                  SizedBox(
                    width: 80,
                    child: AspectRatio(
                      aspectRatio: 0.88,
                      child: Hero(
                        tag: "widget.category.catImage",
                        child: Image.network("http://loccon.in/desiremoulding/upload/Image/Dimensions/Untitled-FigrCollage-Exported-Image25.png",),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 25.0, right: 25.0, top: 10),
                  child: DefaultButton(
                    text: "Edit Dimension",
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
