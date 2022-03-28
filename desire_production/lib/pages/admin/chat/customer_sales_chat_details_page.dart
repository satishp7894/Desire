import 'package:desire_production/bloc/customer_sales_chat_bloc.dart';
import 'package:desire_production/model/customer_sale_chat_details.dart';
import 'package:desire_production/model/customer_sales_chat_track_model.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomerSalesChatDetailsPage extends StatefulWidget {
  final convId;
  const CustomerSalesChatDetailsPage({Key key, this.convId}) : super(key: key);

  @override
  _CustomerSalesChatDetailsPageState createState() => _CustomerSalesChatDetailsPageState();
}

class _CustomerSalesChatDetailsPageState extends State<CustomerSalesChatDetailsPage> {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                      asyncSnapshot.data.salesCustomerChat.length,
                          (index) => CustomerChatListTile(
                            salesCustomerChat: asyncSnapshot.data.salesCustomerChat[index],
                      ))
                ],
              ),
            );
          }
        });
  }
}

class CustomerChatListTile extends StatelessWidget {
  final SalesCustomerChat salesCustomerChat;

  const CustomerChatListTile({Key key, this.salesCustomerChat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {

        },
        child: Container(
            padding: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(5)),
            child: Text(
              salesCustomerChat.message,
              style: TextStyle(color: kWhite, fontWeight: FontWeight.w700, fontSize: 15),
            )),
      ),
    );
  }
}
