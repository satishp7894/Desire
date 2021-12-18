import 'dart:async';
import 'dart:convert';

import 'package:desire_users/models/sales_chat_detail_model.dart';
import 'package:desire_users/sales/bloc/sales_chat_detail_bloc.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SalesChattingPage extends StatefulWidget {

  final senderId, receiverName;
  final dynamic chatWith;
  final conversationId;


  const SalesChattingPage({Key key, this.senderId, this.receiverName, this.chatWith, this.conversationId}) : super(key: key);

  @override
  _SalesChattingPageState createState() => _SalesChattingPageState();
}

class _SalesChattingPageState extends State<SalesChattingPage> {


final SalesChatDetailsBloc salesChatDetailsBloc = SalesChatDetailsBloc();
AsyncSnapshot<SalesChatDetailModel> asyncSnapshot;
TextEditingController _chatController = TextEditingController();

dynamic admin = 1;
dynamic customer = 3;

dynamic conversationId;

getConversationId() async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  setState(() {
    conversationId = sharedPreferences.getString("conversationId");
  });

}

clearChatApi()async{
  var url = "http://loccon.in/desiremoulding/api/SalesApiController/clearChat";
  var response = await http.post(Uri.parse(url), body: {
    "secretkey" : r"12!@34#$5%",
    "conversation_id": widget.conversationId
  });
  var result = json.decode(response.body);
  print("sendMessage   response $result");
  if(result["message"] == "Chat clear succefully"){
    print("Chat Clear");
    final snackBar =
    SnackBar(content: Text("All Chat Cleared Successfully"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
  getConversationId();
  salesChatDetailsBloc.fetchSalesChatDetails(widget.conversationId == null ? conversationId:widget.conversationId);
  timer = Timer.periodic(Duration(seconds: 1), (Timer t) =>  salesChatDetailsBloc.fetchSalesChatDetails(widget.conversationId == null ? conversationId :widget.conversationId));

}


@override
void dispose() {
  // TODO: implement dispose
  super.dispose();
  salesChatDetailsBloc.dispose();
  timer.cancel();
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
        title: Text(widget.receiverName == "Admin"? "${widget.receiverName}": "${widget.receiverName} Customer"),
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



  _sendMessageApi()async{
    var url = "http://loccon.in/desiremoulding/api/SalesApiController/sendMessage";
    var response = await http.post(Uri.parse(url), body: {
      "secretkey" : r"12!@34#$5%",
      "sender_id": "${widget.senderId}",
      "receiver": widget.chatWith == 1 ? "$admin" : "$customer",
      "receiver_id":widget.chatWith == 1? "$admin" : widget.chatWith,
      "message": _chatController.text

    });
    var result = json.decode(response.body);

    print("sendMessage   response $result");
    if(result["message"] == "Send message succefully"){
      print("Message Sent");
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("conversationId", result["conversation_id"]);
      _chatController.clear();


    }
    else {
      print("Message Not Sent");
    }


  }

Widget chatDetailsView(){
  return StreamBuilder<SalesChatDetailModel>(
      stream: salesChatDetailsBloc.salesChatDetailsStream,
      builder: (c,s){
        asyncSnapshot = s;
        return  asyncSnapshot.connectionState != ConnectionState.active ?
        Center(child: CircularProgressIndicator(color: kSecondaryColor,)):
        asyncSnapshot.hasError ? Center(child: Text("Something went wrong")):
        asyncSnapshot.data.status == false ?   Center(child: Text("No Chat",style: TextStyle(color: kBlackColor),)):
        asyncSnapshot.data.salesChat == null ?   Center(child: Text("No Chat",style: TextStyle(color: kBlackColor),)):
        RefreshIndicator(
          color: kPrimaryColor,
          onRefresh: (){
            return salesChatDetailsBloc.fetchSalesChatDetails(widget.conversationId == null ? conversationId:widget.conversationId);
          },
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                ...List.generate(asyncSnapshot.data.salesChat.length, (index) => SalesChatTiles(
                  salesChat: asyncSnapshot.data.salesChat[index],
                  salesmanId: widget.senderId,
                )),
                SizedBox(height: 60,),

              ],
            ),
          ),
        );

      });
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

class SalesChatTiles extends StatelessWidget {

  final SalesChat salesChat;
  final customerId,salesmanId;

  const SalesChatTiles({Key key, this.salesChat, this.customerId, this.salesmanId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
      child: Align(
        alignment: (salesChat.senderId == salesmanId ?Alignment.topRight
            :Alignment.topLeft),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (salesChat.senderId == salesmanId ?kPrimaryColor : kSecondaryColor),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(salesChat.senderName, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: kWhiteColor),),
              SizedBox(height: 5,),
              Text(salesChat.message, style: TextStyle(fontSize: 15,color: kWhiteColor),),
              SizedBox(height: 5,),
              Text(salesChat.date.split(" ").first, style: TextStyle(fontSize: 10,color: kWhiteColor),),
            ],
          ),
        ),
      ),
    );
  }
}