
import 'package:desire_users/models/customer_chat_list_model.dart';
import 'package:desire_users/models/sales_chat_list_model.dart';
import 'package:desire_users/sales/bloc/sales_chat_list_bloc.dart';
import 'package:desire_users/sales/pages/chatting/new_customer_chat_list_page.dart';
import 'package:desire_users/sales/pages/chatting/sales_chatting_page.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SalesChatList extends StatefulWidget {
  final salesId;
  const SalesChatList({Key key, this.salesId}) : super(key: key);

  @override
  _SalesChatListState createState() => _SalesChatListState();
}

class _SalesChatListState extends State<SalesChatList> {


  final SalesChatListBloc salesChatListBloc =  SalesChatListBloc();
  AsyncSnapshot<SalesChatListModel> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    salesChatListBloc.fetchSalesChatList(widget.salesId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    salesChatListBloc.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        iconTheme: IconThemeData(
            color: kBlackColor
        ),
        title: Text("Chats"),
        titleTextStyle: TextStyle(color: kBlackColor,fontSize: 18,fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20,bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FloatingActionButton.extended(
              backgroundColor: kPrimaryColor,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return SalesChattingPage(senderId: widget.salesId,chatWith: 1,receiverName: "Admin",conversationId: "");
                }));


              }, label: Text("Admin"),icon: Icon(Icons.message),),
            FloatingActionButton.extended(
              backgroundColor: kPrimaryColor,
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return NewCustomerChatListPage(salesId: widget.salesId,);
                }));


              }, label: Text("Customers"),icon: Icon(Icons.message),),
          ],
        ),
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return StreamBuilder<SalesChatListModel>(
        stream: salesChatListBloc.salesChatListStream,
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
                  ...List.generate(asyncSnapshot.data.salesConversations.length, (index) => CustomerChatListTile(
                    salesConversations: asyncSnapshot.data.salesConversations[index],
                    salesId: widget.salesId,


                  ))

                ],
              ),
            );
          }

        });
  }
}
class CustomerChatListTile extends StatelessWidget {

  final SalesConversations salesConversations;

  final salesId;



  const CustomerChatListTile({Key key, this.salesConversations, this.salesId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: (){

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return SalesChattingPage(senderId: salesId,receiverName: salesConversations.convName,chatWith:salesConversations.convId,
              conversationId: salesConversations.conversationId,
            );
          }));

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: kPrimaryColor,
                child: Text(salesConversations.convId.toString(),style: TextStyle(color: kWhiteColor),)
            ),
            SizedBox(width: 10,),
            Text(salesConversations.convName,style: TextStyle(color: kBlackColor,fontSize: 16,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}