import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/model/user_model.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class SalesmanDetailsPage extends StatefulWidget {

  final User salesman;

  const SalesmanDetailsPage({@required this.salesman});

  @override
  _SalesmanDetailsPageState createState() => _SalesmanDetailsPageState();
}

class _SalesmanDetailsPageState extends State<SalesmanDetailsPage> {

  TextEditingController fname;
  TextEditingController lname;
  TextEditingController email;
  TextEditingController phone;
  TextEditingController uName;
  TextEditingController address;
  TextEditingController city;
  TextEditingController state;
  TextEditingController pincode;

  @override
  void initState() {
    checkConnectivity();
    fname = TextEditingController(text: widget.salesman.firstname);
    lname = TextEditingController(text: widget.salesman.lastname);
    email = TextEditingController(text: widget.salesman.email);
    phone = TextEditingController(text: widget.salesman.userMobile);
    uName = TextEditingController(text: widget.salesman.username);
    address = TextEditingController(text: widget.salesman.address);
    city = TextEditingController(text: widget.salesman.city);
    state = TextEditingController(text: widget.salesman.state);
    pincode = TextEditingController(text: widget.salesman.pincode);
    super.initState();
  }

  checkConnectivity() async{
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }

  @override
  void dispose() {
    fname.dispose();
    lname.dispose();
    email.dispose();
    phone.dispose();
    uName.dispose();
    address.dispose();
    city.dispose();
    state.dispose();
    pincode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
          appBar: AppBar(
            title: Text("User Details"),
            centerTitle: true,
            elevation: 0,
            backgroundColor:kSecondaryColor.withOpacity(0),
            titleTextStyle: headingStyle,
            textTheme: Theme.of(context).textTheme,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: (){
              Navigator.of(context).pop();
            },),
          ),
          body: _body(),
        )
    );
  }

  Widget _body(){
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.salesman.userPhoto == "" ? Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
            child: Icon(Icons.person_outline, color: Colors.black, size: 150,),
          ) : Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
              child: Image.network("http://loccon.in/desiremoulding/upload/Image/Admin/${widget.salesman.userPhoto}",height: 150, width: 150,)
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 25.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                    child: new Text(
                      'Personal Information',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Name',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                          child: TextFormField(
                            readOnly: true,
                            controller: fname,
                            decoration: const InputDecoration(
                              hintText: "Enter Your Name",
                            ),
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'User Name',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                          child: TextFormField(
                            readOnly: true,
                            controller: uName,
                            decoration: const InputDecoration(
                              hintText: "Enter Your User Name",
                            ),
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Email ID',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                          child: new TextFormField(
                            readOnly: true,
                            keyboardType: TextInputType.emailAddress,
                            controller: email,
                            decoration: const InputDecoration(
                                hintText: "Enter Email ID"),
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Mobile',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                          child: TextFormField(
                            readOnly: true,
                            controller: phone,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                                hintText: "Enter Mobile Number"),
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Flat No/House No',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                          child: new TextFormField(
                            readOnly: true,
                            controller: address,
                            keyboardType: TextInputType.streetAddress,
                            decoration: const InputDecoration(
                                hintText: "Enter Flat No/ House No."),
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'City',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                          child: new TextFormField(
                            readOnly: true,
                            controller: city,
                            keyboardType: TextInputType.streetAddress,
                            decoration: const InputDecoration(
                                hintText: "Enter City"),
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Pincode',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(

                          child: TextFormField(
                            readOnly: true,
                            controller: pincode,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: "Enter Pincode"),
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'State',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                          child: new TextFormField(
                            readOnly: true,
                            controller: state,
                            keyboardType: TextInputType.streetAddress,
                            decoration: const InputDecoration(
                                hintText: "Enter State"),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
