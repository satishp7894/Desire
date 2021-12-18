import 'package:desire_production/pages/admin/admin_user_list_page.dart';
import 'package:desire_production/pages/admin/customer/add_customer_page.dart';
import 'package:desire_production/pages/admin/customer/customer_list_page.dart';
import 'package:desire_production/pages/admin/products/category_list_page.dart';
import 'package:desire_production/pages/admin/products/model_list_page.dart';
import 'package:desire_production/pages/admin/products/product_list_page.dart';
import 'package:desire_production/pages/admin/sales/brochure_page.dart';
import 'package:desire_production/pages/admin/sales/customer_credit_page.dart';
import 'package:desire_production/pages/admin/sales/salesman_list_page.dart';
import 'package:desire_production/pages/dashboards/production_dashboard_page.dart';
import 'package:desire_production/pages/dashboards/dashboard_page_admin.dart';
import 'package:desire_production/pages/production/dailyOrdersPage.dart';
import 'package:desire_production/pages/production/dailyProductionListPage.dart';
import 'package:desire_production/pages/production/production_planning_page.dart';
import 'package:desire_production/pages/warehouse/warehouse_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'alerts.dart';
import 'constants.dart';

class DrawerAdmin extends StatefulWidget {

  @override
  _DrawerAdminState createState() => _DrawerAdminState();
}

class _DrawerAdminState extends State<DrawerAdmin> {
  @override
  Widget build(BuildContext context) {
    return custDrawer();
  }

  Widget custDrawer(){
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        color: Colors.white,
        width: 250,
        //height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text("admin@proactii.com",style: TextStyle(color: Colors.black),),
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
                Navigator.push(context, MaterialPageRoute(builder: (builder) => DashboardPageAdmin()));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/custList.svg", color: kPrimaryColor, width: 22,),
              title: Text("Admin User List", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => AdminUserListPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/sweetbox.svg", color: kPrimaryColor, width: 22,),
              title: Text("Model List Page", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => ModelListPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/regular.svg", color: kPrimaryColor, width: 22,),
              title: Text("Category List Page", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => CategoryListPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/Parcel.svg", color: kPrimaryColor, width: 22,),
              title: Text("Product List Page", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => ProductListPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/User.svg", color: kPrimaryColor, width: 22,),
              title: Text("Salesman List", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => SalesManListPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/add-user.svg", color: kPrimaryColor, width: 22,),
              title: Text("New Customer", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => AddCustomerPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/User.svg", color: kPrimaryColor, width: 22,),
              title: Text("Customer List", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerListPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/Cash.svg", color: kPrimaryColor, width: 22,),
              title: Text("Customer Credit", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerCreditPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/Mail.svg", color: kPrimaryColor, width: 22,),
              title: Text("Brochure", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => BrochurePage(page: 'admin',)));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/receipt.svg", color: kPrimaryColor, width: 22,),
              title: Text("Production Order", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => DailyProductionListPage(page: 'admin',)));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/receipt.svg", color: kPrimaryColor, width: 22,),
              title: Text("Daily Production", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => DailyOrdersPage(page: 'admin',)));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/receipt.svg", color: kPrimaryColor, width: 22,),
              title: Text("Production Planning", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => ProductionPlanningPage(page: 'admin',)));
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
              leading: SvgPicture.asset("assets/icons/Bill Icon.svg", color: kPrimaryColor, width: 22,),
              title: Text("Warehouse List", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => WarehouseListPage(page: 'admin',)));
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
