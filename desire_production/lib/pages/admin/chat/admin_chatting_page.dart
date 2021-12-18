import 'dart:async';
import 'dart:convert';
import 'package:desire_production/bloc/admin_chat_details_bloc.dart';
import 'package:desire_production/model/admin_chat_details_model.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminChattingPage extends StatefulWidget {
  final receiverId, receiverName;
  final conversationId;
  final type;


  AdminChattingPage({this.receiverId, this.receiverName, this.conversationId, this.type});

  @override
  _AdminChattingPageState createState() => _AdminChattingPageState();
}

class _AdminChattingPageState extends State<AdminChattingPage> {

  final AdminChatDetailsBloc adminChatDetailsBloc = AdminChatDetailsBloc();
  AsyncSnapshot<AdminChatDetailsModel> asyncSnapshot;
  TextEditingController _chatController = TextEditingController();

  dynamic customer = 3;
  dynamic salesman = 2;

  int conversationId;

  newConversation(dynamic receiverId, dynamic receiver)async{
    var url = Connection.newConversation;
    var response = await http.post(Uri.parse(url), body: {
      "secretkey" : r"12!@34#$5%",
      "sender_id": 1,
      "receiver_id": receiverId,
      "receiver": receiver


    });
    var result = json.decode(response.body);
    print("sendMessage   response $result");
    if(result["message"] ==  "New conversation"){
      print("New conversation");
      conversationId = result["conversation_id"];

    }
    else {
      print("No new conversation");
    }
  }



  clearChatApi()async{
    var url = Connection.clearChat;
    var response = await http.post(Uri.parse(url), body: {
      "secretkey" : r"12!@34#$5%",
      "conversation_id": widget.conversationId
    });
    var result = json.decode(response.body);
    print("sendMessage   response $result");
    if(result["message"] == "Chat clear succefully"){
      print("Chat Clear");
      final snackBar =
      SnackBar(content: Text("All Chat Clear Successfully"));
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
    newConversation(widget.receiverId,widget.type);
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) =>
        adminChatDetailsBloc.fetchAdminChatDetails(widget.conversationId == null ? conversationId : widget.conversationId)
    );

  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    adminChatDetailsBloc.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(widget.type == 3 ? "${widget.receiverName} Customer":"${widget.receiverName} Salesman",style: TextStyle(
            color: Colors.black
        ),),
        centerTitle: true,
        backgroundColor: Colors.white,
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
    var url = Connection.sendMessage;

    var response = await http.post(Uri.parse(url), body: {
      "secretkey" :Connection.secretKey,
      "sender_id": "1",
      "receiver": customer? "3" : "2",
      "message": _chatController.text,
      "receiver_id": widget.receiverId

    });
    var result = json.decode(response.body);
    print("sendMessage   response $result");
    if(result["message"] == "Send message succefully"){

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
        decoration: BoxDecoration(
          border: Border.all(color: kSecondaryColor,width: 0.5),
          color: Colors.white,
        ),
        height: 60,
        width: double.infinity,

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
  Widget chatDetailsView(){
    return StreamBuilder<AdminChatDetailsModel>(
        stream: adminChatDetailsBloc.adminChatDetailsStream,
        builder: (c,s){
          asyncSnapshot = s;
          return  asyncSnapshot.connectionState != ConnectionState.active ?
          Center(child: CircularProgressIndicator(color: kSecondaryColor,)):
          asyncSnapshot.hasError ? Center(child: Center(child: Text("Something went wrong"))):
          asyncSnapshot.data.adminChat == null ?   Center(child: Text("No Chats")):
          asyncSnapshot.data.message == "conversation id is null." ?   Center(child: Text("No Chat",style: TextStyle(color: kBlackColor),)):
          RefreshIndicator(
            color: kPrimaryColor,
            onRefresh: (){
              return  adminChatDetailsBloc.fetchAdminChatDetails(widget.conversationId == null ? conversationId : widget.conversationId);
            },
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  ...List.generate(asyncSnapshot.data.adminChat.length, (index) => AdminChatDetailsTile(
                    adminChat: asyncSnapshot.data.adminChat[index],
                  )),
                  SizedBox(height: 60,),

                ],
              ),
            ),
          );

        });
  }

}

class AdminChatDetailsTile extends StatelessWidget{

  final AdminChat adminChat;
  final salesman;
  final customer;

  AdminChatDetailsTile({this.adminChat, this.salesman, this.customer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
      child: Align(
        alignment: (adminChat.senderId == "1"?Alignment.topRight
           :Alignment.topLeft),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (adminChat.senderId == "1"?kPrimaryColor: kSecondaryColor),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(adminChat.senderName, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: kWhiteColor),),
              SizedBox(height: 5,),
              Text(adminChat.message, style: TextStyle(fontSize: 15,color: kWhiteColor),),
              SizedBox(height: 5,),
              Text(adminChat.date.split(" ").first, style: TextStyle(fontSize: 10,color: kWhiteColor),),
            ],
          ),
        ),
      ),
    );

  }
}
