import 'package:desire_production/bloc/modelWiseListBloc.dart';
import 'package:desire_production/model/modelNoWiseListModel.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';

class DailyOrdersListByModelNumber extends StatefulWidget {

  final modelNo;
  final modelNoId;
  final status;
  const DailyOrdersListByModelNumber({Key key,this.modelNo,this.modelNoId,this.status}) : super(key: key);

  @override
  _DailyOrdersListByModelNumberState createState() => _DailyOrdersListByModelNumberState();
}

class _DailyOrdersListByModelNumberState extends State<DailyOrdersListByModelNumber> {

  final ModelWiseListBloc modelWiseListBloc = ModelWiseListBloc();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modelWiseListBloc.fetchModelWiseDailyOrderList(widget.modelNoId.toString());

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    modelWiseListBloc.dispose();
  }


  AsyncSnapshot<ModelNoWiseListModel> asyncSnapshot;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: Text("Model No - "+widget.modelNo,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: StreamBuilder<ModelNoWiseListModel>(
       stream: modelWiseListBloc.modelWiseDailyOrdersListStream,
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
          if (s.hasError) {
            print("as3 error");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("Error Loading Data",),);
          }
          if (s.data.data == null) {
            print("as3 empty");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("No Orders Found",),);
          } else
          asyncSnapshot = s;
          return asyncSnapshot.data.data.isEmpty ? Center(
            child: Text("No Production List of ${widget.modelNo} Model No."),
          ) : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                  ...List.generate(asyncSnapshot.data.data.length, (index) => ModelWiseListTile(data: asyncSnapshot.data.data[index],))
              ],
            ),
          );

        },
      ),
    );
  }
}


class ModelWiseListTile extends StatelessWidget {
final  Data data;
  const ModelWiseListTile({Key key,this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10,bottom: 5,top: 5),
      child: Card(
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 10,bottom: 10,top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Customer Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black),),
                  SizedBox(height: 10,),
                  Text("Product Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black),),
                  SizedBox(height: 10,),
                  Text("Quantity",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black),),
                  SizedBox(height: 10,),
                  Text("Stick per Box",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black),),
                ],
              ),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(":-"),
                  SizedBox(height: 10,),
                  Text(":-"),
                  SizedBox(height: 10,),
                  Text(":-"),
                  SizedBox(height: 10,),
                  Text(":-"),
                ],
              ),
              SizedBox(width: 10,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.customerName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black),),
                  SizedBox(height: 10,),
                  Text(data.productName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black),),
                  SizedBox(height: 10,),
                  Text(data.productQuantity,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black),),
                  SizedBox(height: 10,),
                  Text(data.perBoxStick,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.black),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

