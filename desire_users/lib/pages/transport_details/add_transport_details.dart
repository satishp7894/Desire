import 'dart:convert';

import 'package:desire_users/pages/transport_details/transport_details_list.dart';
import 'package:desire_users/services/connection.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AddTransportDetails extends StatefulWidget {

  final customerId;

  const AddTransportDetails({Key key, this.customerId}) : super(key: key);

  @override
  _AddTransportDetailsState createState() => _AddTransportDetailsState();
}

class _AddTransportDetailsState extends State<AddTransportDetails> {

   final nameController = TextEditingController();
   final mobileNumberController = TextEditingController();
   final emailController = TextEditingController();
   final gsTinController = TextEditingController();
   final addressController = TextEditingController();
   final cityController = TextEditingController();
   final pincodeController = TextEditingController();
   final stateController = TextEditingController();



   addTransportDetailsApi()async{
     var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/UserApiController/submitCustomerTransport"), body: {
       'secretkey': '${Connection.secretKey}',
     "customer_id":"${widget.customerId}",
     "transport_name":"${nameController.text}",
     "mobile_no":"${mobileNumberController.text}",
     "email_id":"${emailController.text}",
     "gst":"${gsTinController.text}",
     "address":"${addressController.text}",
     "city":"${cityController.text}",
     "pincode":"${pincodeController.text}",
     "state":"${stateController.text}",
     });
     print("object $response");
     var decodedData = json.decode(response.body);
     print(decodedData);
     if(decodedData["status"]== true){
       final snackBar =
       SnackBar(content: Text("Transport Details Added Successfully"));
       ScaffoldMessenger.of(context).showSnackBar(snackBar);
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TransportDetailsList(customerId: widget.customerId ,)));
     }
     else {
       final snackBar =  SnackBar(content: Text("Something went wrong"));
       ScaffoldMessenger.of(context).showSnackBar(snackBar);
     }
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
        title: Text("Add Transport Details"),
        centerTitle: true,
      ),
      body: _body(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0,right: 20.0),
          child: ElevatedButton(
              style: TextButton.styleFrom(backgroundColor: kPrimaryColor,shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(20)
              )),
              onPressed: (){
                if(
                nameController.text.isEmpty &&
                    mobileNumberController.text.isEmpty &&
                    emailController.text.isEmpty &&
                    addressController.text.isEmpty &&
                    cityController.text.isEmpty &&
                    pincodeController.text.isEmpty &&
                    stateController.text.isEmpty


                ){

                  print("All fields are mandatory");

                }
                else {
                  addTransportDetailsApi();


                }

              }, child: Text("ADD TRANSPORT DETAILS",style: TextStyle(color: kWhiteColor,fontSize: 14),)),
        ),
      ),


    );
  }

  Widget _body(){

    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20,),
            TextFormField(
              cursorColor: kSecondaryColor,
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: "Transport Name",
                hintText: "Enter Transport Name",
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
            ),
            SizedBox(height: 20,),
            TextFormField(
              cursorColor: kSecondaryColor,
              controller: mobileNumberController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10),
              ],
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: "Mobile Number",
                hintText: "Enter Mobile Number",
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
            ),
            SizedBox(height: 20,),
            TextFormField(
              cursorColor: kSecondaryColor,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: "Email",
                hintText: "Enter Email",
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
            ),
            SizedBox(height: 20,),
            TextFormField(
              cursorColor: kSecondaryColor,
              controller: gsTinController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: "GSTIN",
                hintText: "Enter GSTIN",
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
            ),
            SizedBox(height: 20,),
            TextFormField(
              cursorColor: kSecondaryColor,
              controller: addressController,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Address",
                  hintText: "Enter Address",
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
            ),
            SizedBox(height: 20,),
            TextFormField(
              cursorColor: kSecondaryColor,
              controller: cityController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "City",
                  hintText: "Enter City",
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
            ),
            SizedBox(height: 20,),
            TextFormField(
              cursorColor: kSecondaryColor,
              controller: pincodeController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(6),

              ],
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "Pincode",
                  hintText: "Enter Pincode",
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
            ),
            SizedBox(height: 20,),
            TextFormField(
              cursorColor: kSecondaryColor,
              controller: stateController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: "State",
                  hintText: "Enter State",
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
            ),



          ],
        ),
      ),
    );
  }



}
