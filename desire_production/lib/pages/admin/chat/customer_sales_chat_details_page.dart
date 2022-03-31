import 'package:desire_production/bloc/customer_sales_chat_bloc.dart';
import 'package:desire_production/model/customer_sale_chat_details.dart';
import 'package:desire_production/model/customer_sales_chat_track_model.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomerSalesChatDetailsPage extends StatefulWidget {
  final convId;
  final senderId;

  const CustomerSalesChatDetailsPage({Key key, this.convId, this.senderId})
      : super(key: key);

  @override
  _CustomerSalesChatDetailsPageState createState() =>
      _CustomerSalesChatDetailsPageState();
}

class _CustomerSalesChatDetailsPageState
    extends State<CustomerSalesChatDetailsPage> {
  final customerSalesChatBloc = CustomerSalesChatBloc();
  AsyncSnapshot<CustomerSaleChatDetailsModel> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerSalesChatBloc.fetchCustomerSalesChatDetails(widget.convId);
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
          "Chats Details",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder<CustomerSaleChatDetailsModel>(
        stream: customerSalesChatBloc.customerSalesChatDetailsStream,
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
                child:ListView.builder(
                        itemCount: asyncSnapshot.data.salesCustomerChat.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return CustomerChatListTile(
                              salesCustomerChat:
                                  asyncSnapshot.data.salesCustomerChat[index],
                              senderId: widget.senderId);
                        }));
          }
        });
  }
}

class CustomerChatListTile extends StatelessWidget {
  final SalesCustomerChat salesCustomerChat;
  final String senderId;

  const CustomerChatListTile({Key key, this.salesCustomerChat, this.senderId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10,top: 10,bottom: 10),
      child: Align(
        alignment: (salesCustomerChat.senderId == senderId?Alignment.topRight
            :Alignment.topLeft),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: (salesCustomerChat.senderId == senderId?kPrimaryColor: kSecondaryColor),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(salesCustomerChat.senderName, style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: kWhite),),
              SizedBox(height: 5,),
              Text(salesCustomerChat.message, style: TextStyle(fontSize: 15,color: kWhite),),
              SizedBox(height: 5,),
              Text(salesCustomerChat.date.split(" ").first, style: TextStyle(fontSize: 10,color: kWhite),),
            ],
          ),
        ),
      ),
    );
  }
}
