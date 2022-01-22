import 'dart:convert';

import 'package:desire_production/bloc/customer_list_for_chat_bloc.dart';
import 'package:desire_production/model/customer_list_for_chat_model.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'admin_chatting_page.dart';


class CustomerListForChatPage extends StatefulWidget {
  const CustomerListForChatPage({Key key}) : super(key: key);

  @override
  _CustomerListForChatPageState createState() => _CustomerListForChatPageState();
}

class _CustomerListForChatPageState extends State<CustomerListForChatPage> {

  final customerChatListBloc = CustomerListForChatBloc();
  AsyncSnapshot<CustomerListForChatModel> asyncSnapshot;


  newConversation(dynamic receiverId)async{
    var url = Connection.newConversation;
    var response = await http.post(Uri.parse(url), body: {
      "secretkey" : r"12!@34#$5%",
      "sender_id": "1",
      "receiver_id": receiverId,
      "receiver": 3


    });
    var result = json.decode(response.body);
    print("sendMessage   response $result");
    if(result["status"]){
      print("New conversation");

    }
    else {
      print("Chat Not Clear");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerChatListBloc.fetchCustomerListForChat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    customerChatListBloc.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Customers",style: TextStyle(
            color: Colors.black
        ),),
        centerTitle: true,
        backgroundColor: Colors.white,

      ),
      body: StreamBuilder<CustomerListForChatModel>(
          stream: customerChatListBloc.customerListForChatStream,
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
            else if (s.hasError) {
              print("as3 error");
              print(s.error);
              return Container(height: 300,
                alignment: Alignment.center,
                child: SelectableText("Error Loading Data ${s.error}",),);
            }
            else  if (s.data.toString().isEmpty) {
              print("as3 empty");
              return Container(height: 300,
                alignment: Alignment.center,
                child: Text("No Data Found",),);
            }
            else {
              asyncSnapshot = s;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(asyncSnapshot.data.customerList.length, (index) => CustomerListTile(
                      customerList: asyncSnapshot.data.customerList[index],


                    ))

                  ],
                ),
              );
            }

          }),
    );
  }
}
class CustomerListTile extends StatelessWidget {

  final CustomerList customerList;

  const CustomerListTile({Key key, this.customerList}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return AdminChattingPage(
              receiverId: customerList.customerId,
              receiverName: customerList.customerName,
              type: "3",
              conversationId: "",
            );
          }));


        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: kPrimaryColor,
                child: Text(customerList.customerId.toString(),style: TextStyle(color: kWhite),)
            ),
            SizedBox(width: 10,),
            Text(customerList.customerName,style: TextStyle(color: kBlackColor,fontSize: 16,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
