import 'dart:convert';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/models/customer_price_listing_model.dart';
import 'package:desire_users/models/sales_customer_list_model.dart';
import 'package:desire_users/sales/bloc/customer_price_listing_bloc.dart';
import 'package:desire_users/sales/utils_sales/alerts.dart';
import 'package:desire_users/services/connection_sales.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CustomerPriceListPage extends StatefulWidget {

  final String customerId;
  final String customerName;
  final String salesId;
  final String name;
  final String email;
  const CustomerPriceListPage({@required this.customerId, @required this.customerName, @required this.salesId,  @required this.name, @required this.email, });

  @override
  _CustomerPriceListPageState createState() => _CustomerPriceListPageState();
}

class _CustomerPriceListPageState extends State<CustomerPriceListPage> {

  final customerPriceListBloc = CustomerPriceListingBloc();
  List<bool> singleCheck = [];
  bool checkAll = false;
  List<Data> data = [];

  TextEditingController termsAndConditionController =  TextEditingController();
  List<TextEditingController> newPriceController = [];

  bool search = false;
  List<Data> _searchResult = [];

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    customerPriceListBloc.fetchCustomerPriceList(widget.customerId);
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
  void dispose() {
    super.dispose();
    customerPriceListBloc.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    CustomerPriceListPage(
                      customerId:" ${widget.customerId}",
                      customerName: "${widget.customerName}",
                      email: "${widget.name}",
                      name: "${widget.email}",
                      salesId: widget.salesId,

                    )
            )
        );
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            title: Expanded(child: Text("Product Pricing",style: TextStyle(color: kBlackColor,fontSize: 16,fontWeight: FontWeight.bold),)),
            titleTextStyle: TextStyle(fontSize: 14),

          ),
          body: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: [
              headingView(),
              customerPricingListView(),
              tnC(),
              SafeArea(
                child: TextButton(
                  onPressed:sendCustomerPriceListApi,
                  child: Container(
                    color: kPrimaryColor,
                    height: 50,
                    child: Center(child: Text("SAVE",style: TextStyle(color: kWhiteColor,fontSize: 16),)),
                  ),
                ),
              ),

            ],
          ),


        ),
      ),
    );
  }


  sendCustomerPriceListApi() async{
    for(int i = 0; i<data.length; i++)
    if (termsAndConditionController.text.isEmpty) {
      final snackBar =
      SnackBar(content: Text("Please change price and describe first"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      var response = await http.post(Uri.parse("http://loccon.in/desiremoulding/api/SalesApiController/submitCustomerPriceList"), body: {
        'secretkey':ConnectionSales.secretKey,
        'sales_id': widget.salesId,
        'customer_id': widget.customerId,
        'terms_and_condition':termsAndConditionController.text,
        'product_list':[{
              "model_no_id": "${data[i].modelNoId}",
              "price":  newPriceController[i].text,
              "old_price": "${data[i].customerPrice}",
            }],
        'price_list': checkAll == true ? checkAll : singleCheck[i],

      });
      print("object ${response.body}");

      var results = json.decode(response.body);
      print("object $results");
      if (results['status'] == true) {
        print("Status${results['status']}");
        print("Message${results['message']}");
        final snackBar =
        SnackBar(content: Text("Product Price changed for ${widget.customerName} successfully"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);


      } else if (results['status'] == false){
        final snackBar =
        SnackBar(content: Text("Something went wrong"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);


      }
      else {
        final snackBar =
        SnackBar(content: Text("Something went wrong"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }
    }

  }

  Widget headingView(){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: 10,
            child: Checkbox(
              value: checkAll,
              checkColor: kWhiteColor,
              activeColor: kPrimaryColor,
              onChanged: (value) {
                setState(() {
                  checkAll = value;
                });
                print("object remember $checkAll");
                if(checkAll == true){
                  for(int i=0; i<data.length; i++ ){
                    singleCheck[i] = true;
                  }
                } else{
                  for(int i=0; i<data.length; i++){
                    singleCheck[i] = false;
                  }
                }
              },
            ),
          ),
          Text("Model No.",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: kPrimaryColor),),
          Text("MRP",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: kPrimaryColor),),
          Text("Sales Limit",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: kPrimaryColor),),
          Text("New Price",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: kPrimaryColor),),
        ],
      ),
    );
  }

  Widget customerPricingListView(){
    return StreamBuilder<CustomerPriceListModel>(
      stream: customerPriceListBloc.customerPriceListStream,
      builder: (context,as){
        if (as.connectionState != ConnectionState.active) {
          print("all connection");
          return Container(height: 300,
              alignment: Alignment.center,
              child: Center(
                heightFactor: 50, child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),));
        }
       else if (as.hasError) {
          print("as3 error");
          return Container(height: 300,
            alignment: Alignment.center,
            child: Text("Error Loading Data",),);
        }
      else  if (as.data.toString()
            .isEmpty) {
          print("as3 empty");
          return Container(height: 300,
            alignment: Alignment.center,
            child: Text("No Data Found",),);
        }
      else{

          data = as.data.data;
          for(int i=0; i<data.length; i++)
            singleCheck.add(false);
       return data.length == 0 ?
         Container(height: 300,
            alignment: Alignment.center,
            child: Text("No Data",),)
             :ListView.builder(
             itemCount:data.length,
             shrinkWrap: true,
             physics: NeverScrollableScrollPhysics(),
             itemBuilder: (c,index){
            return Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20,top: 10,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 10,
                    child: Checkbox(
                      value: singleCheck[index],
                      activeColor: kPrimaryColor,
                      onChanged: (value) {
                        setState(() {
                          singleCheck[index] = value;
                        });
                        print("object remember ${singleCheck[index]}");

                      },
                    ),
                  ),
                  Text(data[index].modelNo,textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: kBlackColor),),
                  Text(data[index].customerPrice,textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: kBlackColor),),
                  Text(data[index].salesPrice,textAlign: TextAlign.left,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: kBlackColor),),
                  Container(
                    height: 20,
                    width: 60,
                    child: Center(
                      child: TextFormField(
                        cursorColor: kBlackColor,
                        style: TextStyle(fontSize: 12),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(5)
                        ],
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: kSecondaryColor
                                )
                            ) ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColor
                                )
                            )
                        ),
                      ),
                    ),
                  )

                ],
              ),
            );
         });


        }



    });
  }

  Widget tnC (){
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10,bottom: 10),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            border: Border.all(color: kBlackColor,width: 0.5)

        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: TextFormField(
            controller: termsAndConditionController,
            cursorColor: kBlackColor,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: " Terms and Condition",
                hintStyle: TextStyle(fontSize: 12,color: kSecondaryColor)

            ),
          ),
        ),
      ),
    );

  }

}



