import 'package:desire_production/bloc/customer_sales_chat_bloc.dart';
import 'package:desire_production/model/customer_sales_chat_track_model.dart';
import 'package:desire_production/pages/admin/chat/customer_sales_chat_details_page.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomerSalesChatTrack extends StatefulWidget {
  const CustomerSalesChatTrack({Key key}) : super(key: key);

  @override
  _CustomerSalesChatTrackState createState() => _CustomerSalesChatTrackState();
}

class _CustomerSalesChatTrackState extends State<CustomerSalesChatTrack> {
  final customerSalesChatBloc = CustomerSalesChatBloc();
  AsyncSnapshot<CustomerSalesChatTrackModel> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerSalesChatBloc.fetchCustomerSalesChatList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    customerSalesChatBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Chats",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder<CustomerSalesChatTrackModel>(
        stream: customerSalesChatBloc.customerSalesChatStream,
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
          } else {
            asyncSnapshot = s;
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                      asyncSnapshot.data.salesCustomerConversations.length,
                      (index) => CustomerChatListTile(
                            salesCustomerConversations: asyncSnapshot
                                .data.salesCustomerConversations[index],
                          ))
                ],
              ),
            );
          }
        });
  }
}

class CustomerChatListTile extends StatelessWidget {
  final SalesCustomerConversations salesCustomerConversations;

  const CustomerChatListTile({Key key, this.salesCustomerConversations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CustomerSalesChatDetailsPage(convId: salesCustomerConversations.conversationId);
          }));
        },
        child: Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
            height: 50,
            padding: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(5)),
            child: Text(
              salesCustomerConversations.convWith,
              style: TextStyle(color: kWhite, fontWeight: FontWeight.w700, fontSize: 15),
            )),
      ),
    );
  }
}
