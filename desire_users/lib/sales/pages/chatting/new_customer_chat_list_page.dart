import 'package:desire_users/models/new_customer_list_model.dart';
import 'package:desire_users/sales/bloc/new_customer_list_bloc.dart';
import 'package:desire_users/sales/pages/chatting/sales_chatting_page.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';


class NewCustomerChatListPage extends StatefulWidget {
  final salesId;
  const NewCustomerChatListPage({Key key, this.salesId}) : super(key: key);

  @override
  _NewCustomerChatListPageState createState() => _NewCustomerChatListPageState();
}

class _NewCustomerChatListPageState extends State<NewCustomerChatListPage> {

  final NewCustomerListBloc newCustomerListBloc =  NewCustomerListBloc();
  AsyncSnapshot<CustomerListModel> asyncSnapshot;


  String admin = "1";
  String salesman = "2";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    newCustomerListBloc.fetchNewCustomerList(widget.salesId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    newCustomerListBloc.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        iconTheme: IconThemeData(
            color: kBlackColor
        ),
        title: Text("Customers"),
        titleTextStyle: TextStyle(color: kBlackColor,fontSize: 18,fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return StreamBuilder<CustomerListModel>(
        stream: newCustomerListBloc.newCustomerListStream,
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
                  ...List.generate(asyncSnapshot.data.customerList.length, (index) => CustomerChatListTile(
                    customerList: asyncSnapshot.data.customerList[index],
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

  final CustomerList customerList;
 final salesId;

  const CustomerChatListTile({Key key, this.customerList, this.salesId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: (){

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return SalesChattingPage(senderId: salesId,receiverName: customerList.customerName,chatWith:customerList.customerId,conversationId: "",);
          }));

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: kPrimaryColor,
                child: Text(customerList.customerId.toString(),style: TextStyle(color: kWhiteColor),)
            ),
            SizedBox(width: 10,),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(customerList.customerName,style: TextStyle(color: kBlackColor,fontSize: 16,fontWeight: FontWeight.bold),),
                Text(customerList.email,style: TextStyle(color: kSecondaryColor,fontSize: 12),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}