import 'package:desire_users/models/modelList_model.dart';
import 'package:desire_users/pages/product/productFromModelPage.dart';
import 'package:desire_users/sales/bloc/model_list_bloc.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomerPriceList extends StatefulWidget {
  final customerId;
  const CustomerPriceList({Key key, this.customerId}) : super(key: key);

  @override
  _CustomerPriceListState createState() => _CustomerPriceListState();
}

class _CustomerPriceListState extends State<CustomerPriceList> {

  final ModelListBloc modelListBloc = ModelListBloc();
  AsyncSnapshot<ModelListModel> asyncSnapshot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modelListBloc.fetchModelList(widget.customerId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    modelListBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0.0,
        iconTheme: IconThemeData(color: kBlackColor),
        centerTitle: true,
        title: Text("Model Price List"),
        titleTextStyle: TextStyle(color: kBlackColor,fontSize: 18.0),
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return StreamBuilder<ModelListModel>(
        stream: modelListBloc.modelListStream,
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
             Padding(
               padding: const EdgeInsets.only(left: 10.0,right: 10,top: 10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Expanded(
                     flex: 1,
                     child: Container(
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.zero,
                             border: Border.all(color: kBlackColor,width: 0.5)
                         ),
                         child: Padding(
                           padding: const EdgeInsets.all(10.0),
                           child: Text("Model No",textAlign: TextAlign.center,style: TextStyle(color: kPrimaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                         )),
                   ),
                   Expanded(
                     flex: 1,
                     child: Container(
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.zero,
                             border: Border.all(color: kBlackColor,width: 0.5)
                         ),
                         child: Padding(
                           padding: const EdgeInsets.all(10.0),
                           child: Text("Customer Price",textAlign: TextAlign.center,style: TextStyle(color: kPrimaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                         )),
                   ),
                   Expanded(
                     flex: 1,
                     child: Container(
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.zero,
                             border: Border.all(color: kBlackColor,width: 0.5)
                         ),
                         child: Padding(
                           padding: const EdgeInsets.all(10.0),
                           child: Text("View Products",textAlign: TextAlign.center,style: TextStyle(color: kPrimaryColor,fontSize: 14,fontWeight: FontWeight.bold),),
                         )),
                   ),
                 ],
               ),
             ),
             ...List.generate(asyncSnapshot.data.modelList.length, (index) => ModelListTile(
               modelList: asyncSnapshot.data.modelList[index],
               customerId: widget.customerId,
             ))
           ],
         ),
       );
      }

    });
  }
}

class ModelListTile extends StatelessWidget {

 final  ModelList modelList;

  const ModelListTile({Key key,this.modelList, this.customerId}) : super(key: key);

  final customerId;

  @override
  Widget build(BuildContext context) {
    return    Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: kBlackColor,width: 0.5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(modelList.modelNo,textAlign: TextAlign.center,style: TextStyle(color: kBlackColor,fontSize: 14,fontWeight: FontWeight.bold),),
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: kBlackColor,width: 0.5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(modelList.customerPrice,textAlign: TextAlign.center,style: TextStyle(color: kBlackColor,fontSize: 14,fontWeight: FontWeight.bold),),
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: kBlackColor,width: 0.5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ProductFromModelPage(customerId: customerId,modelNoId: modelList.modelNoId,modelNo: modelList.modelNo  ,);
                      }));
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(20)
                        ),
                        child: Text(
                          "View Products",textAlign: TextAlign.center,style: TextStyle(color: kWhiteColor,fontSize: 14,fontWeight: FontWeight.bold),)),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

