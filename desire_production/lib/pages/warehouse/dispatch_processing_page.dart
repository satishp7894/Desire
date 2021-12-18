import 'dart:convert';
import 'dart:io';

import 'package:desire_production/bloc/dispatch_processing_bloc.dart';
import 'package:desire_production/model/dispatch_processing_model.dart';
import 'package:desire_production/model/warehouse_list_model.dart';
import 'package:desire_production/pages/warehouse/warehouse_list_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/default_button.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class DispatchProcessingPage extends StatefulWidget {

  final Data element;
  final String page;

  const DispatchProcessingPage({@required this.element, @required this.page});

  @override
  _DispatchProcessingPageState createState() => _DispatchProcessingPageState();
}

class _DispatchProcessingPageState extends State<DispatchProcessingPage>{

  final dispatchProcessingBloc = DispatchProcessingBloc();

  // AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int length = 0;

  List<bool> eva = [];
  List<bool> lr = [];

  List<TextEditingController> orderNo = [];
  List<TextEditingController> productName = [];
  List<TextEditingController> qty = [];
  List<TextEditingController> lrNo = [];
  List<TextEditingController> eVaNo = [];

  List<Dispatch> dispatchList = [];


  final _imagePicker = ImagePicker();
  File _imageFile;
  String photo;

  @override
  void initState() {
    super.initState();
    dispatchProcessingBloc.fetchDispatchProcessing(widget.element.warehouseId, widget.element.modelNoId, widget.element.warehouseId);
  }

