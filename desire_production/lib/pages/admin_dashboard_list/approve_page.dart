import 'package:desire_production/pages/admin/approvalPending/credit_pending_page.dart';
import 'package:desire_production/pages/admin/approvalPending/kyc_approve_pending.dart';
import 'package:desire_production/pages/admin/customer/add_customer_page.dart';
import 'package:desire_production/pages/admin/customer/customer_list_page.dart';
import 'package:desire_production/pages/admin/sales/customer_credit_page.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class ApprovePage extends StatefulWidget {
  const ApprovePage({Key key}) : super(key: key);

  @override
  _ApprovePageState createState() => _ApprovePageState();
}

class _ApprovePageState extends State<ApprovePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Pending Approval",style: TextStyle(
            color: Colors.black
        ),),
        centerTitle: true,
        backgroundColor: Colors.white,

      ),
      body: customerView(),
    );
  }

  Widget customerView(){
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10,top: 20,bottom: 20),
      child: ListView(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return KycApprovepending();
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
                    Image.asset("assets/images/add_user.png",height: 40,width:40,color: kPrimaryColor,),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("KYC Pending",style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 5),
                        Text("KYC verify pending",style: TextStyle(
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
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return CreditPendingPage();
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
                    Image.asset("assets/images/add_user.png",height: 40,width:40,color: kPrimaryColor,),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Credit Pending",style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 5),
                        Text("Customer credit pending",style: TextStyle(
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

        ],
      ),
    );
  }
}
