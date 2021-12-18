
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/services/check_block.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BlockedPage extends StatefulWidget {

  final String mob;

  const BlockedPage({@required this.mob});



  @override
  _BlockedPageState createState() => _BlockedPageState();
}

class _BlockedPageState extends State<BlockedPage> {

  String id, name, email, mobileNo;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  checkConnectivity() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString("customer_id");
    name = preferences.getString("Customer_name");
    email = preferences.getString("Email");
    mobileNo = preferences.getString("Mobile_no");
    print("object customer id $id");
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body(),
      ),
    );
  }

  Widget _body(){
    return RefreshIndicator(
      onRefresh: () {
        return getDetails();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              Expanded(
                flex: 2,
                child: Image.asset(
                  "assets/images/block.png",
                  height: 500,
                  width: 200,//40%
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      "You have been Blocked",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Please Contact the Sales Executive for further details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(icon: Icon(Icons.refresh, color: Colors.red,size: 50), onPressed: (){
                    getDetails();
                  }),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  getDetails(){
    var checkBlock = CheckBlocked(widget.mob);
    checkBlock.getDetailsBlock(context);
  }

}
