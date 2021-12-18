import 'package:desire_users/sales/pages/brochure/brochure_page.dart';
import 'package:desire_users/sales/pages/customer/add_customer_page.dart';
import 'package:desire_users/sales/pages/customer/customer_list_page.dart';
import 'package:desire_users/sales/pages/customerCredit/customer_credit_page.dart';
import 'package:desire_users/sales/pages/products/product_home_page.dart';
import 'package:desire_users/sales/pages/profile/sales_profile_page.dart';
import 'package:desire_users/sales/pages/sales_home_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyDrawer extends StatefulWidget {
  final String name;
  final String email;
  final String salesId;
  MyDrawer({Key key, @required this.name, @required this.email,@required this.salesId}) : super(key: key);
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
              accountEmail: Text("${widget.email}",style: TextStyle(color: Colors.black),),
              accountName: Text("${widget.name}",style: TextStyle(color: Colors.black),),
              currentAccountPicture: Image.asset("assets/images/logo.png",height: 50,width: 50,),
              decoration: BoxDecoration(color: kPrimaryLightColor
                ,),
              onDetailsPressed:() {
                //_key.currentState.closeDrawer();
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (c) => SalesProfilePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard_outlined, color: kPrimaryColor, size: 22,),
              title: Text("Dashboard", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => SalesHomePage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/Shop Icon.svg", color: kPrimaryColor, width: 22,),
              title: Text("Products Home Page", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => ProductHomePage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/add-user.svg", color: kPrimaryColor, width: 22,),
              title: Text("Add New Customer", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => AddCustomerPage(salesId: widget.salesId, name: widget.name,email: widget.email)));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/User.svg", color: kPrimaryColor, width: 22,),
              title: Text("Customer List", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerListPage(salesId: widget.salesId,name: widget.name,email: widget.email,)));
              },
            ),
            const Divider(),
            // ListTile(
            //   leading: SvgPicture.asset("assets/icons/receipt.svg", color: kPrimaryColor, width: 22,),
            //   title: Text("Customer Orders List", style: TextStyle(color: Colors.black,)),
            //   onTap: (){
            //     Navigator.pop(context);
            //     Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerListPageOrder(salesId: widget.salesId,customerList: widget.customerList, name: widget.name,email: widget.email,)));
            //   },
            // ),
            // const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/Cash.svg", color: kPrimaryColor, width: 22,),
              title: Text("Customer Credit List", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => CustomerCreditPage(salesId: widget.salesId,name: widget.name,email: widget.email,)));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/Mail.svg", color: kPrimaryColor, width: 22,),
              title: Text("Create Brochure", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (builder) => BrochurePage(name: widget.name,email: widget.email, salesId: widget.salesId,)));
              },
            ),
            const Divider(),
            ListTile(
              leading: SvgPicture.asset("assets/icons/Log out.svg", color: kPrimaryColor, width: 22,),
              title: Text("Log Out", style: TextStyle(color: Colors.black,)),
              onTap: (){
                Alerts.showSalesLogOut(context, "LOGOUT", "Are you sure?");
                },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
