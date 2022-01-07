
import 'dart:convert';
import 'package:desire_users/bloc/invoice_bloc.dart';
import 'package:desire_users/models/invoice_model.dart';
import 'package:desire_users/pages/invoice/invoice_list_page.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:http/http.dart' as http;


class AddComplaint extends StatefulWidget {
  final customerId;
  const AddComplaint({Key key, this.customerId}) : super(key: key);

  @override
  _AddComplaintState createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {


  final orderNumberController = TextEditingController();
  final descriptionController = TextEditingController();

  String _mySelection;
  final InvoiceBloc invoiceBloc =  InvoiceBloc();
  AsyncSnapshot<InvoiceModel> asyncSnapshot;

  @override
  void initState() {
    super.initState();
  invoiceBloc.fetchInvoiceDetails(widget.customerId);
  }

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
        title: Text("Add Complaint"),
        centerTitle: true,
      ),
      body: _body(),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: kPrimaryColor,
          height: 50,
          child: Center(child: Text("ADD COMPLAINT",style: TextStyle(color: kWhiteColor,fontSize: 16,fontWeight: FontWeight.bold),)),
        ),
      ),
    );
  }

  Widget _body(){
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
          // Expanded(
          //   child: StreamBuilder<InvoiceModel>(
          //     stream: invoiceBloc.invoiceStream,
          //     builder: (context, snapshot) {
          //       return Container(
          //         width: MediaQuery.of(context).size.width,
          //         child: DropdownButton(
          //           hint: Text("Select Invoice"),
          //           items:[
          //         ...List.generate(snapshot.data.customerInvoice.length, (index) {
          //           return DropdownMenuItem(child: DropdownTile(
          //             customerInvoice: snapshot.data.customerInvoice[index] ,
          //           )
          //           );
          //         }
          //         )
          //           ],
          //           onChanged: (newVal) {
          //             setState(() {
          //               _mySelection = newVal;
          //             });
          //           },
          //           value: _mySelection,
          //         ),
          //       );
          //     }
          //   ),
          // ),
          // SizedBox(height: 20,),
          TextFormField(
            cursorColor: kSecondaryColor,
            controller: descriptionController,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: "Description",
                hintText: "Enter Description",
                labelStyle: TextStyle(color: kPrimaryColor,fontSize: 14),
                hintStyle: TextStyle(color: kSecondaryColor,fontSize: 12),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: kSecondaryColor
                  ),
                ),
                focusedBorder:  OutlineInputBorder(
                  borderSide: BorderSide(
                      color: kPrimaryColor
                  ),
                )
            ),
            maxLength: 500,
            maxLines: 5,
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingActionButton.extended(onPressed: (){
                chooseImageSource();

              }, label: Text("Choose Image",style: TextStyle(fontSize: 12),),
              icon: Icon(Icons.image),
                backgroundColor: kPrimaryColor,
              ),
              FloatingActionButton.extended(onPressed: (){
                chooseVideoSource();

              }, label: Text("Choose Video",style: TextStyle(fontSize: 12),),
              icon: Icon(Icons.video_call),
                backgroundColor: kSecondaryColor,
              ),

            ],

          ),
          SizedBox(height: 20,),
          Expanded(
            child: buildGridView(),
          )

        ],
      ),
    );

  }


  List<Asset> images = <Asset>[];
  String _error = 'No Error Detected';



  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 5,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: AssetThumb(
            asset: asset,
            width: 100,
            height: 100,

          ),
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
       //   doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  chooseImageSource(){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Container(
          height: 70,
          child: Column(
            children: [
              GestureDetector(
                onTap: (){

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt,color: kPrimaryColor,),
                    SizedBox(width: 10,),
                    Text("Open Camera",style: TextStyle(color: kBlackColor,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Divider(height: 20,color: kSecondaryColor,),
              GestureDetector(
                onTap: (){
                     loadAssets();
                     Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.photo,color: kPrimaryColor,),
                    SizedBox(width: 10,),
                    Text("Open Gallery",style: TextStyle(color: kBlackColor,fontSize: 14,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
  chooseVideoSource(){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Container(
          height: 70,
          width: 70,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 Icon(Icons.camera_alt,color: kPrimaryColor,),
                  SizedBox(width: 10,),
                  Text("Open Camera",style: TextStyle(color: kBlackColor,fontSize: 14,fontWeight: FontWeight.bold),),
                ],
              ),
              Divider(height: 20,color: kSecondaryColor,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 Icon(Icons.photo,color: kPrimaryColor,),
                  SizedBox(width: 10,),
                  Text("Open Gallery",style: TextStyle(color: kBlackColor,fontSize: 14,fontWeight: FontWeight.bold),),
                ],
              ),

            ],
          ),
        ),
      );
    });
  }


}

class DropdownTile extends StatelessWidget {

  final CustomerInvoice customerInvoice;
  const DropdownTile({Key key, this.customerInvoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(customerInvoice.dispatchinvoiceid+customerInvoice.invoiceNumber);
  }
}
