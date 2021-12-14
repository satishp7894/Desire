import 'dart:io';
import 'dart:ui';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/pages/cart/order_history_page.dart';
import 'package:desire_users/pages/home/home_page.dart';
import 'package:desire_users/pages/profile/user_detail_page.dart';
import 'package:desire_users/services/check_block.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/coustom_bottom_nav_bar.dart';
import 'package:desire_users/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'contact_us_page.dart';


class ProfilePage extends StatefulWidget {

  final bool status;
  final int orderCount;

  const ProfilePage({@required this.status, @required this.orderCount});

  @override
  _ProfilePageState createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {

  File imageFile;
  String path;
  final _imagePicker = ImagePicker();
  String id;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    if(widget.status) {
      getDetailsB();
    }
    getProfile();
  }

  checkConnectivity() async {
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }

  getProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print("object of image file ${preferences.getString("profilepath")}");
    if(preferences.getString("profilepath") != null){
      path = preferences.getString("profilepath");
    }
    id = preferences.getString("customer_id");
  }

  getDetailsB() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String mob = prefs.getString("Mobile_no");
    print("object $mob");
    final checkBloc = CheckBlocked(mob);
    checkBloc.getDetailsProfile(context);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        centerTitle: false,
        elevation: 0,
        titleTextStyle: headingStyle,
        textTheme: Theme.of(context).textTheme,
      ),
      body: _body(),
     //   bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.profile, numOfItem: widget.orderCount,),
    );
  }

  Widget _body(){
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          _profilePic(),
          SizedBox(height: 20),
          _profileMenu(
            "My Account",
            "assets/icons/User Icon.svg",
              (){
              Navigator.push(context, MaterialPageRoute(builder: (builder) => UserDetailPage(status: true, orderCount:  widget.orderCount,)));
              }
          ),
          _profileMenu(
            "Order History",
            "assets/icons/Parcel.svg",
                  (){
              print("object id $id");
                Navigator.push(context, MaterialPageRoute(builder: (builder) => OrderHistoryPage(customerId: id,status: true,orderCount: widget.orderCount)));
              }
          ),
          _profileMenu(
              "Ledger List",
              "assets/icons/Cash.svg",
                  (){
                print("object id $id");
                final snackBar = SnackBar(content: Text('No Ledger Added'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //Navigator.push(context, MaterialPageRoute(builder: (builder) => AddCreditsPage(id: id,status: true, orderCount: widget.orderCount, )));
              }
          ),
          _profileMenu(
            "Settings",
            "assets/icons/Settings.svg",
                  (){

              }
          ),
          _profileMenu(
            "Help Center",
            "assets/icons/Location point.svg",
                  (){
                Navigator.push(context, MaterialPageRoute(builder: (builder) => ContactUsPage()));
              }
          ),
          _profileMenu(
            "Log Out",
            "assets/icons/Log out.svg",
                  (){
                Alerts.showLogOut(context, "LOGOUT", "Are you sure?");
              }
          ),
        ],
      ),
    );
  }

  Widget _profileMenu(String text, String icon, Function press){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: kPrimaryColor,
              width: 22,
            ),
            SizedBox(width: 20),
            Expanded(child: Text(text,style: TextStyle(color: kBlackColor),)),
            Icon(Icons.arrow_forward_ios,color: kPrimaryColor),
          ],
        ),
      ),
    );
  }

  Widget _profilePic(){
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade200,
            child:imageFile == null ? path == null ?
            IconButton(icon: Icon(Icons.person, color: Colors.black, size: 70,), padding: EdgeInsets.only(right: 50, bottom: 50),
              onPressed: (){
              getImage();
            },) : ClipRRect(child: Image.file(File(path), fit: BoxFit.cover, width: 120,), borderRadius: BorderRadius.circular(80),) : ClipRRect(child: Image.file(imageFile, fit: BoxFit.cover, width: 120,), borderRadius: BorderRadius.circular(80),),
          ),
          Positioned(
            right: -10,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                onPressed: () {
                  getImage();
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
        ],
      ),
    );

  }

  getImage() async{

    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.gallery);

    imageFile = File(_pickedPic.path);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // copy the file to a new path
    final File newImage = await imageFile.copy('$appDocPath/profile.png');

    setState(() {
      imageFile = newImage;
    });

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("profile path", imageFile.path);

  }

}
