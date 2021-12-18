import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/kyc_bloc.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/models/kyc_view_model.dart';
import 'package:desire_users/pages/intro/success_page.dart';
import 'package:desire_users/services/api_client.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class KycViewPage extends StatefulWidget {

  final String userId;


  KycViewPage({@required this.userId});

  @override
  _KycViewPageState createState() => _KycViewPageState();
}

class _KycViewPageState extends State<KycViewPage> {

  final kycBloc = KYCBloc();
  String imagePath = "http://loccon.in/desiremoulding/upload/Image/Kyc/";

  final _imagePicker = ImagePicker();
  File _imageFile;
  //List<File> selectedImage;

  List<bool> checks;

  static String panKycId = "1";
  static String aadharKycId = "2";
  static String gstKycId = "3";


  @override
  void initState() {
    super.initState();
    checkConnectivity();
    kycBloc.fetchKycView(widget.userId);
    //selectedImage = [];
    checks = [];
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          bottomNavigationBar: SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: DefaultButton(text: "Done", press: (){
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (builder) =>
                        SuccessPage(userId: widget.userId)), (route) => false);
              },),
            ),
          ),
          body: RefreshIndicator(
            color: kPrimaryColor,
            onRefresh: () {
              return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => KycViewPage(userId: widget.userId)), (route) => false);
            },
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                  children: [
                    _body()
                  ]
              ),
            ),
          ),
        ));
  }

  Widget _body(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("User KYC Details",style: headingStyle,),
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
              if (s.hasError) {
                print("as3 error");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("Error Loading Data",),);
              }
              if (s.data
                  .toString()
                  .isEmpty) {
                print("as3 empty");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("No Data Found",),);
              }

              return ListView.builder(
                shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(5),
                  itemCount: s.data.data.length,
                  itemBuilder: (c,i){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        s.data.data[i].kycId == "$panKycId" ?
                        Align(alignment: Alignment.centerLeft,
                            child: Text("PAN Card Details", textAlign: TextAlign.left, style: appbarStyle,)
                        )
                      : s.data.data[i].kycId == "$aadharKycId" ?
                        Align(alignment: Alignment.centerLeft,
                            child: Text("Aadhaar Card details", textAlign: TextAlign.left, style: appbarStyle,)
                        )
                      : Align(alignment: Alignment.centerLeft,
                            child: Text("GST IN Details", textAlign: TextAlign.left, style: appbarStyle,)
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextFormField(
                                readOnly: true,
                                initialValue: s.data.data[i].number,
                              ),
                            ),
                            SizedBox(width: 10,),
                            Expanded(child: Image.network("$imagePath${s.data.data[i].photo}",height: 100, width: 50,)),
                            SizedBox(width: 10,),
                            s.data.data[i].approveRejectStatus == "2" ?
                            Column(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: GestureDetector(onTap:(){
                                      _uploadProfilePicture(i, s.data.data[i].kycId, s.data.data[i].number);
                                    },child: Icon(Icons.collections, color: Colors.black, size: 50,)
                                    )
                                ),
                                Text("Kyc rejected upload data again", style: TextStyle(color: Colors.red),)
                              ],
                            )
                                : Transform.scale(scale: 2,
                                  child: Checkbox(
                                  activeColor: Colors.greenAccent,
                                  tristate: true,
                                  value: true, onChanged: (v){
                              setState(() {
                               print("You cannot change this value");
                              });
                            }),
                                ),
                          ],
                        ),
                        SizedBox(height: 50,)
                      ],
                    );
                  });
            },
          ),
        ),

      ],
    );
  }

  _uploadProfilePicture(int i, String kycId, String kycNo) async {
    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.gallery);

    _imageFile = File(_pickedPic.path);


    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Data');
    pr.show();
    final _apiClient = ApiClient();
    String value = await _apiClient.updateProfilePhoto(_imageFile,"${widget.userId}","$kycId","$kycNo");
    print("value $value");
    setState(() {
      if(value == "success"){
        //selectedImage.insert(i, _imageFile);
        final snackBar = SnackBar(content: Text('Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        Alerts.showAlertAndBack(context, "Error", "Error uploading image");
      }
    });
    pr.hide();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => KycViewPage(userId: widget.userId,)), (route) => false);
  }




}


