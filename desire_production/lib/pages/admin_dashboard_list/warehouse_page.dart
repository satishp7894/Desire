import 'package:desire_production/pages/warehouse/readyToDispatchListPage.dart';
import 'package:desire_production/pages/warehouse/warehouse_list_page.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class WarehousePage extends StatefulWidget {
  const WarehousePage({Key key}) : super(key: key);

  @override
  _WarehousePageState createState() => _WarehousePageState();
}

class _WarehousePageState extends State<WarehousePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Warehouse",style: TextStyle(
            color: Colors.black
        ),),
        centerTitle: true,
        backgroundColor: Colors.white,

      ),
      body: warehouseView(),
    );
  }

  Widget warehouseView(){
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10,top: 20,bottom: 20),
      child: ListView(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return WarehouseListPage(page: "admin");
              }));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kPrimaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 2,
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/warehouse.png",height: 60,width:60,color: Colors.white,),
                    SizedBox(width: 10),
                    Text("WAREHOUSE LIST",style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return ReadyToDispatchListPage(page: "admin");
              }));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: kSecondaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 2,
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/dispatch.png",height: 60,width:60,color: Colors.white,),
                    SizedBox(width: 10),
                    Text("READY TO DISPATCH",style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
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
