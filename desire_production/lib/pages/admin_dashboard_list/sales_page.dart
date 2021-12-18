import 'package:desire_production/pages/admin/sales/salesman_list_page.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key key}) : super(key: key);

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Sales",style: TextStyle(
            color: Colors.black
        ),),
        centerTitle: true,
        backgroundColor: Colors.white,

      ),
      body:  salesView(),
    );
  }

 Widget salesView() {
   return Padding(
     padding: const EdgeInsets.only(left: 10.0,right: 10,top: 20,bottom: 20),
     child: ListView(
       children: [

         GestureDetector(
           onTap: (){
             Navigator.push(context, MaterialPageRoute(builder: (context){
               return SalesManListPage();
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
                   Image.asset("assets/images/salesman.png",height: 40,width:40,color: kPrimaryColor,),
                   SizedBox(width: 10),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text("All Salesman",style: TextStyle(
                           color: Colors.black,
                           fontSize: 18,
                           fontWeight: FontWeight.bold
                       ),),
                       SizedBox(height: 5),
                       Text("Get all salesman list",style: TextStyle(
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
       ],
     ),
   );

 }
}
