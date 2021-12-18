import 'package:desire_production/bloc/admin_chat_list_bloc.dart';
import 'package:desire_production/model/admin_chat_list_model.dart';
import 'package:desire_production/pages/admin/chat/admin_chatting_page.dart';
import 'package:desire_production/pages/admin/chat/customer_list_for_chat_page.dart';
import 'package:desire_production/pages/admin/chat/salesman_list_for_chat_page.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class AdminChatListPage extends StatefulWidget {
  const AdminChatListPage({Key key}) : super(key: key);

  @override
  _AdminChatListPageState createState() => _AdminChatListPageState();
}

class _AdminChatListPageState extends State<AdminChatListPage> {

  final adminChatListBloc = AdminChatListBloc();
  AsyncSnapshot<AdminChatListModel> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    adminChatListBloc.fetchAdminChatList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    adminChatListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Chats",style: TextStyle(
            color: Colors.black
        ),),
        centerTitle: true,
        backgroundColor: Colors.white,

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 10.0,right: 10,bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FloatingActionButton.extended(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return CustomerListForChatPage();
              }));
            }, label: Text("Customer's",),backgroundColor: kPrimaryColor,),
            FloatingActionButton.extended(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return SalesmanListForChatPage();
              }));

            }, label: Text("Salesman's"),backgroundColor: kPrimaryColor,)
          ],
        ),
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return StreamBuilder<AdminChatListModel>(
        stream: adminChatListBloc.adminChatListStream,
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
                  ...List.generate(asyncSnapshot.data.adminConversations.length, (index) => CustomerChatListTile(
                    adminConversations: asyncSnapshot.data.adminConversations[index],


                  ))

                ],
              ),
            );
          }

        });
  }
}
class CustomerChatListTile extends StatelessWidget {

  final AdminConversations adminConversations;




  const CustomerChatListTile({Key key, this.adminConversations}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: (){

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return AdminChattingPage(
              receiverName: adminConversations.convName,
              receiverId: adminConversations.convId,
              conversationId: adminConversations.conversationId,
              type: adminConversations.convWith,
            );
          }));

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: kPrimaryColor,
                child: Text(adminConversations.convId.toString(),style: TextStyle(color: kWhiteColor),)
            ),
            SizedBox(width: 10,),
            Text(adminConversations.convName,style: TextStyle(color: kBlackColor,fontSize: 16,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}