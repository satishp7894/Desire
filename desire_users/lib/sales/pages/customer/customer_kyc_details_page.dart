import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/kyc_bloc.dart';
import 'package:desire_users/models/kyc_view_model.dart';
import 'package:desire_users/sales/pages/customer/customer_list_page.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/sales/utils_sales/default_button.dart';
import 'package:desire_users/sales/utils_sales/progress_dialog.dart';
import 'package:desire_users/services/connection_sales.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerKYCDetailsPage extends StatefulWidget {

  final String customerId;
  final String salesId;
  final String name;
  final String email;

  const CustomerKYCDetailsPage({@required this.customerId, @required this.salesId, @required this.email, @required this.name});

  @override
  _CustomerKYCDetailsPageState createState() => _CustomerKYCDetailsPageState();
}

class _CustomerKYCDetailsPageState extends State<CustomerKYCDetailsPage> {

  final kycBloc = KYCBloc();
  String imagePath = "http://loccon.in/desiremoulding/upload/Image/Kyc/";

  List<String> kyc = [];

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    //getKyc();
    kycBloc.fetchKycView(widget.customerId);
  }

  checkConnectivity() async{
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }

  // getKyc() async{
  //   SharedPreferences prefs = await  SharedPreferences.getInstance();
  //   if(prefs.getStringList("kycDone") != null){
  //     kyc = prefs.getStringList("kycDone");
  //     print("object ${kyc.length}");
  //   } else {
  //     kyc =[];
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    kycBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
              Navigator.of(context).pop();
            },),
            title: Text("Customer KYC Details",
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,),
            centerTitle: true,
          ),
          body: _body(),
        ));
  }

  Widget _body(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50,),
        SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: StreamBuilder<KycViewModel>(
            stream: kycBloc.kycViewStream,
            builder: (c,s){

              if (s.connectionState != ConnectionState.active) {
                print("all connection");
                return Container(height: 300,
                    alignment: Alignment.center,
                    child: Center(
                      heightFactor: 50, child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),));
              }
           else    if (s.hasError) {
                print("as3 error");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("Error Loading Data",),);
              }
             else  if (s.data
                  .toString()
                  .isEmpty) {
                print("as3 empty");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("No Data Found",),);
              }
             else {
                return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10),
                    itemCount: s.data.data.length,
                    itemBuilder: (c,i){

                      if(s.data.data[i].approveRejectStatus == "1"){
                        kyc.add("true");
                      }
                      else if(s.data.data[i].approveRejectStatus == "2"){
                        kyc.add("false");
                      }
                      else if(s.data.data.length == 0 ){
                        return Center(
                          child: Text("No Details"),
                        );
                      }
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          s.data.data[i].kycId == "1" ? Align(alignment: Alignment.centerLeft,child: Text("PAN Card Details", textAlign: TextAlign.left, style: appbarStyle,)) : s.data.data[i].kycId == "2" ?
                          Align(alignment: Alignment.centerLeft,child: Text("Aadhaar Card details", textAlign: TextAlign.left, style: appbarStyle,)) : Align(alignment: Alignment.centerLeft,child: Text("GSTIN Details", textAlign: TextAlign.left, style: appbarStyle,)),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(flex: 2, child: TextFormField(
                                readOnly: true,
                                keyboardType: TextInputType.text,
                                initialValue: s.data.data[i].number,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                              ),),
                              Expanded(
                                child: GestureDetector(
                                    onTap: ()async {
                                      await showDialog(
                                          context: context,
                                          builder: (_) => imageDialog("$imagePath${s.data.data[i].photo}")
                                      );
                                    },
                                    child: Image.network("$imagePath${s.data.data[i].photo}",height: 100, width: 50,)),
                              ),
                              s.data.data[i].approveRejectStatus == "1" ? Container(child: Icon(Icons.done,  color: Colors.greenAccent,),) :
                              s.data.data[i].approveRejectStatus == "2" ? Container(child: Icon(Icons.close,  color: Colors.redAccent,),) :
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.done, color: Colors.greenAccent,),
                                      onPressed: (){
                                        approveKyc(s.data.data[i].kycId);
                                      }),
                                  IconButton(
                                      icon: Icon(Icons.close, color: Colors.redAccent,),
                                      onPressed: (){
                                        rejectKyc(s.data.data[i].kycId);
                                      })

                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20,)
                        ],
                      );

                    });
              }

            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: DefaultButton(text: "Done", press: (){

            print("object kyc ${kyc.length}");
            if(kyc.isNotEmpty && (kyc.length==2 || kyc.length==3)){
              for(int i=0; i<kyc.length; i++){
                print("object kyc details ${kyc[i]}");
              }
              print("object checks value ${kyc.where((e)=> e == "false").length}");

              if(kyc.where((e)=> e == "false").length > 0){
                kycDone("2");
              } else{
                kycDone("1");
              }
            } else{
              Alerts.showAlertAndBack(context, "Invalid", "Set all data");
            }
            //kycDone(status);
            },),
        )
      ],
    );
  }

  Widget imageDialog(String path){
    return PhotoView(
      imageProvider: NetworkImage(path),
      backgroundDecoration: BoxDecoration(
        color: Colors.transparent,
      ),
    );
  }

  approveKyc(String kycId) async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator(
        color: kPrimaryColor,
      )),);
    pr.show();
    var response;
    response = await http.post(Uri.parse(ConnectionSales.setKycIdStats), body: {
      'secretkey':ConnectionSales.secretKey,
      'customerid':widget.customerId,
      'kyc_id': kycId,
      'status':"Approve",
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true){
      print("object kyc approve true");

      setState(() {
        kyc.add("true");

        print("object kyc approve add");

      });

      SharedPreferences prefs = await  SharedPreferences.getInstance();
      prefs.setStringList("kycDone", kyc);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (build) => CustomerKYCDetailsPage(customerId: widget.customerId, salesId: widget.salesId, name: widget.name,email: widget.email,)), (route) => false);//Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>HomePage()), (route) => false);
    } else{
      Alerts.showAlertAndBack(context, "Kyc Approved", "Something went wrong");
    }
  }

  rejectKyc(String kycId) async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    var response;
    response = await http.post(Uri.parse(ConnectionSales.setKycIdStats), body: {
      'secretkey':ConnectionSales.secretKey,
      'customerid':widget.customerId,
      'kyc_id': kycId,
      'status':"Reject",
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true){
      print("object kyc approve true");
      setState(() {
        kyc.add("false");
        print("object kyc reject add");
      });
      SharedPreferences prefs = await  SharedPreferences.getInstance();
      prefs.setStringList("kycDone", kyc);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (build) => CustomerKYCDetailsPage(customerId: widget.customerId, salesId: widget.salesId,name: widget.name,email: widget.email,)), (route) => false);//Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>HomePage()), (route) => false);
    } else{
      Alerts.showAlertAndBack(context, "Kyc Reject", "Something went wrong");
    }
  }

  kycDone(String stats) async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator(
        color: kPrimaryColor,
      )),);
    pr.show();
    var response;
    response = await http.post(Uri.parse(ConnectionSales.setCustKycStats), body: {
      'secretkey':ConnectionSales.secretKey,
      'customerid':widget.customerId,
      'status':stats,
    });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true){
      print("object kyc approve true");
      SharedPreferences prefs = await  SharedPreferences.getInstance();
      prefs.remove("kycDone");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder)=>CustomerListPage(salesId: widget.salesId, name: widget.name,email: widget.email,customerId: widget.customerId,)), (route) => false);
    } else{
      Alerts.showAlertAndBack(context, "Kyc Approved", "Something went wrong");
    }
  }

}
