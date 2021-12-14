import 'dart:async';
import 'dart:convert';

import 'package:desire_users/bloc/customer_chat_details_bloc.dart';
import 'package:desire_users/models/customer_chat_details_model.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChattingPage extends StatefulWidget {
  final chatPersonName;
  final customerId;
  final receiverId;
  const ChattingPage({Key key, this.chatPersonName, this.customerId, this.receiverId}) : super(key: key);

  @override
  _ChattingPageState createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {

  final CustomerChatDetailsBloc customerChatDetailsBloc = CustomerChatDetailsBloc();
  AsyncSnapshot<CustomerChatDetailsModel> asyncSnapshot;
  TextEditingController _chatController = TextEditingController();

  dynamic admin = "1";
  dynamic salesman = "2";


  String salesmanId = "";
  String conversationId = "";

  getSalesmanId()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      salesmanId = sharedPreferences.getString("salesmanId");
      conversationId = sharedPreferences.getString("conversationId");
      sharedPreferences.setString("receiverId", widget.receiverId.toString());
      sharedPreferences.setString("chatPersonName", widget.chatPersonName);
    });

  }


  clearChatApi()async{
    var url = "http://loccon.in/desiremoulding/api/UserApiController/clearChat";
    var response = await http.post(Uri.parse(url), body: {
      "secretkey" : r"12!@34#$5%",
      "conversation_id": conversationId
    });
    var result = json.decode(response.body);
    print("sendMessage   response $result");
    if(result["message"] == "Chat clear succefully"){
      print("Chat Clear");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChattingPage(customerId: widget.customerId,
        receiverId: widget.receiverId,chatPersonName: widget.chatPersonName,
      )));
    }
    else {
      print("Chat Not Clear");
    }
  }
 Timer timer;
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    getSalesmanId();
    customerChatDetailsBloc.fetchCustomerChatDetails(widget.customerId, widget.receiverId.toString());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) =>  customerChatDetailsBloc.fetchCustomerChatDetails(widget.customerId, widget.receiverId.toString()));

  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    customerChatDetailsBloc.dispose();
    timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: kBlackColor
        ),
        titleTextStyle: TextStyle(color: kBlackColor,fontSize: 18.0),
        title: Text(widget.chatPersonName == "Admin"? "${widget.chatPersonName}": "${widget.chatPersonName} Salesman"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Text("Clear Chat"),
                  onTap: (){
                    clearChatApi();

                  },
                  value: 1,
                ),
              ]
          )
        ],
      ),
      body: Stack(
        children: [
          chatDetailsView(),
         _sendMessageView()

        ],
      )
    );
  }


  Widget chatDetailsView(){
    return StreamBuilder<CustomerChatDetailsModel>(
        stream: customerChatDetailsBloc.customerChatDetailsStream,
        builder: (c,s){
          asyncSnapshot = s;
          return  asyncSnapshot.connectionState != ConnectionState.active ?
          Center(child: CircularProgressIndicator(color: kSecondaryColor,)):
              asyncSnapshot.hasError ? Center(child: Text("Something went wrong")):
              asyncSnapshot.data == null ?   Text("No Chats"):
              asyncSnapshot.data.customerChat == [] ?   Center(child: Text("No Chat",style: TextStyle(color: kBlackColor),)):
          RefreshIndicator(
            color: kPrimaryColor,
            onRefresh: (){
              return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChattingPage(customerId: widget.customerId,
                receiverId: widget.receiverId,chatPersonName: widget.chatPersonName,
              )));
            },
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                 ...List.generate(asyncSnapshot.data.customerChat.length, (index) => CustomerChatTiles(
                   customerChat: asyncSnapshot.data.customerChat[index],
                  salesmanId: salesmanId,
                 )),
                  SizedBox(height: 60,),

                ],
              ),
            ),
          );

    });
  }


  _sendMessageApi()async{
    var url = "http://loccon.in/desiremoulding/api/UserApiController/sendMessage";
    var response = await http.post(Uri.parse(url), body: {
      "secretkey" : r"12!@34#$5%",
      "sender_id": "${widget.customerId}",
      "receiver": widget.receiverId == 1 ? "$admin" : "$salesman",
      "message": _chatController.text

    });
    var result = json.decode(response.body);
    print("sendMessage   response $result");
    if(result["message"] == "Send message succefully"){
      print("Message Sent");
      _chatController.clear();
    }
    else {
      print("Message Not Sent");
    }


  }

  Widget _sendMessageView() {
    return  Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _chatController,
                decoration: InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none
                ),
              ),
            ),
            SizedBox(width: 15,),
            FloatingActionButton(
              onPressed: (){
              _chatController.text.isEmpty ? print("No Text"):_sendMessageApi();
              },
              child: Icon(Icons.send,color: Colors.white,size: 18,),
              backgroundColor: kPrimaryColor,
              elevation: 0,
            ),
          ],

        ),
      ),
    );
  }

}


class CustomerChatTiles extends StatelessWidget {

  final CustomerChat customerChat;
  final salesmanId;

  const CustomerChatTiles({Key key, this.customerChat, this.salesmanId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
      child: Align(
        alignment: (customerChat.senderId == "1"?Alignment.topLeft
            : customerChat.senderId == salesmanId? Alignment.topLeft
            :Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (customerChat.senderId == "1"?kSecondaryColor:customerChat.senderId == salesmanId? kSecondaryColor: kPrimaryColor),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(customerChat.senderName, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: kWhiteColor),),
              SizedBox(height: 5,),
              Text(customerChat.message, style: TextStyle(fontSize: 15,color: kWhiteColor),),
              SizedBox(height: 5,),
              Text(customerChat.date.split(" ").first, style: TextStyle(fontSize: 10,color: kWhiteColor),),
            ],
          ),
        ),
      ),
    );
  }
}

