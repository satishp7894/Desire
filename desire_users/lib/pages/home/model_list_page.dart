import 'package:desire_users/bloc/all_model_bloc.dart';
import 'package:desire_users/models/allModel.dart';
import 'package:desire_users/pages/product/productFromModelPage.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';

class ModelListPage extends StatefulWidget {

  final customerId, customerName;
  const ModelListPage({Key key,this.customerId,this.customerName}) : super(key: key);

  @override
  _ModelListPageState createState() => _ModelListPageState();
}

class _ModelListPageState extends State<ModelListPage> {

   final AllModelBloc allModelBloc = AllModelBloc();


   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allModelBloc.fetchAllModel(widget.customerId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    allModelBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        iconTheme: IconThemeData(
          color: kBlackColor
        ),
        title: Text("All Models",style: TextStyle(color: kBlackColor),),
      ),
      body: allModelView(),
    );
  }


  Widget allModelView(){
    return StreamBuilder<AllModel>(
        stream: allModelBloc.allModelStream,
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
          else if (s.data.toString().isEmpty) {
            print("as3 empty");
            return Container(height: 300,
              alignment: Alignment.center,
              child: Text("No Data Found",),);
          }
          else {
            return GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio:4/5

                ),
                itemCount: s.data.data.length,
                itemBuilder: (c,i){
                  return  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductFromModelPage(
                          customerId:widget.customerId ,
                          modelNo:s.data.data[i].modelNo ,
                          modelNoId: s.data.data[i].modelNoId,
                          customerName: widget.customerName,
                        )));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [BoxShadow(
                                color: Colors.grey,
                                blurRadius: 10.0,
                              ),],
                              color: kWhiteColor
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10,),
                              Image.network("${s.data.imagepath}"+s.data.data[i].image,height: 80,width: 80,),
                              SizedBox(height: 10,),
                              Expanded(child: Text("Model No :" + s.data.data[i].modelNo,style: TextStyle(fontWeight: FontWeight.bold,color: kPrimaryColor,fontSize: 12),))
                            ],
                          )),
                    ),
                  );

                });
          }

        }
    );


  }
}
