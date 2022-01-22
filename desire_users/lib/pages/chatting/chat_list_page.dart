import 'package:desire_users/bloc/customer_chat_list_bloc.dart';
import 'package:desire_users/models/customer_chat_list_model.dart';
import 'package:desire_users/pages/chatting/chatting_page.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';

class ChatListPage extends StatefulWidget {
  final customerId, salesmanId;

  const ChatListPage({Key key, this.customerId, this.salesmanId})
      : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final CustomerChatListBloc customerChatListBloc = CustomerChatListBloc();
  AsyncSnapshot<CustomerChatListModel> asyncSnapshot;

  String admin = "1";
  String salesman = "2";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerChatListBloc.fetchCustomerChatList(widget.customerId);
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
          backgroundColor: kWhiteColor,
          iconTheme: IconThemeData(color: kBlackColor),
          title: Text("Chats"),
          titleTextStyle: TextStyle(
              color: kBlackColor, fontSize: 18, fontWeight: FontWeight.bold),
          centerTitle: true,
        ),
        body: _body(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingActionButton.extended(
                backgroundColor: kPrimaryColor,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChattingPage(
                      chatPersonName: "Admin",
                      receiverId: 1,
                      customerId: widget.customerId,

                    );
                  }));
                },
                label: Text("Admin"),
                icon: Icon(Icons.message),
              ),
              FloatingActionButton.extended(
                backgroundColor: kPrimaryColor,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChattingPage(
                      chatPersonName: "",
                      receiverId: widget.salesmanId,
                      customerId: widget.customerId,
                    );
                  }));
                },
                label: Text("Salesman"),
                icon: Icon(Icons.message),
              ),
            ],
          ),
        ));
  }

  Widget _body() {
    return StreamBuilder<CustomerChatListModel>(
        stream: customerChatListBloc.catStream,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.active) {
            print("all connection");
            return Container(
                height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50,
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ));
          } else if (s.hasError) {
            print("as3 error");
            print(s.error);
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: SelectableText(
                "Error Loading Data ${s.error}",
              ),
            );
          } else if (s.data.toString().isEmpty) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          } else if (s.data.customerConversations == null) {
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          } else {
            asyncSnapshot = s;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                      asyncSnapshot.data.customerConversations.length,
                      (index) => CustomerChatListTile(
                            customerChat:
                                asyncSnapshot.data.customerConversations[index],
                            customerId: widget.customerId,
                          ))
                ],
              ),
            );
          }
        });
  }

  selectChatPerson() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 105,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Text(
                                "$admin.",
                                style: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Chat with Admin",
                                style: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Text(
                                "$salesman.",
                                style: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Chat with Salesman",
                                style: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class CustomerChatListTile extends StatelessWidget {
  final CustomerConversations customerChat;
  final customerId;

  const CustomerChatListTile({
    Key key,
    this.customerChat,
    this.customerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChattingPage(
              chatPersonName: customerChat.convName,
              receiverId: customerChat.convId,
              customerId: customerId,
            );
          }));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: kPrimaryColor,
                child: Text(
                  customerChat.convId.toString(),
                  style: TextStyle(color: kWhiteColor),
                )),
            SizedBox(
              width: 10,
            ),
            Text(
              customerChat.convName,
              style: TextStyle(
                  color: kBlackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
