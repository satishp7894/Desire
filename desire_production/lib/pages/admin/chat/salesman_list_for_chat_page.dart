import 'package:desire_production/bloc/salesman_list_for_chat_bloc.dart';
import 'package:desire_production/model/salesman_list_for_chat_model.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

import 'admin_chatting_page.dart';


class SalesmanListForChatPage extends StatefulWidget {
  const SalesmanListForChatPage({Key key}) : super(key: key);

  @override
  _SalesmanListForChatPageState createState() => _SalesmanListForChatPageState();
}

class _SalesmanListForChatPageState extends State<SalesmanListForChatPage> {

  final SalesmanListForChatBloc salesmanListForChatBloc = SalesmanListForChatBloc();
  AsyncSnapshot<SalesmanListForChatModel> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    salesmanListForChatBloc.fetchSalesmanListForChat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    salesmanListForChatBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text("Salesman",style: TextStyle(
            color: Colors.black
        ),),
        centerTitle: true,
        backgroundColor: Colors.white,

      ),
      body: StreamBuilder<SalesmanListForChatModel>(
          stream: salesmanListForChatBloc.salesmanListForChatStream,
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
                    ...List.generate(asyncSnapshot.data.salesList.length, (index) => SalesListTile(
                      salesList: asyncSnapshot.data.salesList[index],


                    ))

                  ],
                ),
              );
            }

          }),
    );
  }
}
class SalesListTile extends StatelessWidget {

  final SalesList salesList;

  const SalesListTile({Key key, this.salesList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: (){

          Navigator.push(context, MaterialPageRoute(builder: (context){
            return AdminChattingPage(
              receiverId: salesList.userId,
              receiverName: salesList.firstname + salesList.lastname,
              type: "2",
              conversationId: "",
            );
          }));

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: kPrimaryColor,
                child: Text(salesList.userId.toString(),style: TextStyle(color: kWhite),)
            ),
            SizedBox(width: 10,),
            Text(salesList.firstname + salesList.lastname,style: TextStyle(color: kBlackColor,fontSize: 16,fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}