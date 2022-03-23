import 'package:desire_production/pages/dashboards/production_dashboard_page.dart';
import 'package:desire_production/pages/production/pendingOrdersPage.dart';
import 'package:desire_production/pages/production/dailyProductionListPage.dart';
import 'package:desire_production/pages/production/production_planning_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'alerts.dart';
import 'constants.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();

}

class _MyDrawerState extends State<MyDrawer> {


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
              accountEmail: Text("production@gmail.com",style: TextStyle(color: Colors.black),),
              accountName: Text("Desire Moulding",style: TextStyle(color: Colors.black),),
              currentAccountPicture: Image.asset("assets/images/logo_new.png",height: 50,width: 50,),
              decoration: BoxDecoration(color: kPrimaryLightColor
                ,),
            ),
            ListTile(
              leading: Icon(Icons.dashboard_outlined, color: kPrimaryColor, size: 22,),
              title: Text("Dashboard", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => DashboardPageProduction()));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/Bill Icon.svg", color: kPrimaryColor, width: 22,),
              title: Text("Production Order", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => DailyProductionListPage(page: 'production',)));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/Bill Icon.svg", color: kPrimaryColor, width: 22,),
              title: Text("Daily Production", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => PendingOrdersPage(page: 'production',)));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/Bill Icon.svg", color: kPrimaryColor, width: 22,),
              title: Text("Production Planning", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => ProductionPlanningPage(page: 'production',)));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/Bell.svg", color: kPrimaryColor, width: 22,),
              title: Text("Product Notification", style: TextStyle(color: Colors.black,)),
              onTap: (){
                showDialog(context: context, builder: (builder) => SendNotificationDialog(context: context));
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
