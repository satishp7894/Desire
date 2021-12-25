import 'package:desire_production/bloc/production_user_profile_bloc.dart';
import 'package:desire_production/model/productionUserProfile_model.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class ProductionUserProfile extends StatefulWidget {
  final String page;

  const ProductionUserProfile({@required this.page}) : super();

  @override
  _ProductionUserProfileState createState() => _ProductionUserProfileState();
}

class _ProductionUserProfileState extends State<ProductionUserProfile> {
  final userProfile = ProductioinUserProfileBLOC();
  AsyncSnapshot<ProductionUserProfileModelListModel> profile;
  List<ProductionUserProfileModel> userDetail;

  @override
  void initState() {
    super.initState();
    userProfile.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "User Profile",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        body: _body());
  }

  Widget _body() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: StreamBuilder<ProductionUserProfileModelListModel>(
        stream: userProfile.userStream,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(
                height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50,
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ));
          }
          if (s.hasError) {
            print("as3 error");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "Error Loading Data",
              ),
            );
          }
          if (s.data.data == null) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Orders Found",
              ),
            );
          }

          profile = s;
          userDetail = s.data.data;

          return GestureDetector(
              onTap: () => { },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      borderOnForeground: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, bottom: 10, top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(
                                "Name : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                              Text(
                                  '${userDetail[0].firstname} ${userDetail[0].lastname} ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black))
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Text(
                                "Email : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                              Text(userDetail[0].email,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black))
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Text(
                                "Gender : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                              Text(userDetail[0].gender,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black))
                            ]),
                            SizedBox(
                              height: 10,
                            ),
                            Row(children: [
                              Text(
                                "Mobile : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                              Text(
                                  userDetail[0].userMobile == null
                                      ? "N/A"
                                      : userDetail[0].userMobile,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.black))
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