  @override
  void dispose() {
    super.dispose();
    dispatchProcessingBloc.dispose();
    for(int i=0; i<length; i++){
      orderNo[i].dispose();
      productName[i].dispose();
      qty[i].dispose();
      lrNo[i].dispose();
      eVaNo[i].dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => WarehouseListPage(page: widget.page,)), (route) => false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          leading: Builder(
            builder: (c){
              return IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: (){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => WarehouseListPage(page: widget.page,)), (route) => false);
              },);
            },
          ),
          actions: [
            PopupMenuButton(
                icon: Icon(Icons.settings_outlined, color: Colors.black,),
                itemBuilder: (b) =>[
                  PopupMenuItem(
                      child: TextButton(
                        child: Text("Log Out", textAlign: TextAlign.center,),
                        onPressed: (){
                          Alerts.showLogOut(context, "Log Out", "Are you sure?");
                        },
                      )
                  ),
                ]
            )
          ],
          title: Text(
            "Dispatch Processing Details",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.start,
          ),
        ),
        body: _body(),
      ),
    );
  }

  Widget _body(){
    return RefreshIndicator(
        onRefresh:(){
          return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => DispatchProcessingPage(element: widget.element, page: widget.page,)), (route) => false);
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          physics: AlwaysScrollableScrollPhysics(),
          child: StreamBuilder<DispatchProcessingModel>(
            stream: dispatchProcessingBloc.dispatchProcessStream,
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
              if (s.data.dispatch.length == 0) {
                print("as3 empty");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("No Details Found",),);
              }

              length = s.data.dispatch.length;
              print("object length of dipatch $length ${s.data.dispatch.length}");

              dispatchList = s.data.dispatch;

              for(int i=0; i<dispatchList.length; i++){
                orderNo.add(TextEditingController(text: dispatchList[i].orderId));
                productName.add(TextEditingController(text: dispatchList[i].productName));
                qty.add(TextEditingController(text: dispatchList[i].productQuantity));
                lrNo.add(TextEditingController());
                eVaNo.add(TextEditingController());
                lr.add(false);
                eva.add(false);
              }

              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dispatchList.length,
                  itemBuilder: (c,i){
                    return Container(
                      height: 500,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryLightColor,
                            blurRadius: 5, // has the effect of softening the shadow
                            spreadRadius: 5, // has the effect of extending the shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          20.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: orderNo[i],
                                //validator: validateRequired,
                                textAlign: TextAlign.center,
                                scrollPadding: EdgeInsets.zero,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Order Number",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  //focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                                  //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                                  //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: productName[i],
                                //validator: validateRequired,
                                textAlign: TextAlign.center,
                                scrollPadding: EdgeInsets.zero,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Product",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  //focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                                  //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                                  //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: qty[i],
                                //validator: validateRequired,
                                textAlign: TextAlign.center,
                                scrollPadding: EdgeInsets.zero,
                                showCursor: false,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Quantity",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  //focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                                  //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                                  //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: lrNo[i],
                                //validator: validateRequired,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                showCursor: false,
                                scrollPadding: EdgeInsets.zero,
                                decoration: InputDecoration(
                                  labelText: "Lr No",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  //focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                                  //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                                  //focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          Center(child: Text("OR")),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black, width: 1),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    futureShowChoiceDialogLr(i);
                                  },
                                  child: Text("Upload LR Bill"),),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: TextFormField(
                                controller: eVaNo[i],
                                textInputAction: TextInputAction.next,
                                //validator: validateRequired,
                                textAlign: TextAlign.center,
                                scrollPadding: EdgeInsets.zero,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  labelText: "EVA No",
                                  floatingLabelBehavior: FloatingLabelBehavior.always,
                                  //focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
                                  //enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(10)),
                                  //  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blue), borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                          Center(child: Text("OR")),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black, width: 1),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    futureShowChoiceDialogEVA(i);
                                  },
                                  child: Text("Upload EVA Bill"),),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
                            child: DefaultButton(
                              text: "Submit",
                              press: (){
                                print("object status ${lr[i]}${eva[i]}");
                                if (lr[i] == false && eva[i] == false && lrNo[i].text != "" && eVaNo[i].text != "") {
                                  onSubmit(i, lrNo[i].text, eVaNo[i].text, qty[i].text, dispatchList[i].productId, orderNo[i].text, dispatchList[i].orderdetailId, dispatchList[i].orderDetailsKey, widget.element.warehouseId, null, null);
                                } else if(lrNo[i].text == "" && eVaNo[i].text == "" && lr[i] == true && eva[i] == true){
                                  onSubmit(i, null, null, dispatchList[i].productQuantity, dispatchList[i].productId, orderNo[i].text, dispatchList[i].orderdetailId, dispatchList[i].orderDetailsKey, widget.element.warehouseId,"photoLR${widget.element.warehouseId}.jpg", "photoEva${widget.element.warehouseId}.jpg");
                                } else {
                                  Alerts.showAlertAndBack(context, "Invalid Value", "Please add lrno and eva no or add bill");
                                }
                              },),
                          ),
                        ],
                      ),
                    );
                  }
              );
            }
          ),
        ),
    );
  }

  onSubmit(int i, String lrNo1, String evaNo1, String qty, String productId, String orderId, String orderDId, String warehouseID, String warhouseKey, String lrImage, String evaImage) async{

    print("object String ${lr[i]} ${eva[i]} $lrNo1, String $evaNo1, String $qty, String $productId, String $orderId, String $orderDId, String $warehouseID, String $warhouseKey");

    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();

    var response = await http.post(Uri.parse(Connection.dispatchData), body: {
      'secretkey':Connection.secretKey,
      'lrno':"123",
      'eva':"456",
      'lrimage':"$lrImage",
      'evaimage':"$evaImage",
      'qty':"$qty",
      'productid':"$productId",
      'orderid':"$orderId",
      'OrderDetailsid':"$orderDId",
      'warehouse':"$warehouseID",
      'tracknumber':"$warhouseKey",
    });
    print("object ${response.body}");

    var results = json.decode(response.body);
    print("object $results");
    pr.hide();
    if (results['status'] == true) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => DispatchProcessingPage(element: widget.element,  page: widget.page,)), (route) => false);
    } else {
      Alerts.showAlertAndBack(context, "Dispatch Failed", "Please try again later");
    }
  }

  futureShowChoiceDialogLr(int i) {
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.blue),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _uploadLrGallery(i);

                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _uploadLrCamera(i);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
            ],
          ),
        ),);
    });
  }

  _uploadLrGallery(int i) async {

    final _pickedPic = await _imagePicker.pickImage(source: ImageSource.gallery);

    _imageFile = File(_pickedPic.path);

    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Data');
    pr.show();

    String value = await updateLRPhoto(_imageFile);

    print("value $value");

    setState(() {
      if(value == "success"){
        lr[i] = true;
        final snackBar = SnackBar(content: Text('Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        Alerts.showAlertAndBack(context, "Error", "Error loading image");
      }
    });

    pr.hide();

  }

  _uploadLrCamera(int i) async {

    final _pickedPic = await _imagePicker.pickImage(source: ImageSource.camera);

    _imageFile = File(_pickedPic.path);


    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Data');
    pr.show();
    String value = await updateLRPhoto(_imageFile);
    print("value $value");

    setState(() {
      if(value == "success"){
        lr[i] = true;
        final snackBar = SnackBar(content: Text('Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        Alerts.showAlertAndBack(context, "Error", "Error loading image");
      }
    });
    pr.hide();
  }

  Future<String> updateLRPhoto(File photo) async {
    print("object inside upload ${photo.path}");
    var request = http.MultipartRequest("POST", Uri.parse(Connection.wareLRimageUpload));
    request.fields['secretkey'] = '${Connection.secretKey}';
    request.files.add(await http.MultipartFile.fromPath('lrimage', photo.path,
        filename: 'photoLR${widget.element.warehouseId}.jpg', contentType: MediaType('image', 'jpeg')));
    final streamResponse = await request.send();
    print("object ${streamResponse.statusCode}");
    print("object response ${streamResponse.statusCode} ${streamResponse.request}");
    if (streamResponse.statusCode >= 200 && streamResponse.statusCode <= 299) {
      final http.Response response = await http.Response.fromStream(streamResponse);
      final results = json.decode(response.body);
      if (results['data'] != null) {
        print("object ${results['data']}");
        return "success";
      } else {
        return null;
      }
    } else {
      return "false";
    }
  }

  futureShowChoiceDialogEVA(int i) {
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.blue),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _uploadEVAGallery(i);

                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                  _uploadEVACamera(i);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
            ],
          ),
        ),);
    });
  }

  _uploadEVAGallery(int i) async {

    final _pickedPic = await _imagePicker.pickImage(source: ImageSource.gallery);

    _imageFile = File(_pickedPic.path);

    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Data');
    pr.show();

    String value = await updateEVAPhoto(_imageFile);

    print("value $value");

    setState(() {
      if(value == "success"){
        eva[i] = true;
        final snackBar = SnackBar(content: Text('Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        Alerts.showAlertAndBack(context, "Error", "Error loading image");
      }
    });

    pr.hide();

  }

  _uploadEVACamera(int i) async {

    final _pickedPic = await _imagePicker.pickImage(source: ImageSource.camera);

    _imageFile = File(_pickedPic.path);


    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: 'Uploading Data');
    pr.show();
    String value = await updateEVAPhoto(_imageFile);
    print("value $value");

    setState(() {
      if(value == "success"){
        eva[i] = true;
        final snackBar = SnackBar(content: Text('Image Uploaded Successfully'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        pr.hide();
        Alerts.showAlertAndBack(context, "Error", "Error loading image");
      }
    });
    pr.hide();
  }

  Future<String> updateEVAPhoto(File photo) async {
    print("object inside upload ${photo.path}");
    var request = http.MultipartRequest("POST", Uri.parse(Connection.wareEVAimageUpload));
    request.fields['secretkey'] = '${Connection.secretKey}';
    request.files.add(await http.MultipartFile.fromPath('evaimage', photo.path,
        filename: 'photoEva${widget.element.warehouseId}.jpg', contentType: MediaType('image', 'jpeg')));
    final streamResponse = await request.send();
    print("object ${streamResponse.statusCode}");
    print("object response ${streamResponse.statusCode} ${streamResponse.request}");
    if (streamResponse.statusCode >= 200 && streamResponse.statusCode <= 299) {
      final http.Response response = await http.Response.fromStream(streamResponse);
      final results = json.decode(response.body);
      if (results['status'] == true) {
        print("object ${results['data']}");
        return "success";
      } else {
        return null;
      }
    } else {
      return "false";
    }
  }


}
