import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';


class CustomerNotifications extends StatefulWidget {
  const CustomerNotifications({Key key}) : super(key: key);

  @override
  _CustomerNotificationsState createState() => _CustomerNotificationsState();
}

class _CustomerNotificationsState extends State<CustomerNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: kBlackColor
        ),
        titleTextStyle: TextStyle(color: kBlackColor,fontSize: 18.0),
        title: Text("Notifications"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }
  
  Widget _body(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10),
        child: Column(
          children: [
           notificationTile("ORDER ID - 01", "Order Placed Successfully", "20/10/2021"),
           notificationTile("ORDER ID - 01", "Order Placed Successfully", "20/10/2021"),
           notificationTile("ORDER ID - 01", "Order Placed Successfully", "20/10/2021"),
           notificationTile("ORDER ID - 01", "Order Placed Successfully", "20/10/2021"),
           notificationTile("ORDER ID - 01", "Order Placed Successfully", "20/10/2021"),
           notificationTile("ORDER ID - 01", "Order Placed Successfully", "20/10/2021"),
           notificationTile("ORDER ID - 01", "Order Placed Successfully", "20/10/2021"),



          ],
        ),
      ),
    );
  }


  Widget notificationTile(String title, String subtitle, String date){
    return Padding(
      padding: const EdgeInsets.only(top: 5.0,bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kBlackColor,width: 0.5),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                 flex: 1,
                  child: Icon(Icons.notifications,color: kPrimaryColor,)),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold,fontSize: 16),),
                    Text(subtitle,style: TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,fontSize: 12),),

                  ],
                ),
              ),
              Expanded(
                 flex: 2,
                  child: Text(date,style: TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold,fontSize: 14),))

            ],
          ),
        ),
      ),
    );
  }
}


