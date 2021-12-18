import 'package:desire_production/pages/dashboards/dashboard_page_warhouse.dart';
import 'package:desire_production/pages/warehouse/warehouse_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'alerts.dart';
import 'constants.dart';

class MyDrawerWarehouse extends StatefulWidget {


  @override
  _MyDrawerWarehouseState createState() => _MyDrawerWarehouseState();

}

class _MyDrawerWarehouseState extends State<MyDrawerWarehouse> {


  @override
  Widget build(BuildContext context) {
    return custDrawer();
  }

  Widget custDrawer(){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        color: Colors.white,
        width: 250,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text("warhouse@gmail.com",style: TextStyle(color: Colors.black),),
              accountName: Text("Desire Moulding",style: TextStyle(color: Colors.black),),
              currentAccountPicture: Image.asset("assets/images/logo.png",height: 50,width: 50,),
              decoration: BoxDecoration(color: kPrimaryLightColor
                ,),
            ),
            ListTile(
              leading: Icon(Icons.dashboard_outlined, color: kPrimaryColor, size: 22,),
              title: Text("Dashboard", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => DashboardPageWarehouse()));
              },

            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/Bill Icon.svg", color: kPrimaryColor, width: 22,),
              title: Text("Warehouse List", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => WarehouseListPage(page: 'warHouse',)));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/Log out.svg", color: kPrimaryColor, width: 22,),
              title: Text("Log Out", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Alerts.showLogOut(context, "Log Out", "Are you sure?");
              },
            ),
          ],
        ),
      ),
    );
  }
}
