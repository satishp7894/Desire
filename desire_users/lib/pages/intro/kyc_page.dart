import 'dart:io';

import 'package:desire_users/bloc/kyc_bloc.dart';
import 'package:desire_users/components/default_button.dart';
import 'package:desire_users/models/kyc_model.dart';
import 'package:desire_users/pages/intro/success_page.dart';
import 'package:desire_users/services/api_client.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:desire_users/utils/progress_dialog.dart';
import 'package:desire_users/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class KYCPage extends StatefulWidget {

  final String userId;

  KYCPage({@required this.userId});

  @override
  _KYCPageState createState() => _KYCPageState();
}

class _KYCPageState extends State<KYCPage> with Validator {
  final kycBloc = KYCBloc();
  List<TextEditingController> name;
  AsyncSnapshot<KycModel> as;

  final _imagePicker = ImagePicker();
  File _imageFile;
  List<File> selectedImage;

  List<bool> checks;

  @override
  void initState() {
    super.initState();
    print("object user id ${widget.userId}");
    kycBloc.fetchKyc();
    name = [];
    selectedImage = [];
    checks = [];
  }

  @override
  void dispose() {
    super.dispose();
    kycBloc.dispose();
    for(int i=0; i<name.length; i++)
      name[i].dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text("KYC Form",style: headingStyle,),
            centerTitle: true,
            backgroundColor: Colors.black12,
            elevation: 0,
            titleTextStyle: headingStyle,
            textTheme: Theme.of(context).textTheme,
          ),
          body: Container(
            color: Colors.black12,
              height: double.infinity,
              child: _body()),
        ));
  }

  Widget _body() {
    return SingleChildScrollView(
      child: StreamBuilder<KycModel>(
        stream: kycBloc.kycStream,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50, child: CircularProgressIndicator(),));
          }
          if (s.hasError) {
            print("as3 error");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("Error Loading Data",),);
          }
          if (s.data.toString().isEmpty) {
            print("as3 empty");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("No Data Found",),);
          }
          as = s;
          print("object value from s ${as.data.data.length}");
          print("object of selected ${selectedImage.length}");
          for(int i=0; i< as.data.data.length; i++)
            name.add(new TextEditingController());
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Please submit your KYC details",
                    textAlign: TextAlign.center,
                  ),
                ),
                for(int i = 0; i < as.data.data.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: SizedBox(
                      height: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              autofocus: true,
                              controller: name[i],
                              validator: validateRequired,
                              inputFormatters: [
                                //FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(int.parse(s.data.data[i].length)),
                              ],
                              maxLength: int.parse(s.data.data[i].length),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter ${s.data.data[i].kycName}",
                                hintStyle: TextStyle(color: Colors.black45),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(30)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(30)),
                                focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                          ),
                          SizedBox(width: 20,),
                          for(int x=0; x<selectedImage.length; x++)
                            x == i ? Expanded(child: selectedImage.isEmpty ? Container(height: 100,width: 50, child: Text("Add ${as.data.data[i].kycName}"),) : Image.file(selectedImage[x], height: 140, width: 140, fit: BoxFit.cover)) : Container(),
                          SizedBox(width: 10,),
                          GestureDetector(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Icon(Icons.collections, color: Colors.black, size: 50,)),
                            onTap: () {
                              print("object i value $i ${name[i].text}");
                              print("object kyc id ${int.parse(as.data.data[i].length)} == ${name[i].text.length}");
                              if(name[i].text.isEmpty){
                                Alerts.showAlertAndBack(context, "Textfield", "Please enter ${name[i].text.isEmpty}");
                              } else if(int.parse(as.data.data[i].length) != name[i].text.length){
                                Alerts.showAlertAndBack(context, "Textfield", "Please enter valid ${name[i].text.isEmpty}");
                              } else {
                                _uploadProfilePicture(i,as.data.data[i].kycId);
                              }
                            },
                          ),
                          for(int x=0; x<checks.length;x++)
                            x == i ? Checkbox(value: checks.isEmpty ? false : checks[x] ? true : false, onChanged: (v){
                              setState(() {
                                checks[x] =!v;
                                Alerts.showAlertAndBack(context, "", "You cannot change this value");
                              });
                            }) : Container(),
                        ],
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: DefaultButton(text: "Submit",press: (){
                    print("object checks value ${checks.where((e)=> e == false).length}");
                    if(checks.where((e)=> e == false).length > 0 || checks.isEmpty || checks.length < 3){
                      Alerts.showAlertAndBack(context, "KYC Error", "Please upload all data");
                    } else{
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SuccessPage(userId: widget.userId)));
                    }
                  },),
                )
              ]
          );
        },
      ),
    );
  }



  _uploadProfilePicture(int i, String kycId) async {
    print("values from text ${widget.userId}, ${name[i].text} $kycId");
    final _pickedPic = await ImagePicker.pickImage(source: ImageSource.gallery);

      _imageFile = File(_pickedPic.path);


    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Data');
    pr.show();
    final _apiClient = ApiClient();
    String value = await _apiClient.updateProfilePhoto(_imageFile,"${widget.userId}","$kycId","${name[i].text}");
    print("value $value");

    setState(() {
      value == "success" ? checks.insert(i, true) : Alerts.showAlertAndBack(context, "Error", "Error loading image");
      print("object is ther $i ${selectedImage.isEmpty}");
      selectedImage.insert(i,_imageFile);
      print("object value after image load ${checks[i]} ${selectedImage[i]}");
    });
    pr.hide();
  }

}
