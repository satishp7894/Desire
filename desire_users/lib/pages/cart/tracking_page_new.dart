import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_users/bloc/order_tracking_bloc.dart';
import 'package:desire_users/models/order_track_model.dart';
import 'package:desire_users/models/product_list_order_model.dart';
import 'package:desire_users/pages/intro/kyc_pagen.dart';
import 'package:desire_users/utils/alerts.dart';
import 'package:desire_users/utils/constants.dart';
import 'package:flutter/material.dart';


class TrackingPageNew extends StatefulWidget {

  final String id;
  final String orderId;
  final String orderName;
  final bool status;
  final String totalAmount;
  final String totalQty;
  final int orderCount;
  final String trackId;
  final Product product;

  const TrackingPageNew({@required this.id, @required this.orderId, @required this.orderName, @required this.status, @required this.totalAmount, @required this.totalQty, @required this.orderCount, @required this.product, @required this.trackId});

  @override
  _TrackingPageNewState createState() => _TrackingPageNewState();
}

class _TrackingPageNewState extends State<TrackingPageNew> {

  final bloc = OrderTrackingBloc();

  double _height;
  double _width;
  double _pixelRatio;
  bool _large;
  bool _medium;

  @override
  void initState() {
    super.initState();
    print("object product name ${widget.product.productName} ${widget.orderId} ${widget.trackId}");
    checkConnectivity();
    if(widget.trackId != null){
      bloc.fetchOrderTrack(widget.orderId,widget.trackId);
    }
  }

  checkConnectivity() async{
    bool result = await DataConnectionChecker().hasConnection;
    if(result == true) {
      print('YAY! Free cute dog pics!');
    } else {
      print('No internet :( Reason:');
      print(DataConnectionChecker().lastTryResults);
      Alerts.showAlertAndBack(context, "No Internet Connection", "Please check your internet");
    }
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: _body(),
        ));
  }

  Widget _body(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
         children: [
           clipShape(),
           Padding(
             padding: const EdgeInsets.only(top: 5, bottom: 5),
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: (){
                   Navigator.of(context).pop();
                 }),
                 Text("${widget.orderName}",style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
               ],
             ),
           )
         ],
        ),
        widget.trackId == null ?
        Padding(
          padding: const EdgeInsets.all(20),
          child: Center(child: Text("Your Order is under processing please wait for confirmation.", textAlign: TextAlign.center,)),
        ) :
        StreamBuilder<OrderTrackModel>(
            stream: bloc.newOrderTrackStream,
            builder: (c, s) {
              if (s.connectionState != ConnectionState.active) {
                print("all connection");
                return Container(height: 300,
                    alignment: Alignment.center,
                    child: Center(
                      heightFactor: 50, child: CircularProgressIndicator(),));
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
                  child: Text("No Products Found",),);
              }
              print("object length ${s.data.data.length}");

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 10),
                    child: Text("Product Number: ${widget.product.productName}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),),
                  ),
                  RefreshIndicator(
                    onRefresh: (){
                      return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => TrackingPageNew(id: widget.id, orderId: widget.orderId, orderName: widget.orderName, status: true, totalQty: widget.totalAmount, totalAmount: widget.totalQty,orderCount: widget.orderCount, trackId: widget.trackId, product: widget.product,)), (route) => false);
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 20),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: s.data.data.length,
                      itemBuilder: (c, i) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("${s.data.data[i].trackTime.replaceRange(10, 11, "\n")}"),
                            Column(
                              children: [
                                SizedBox(height: 15,),
                                Icon(Icons.check_circle, color: Colors.green,size: 30,),
                                i == s.data.data.length - 1 ? Container() : Container(height: 60,color: Colors.green,width: 4,alignment: Alignment.centerLeft,),
                              ],
                            ),
                            SizedBox(width: 10,),
                            Expanded(flex: 2,child: Text("${s.data.data[i].message}"))
                          ],);
                      },),
                  ),
                ],
              );
            }
        ),
      ],
    );
  }

  Widget clipShape() {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    _large =  ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    _medium =  ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.75,
          child: ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: _large? _height/8 : (_medium? _height/7 : _height/6.5),
              decoration: BoxDecoration(
                gradient: kPrimaryGradientColor,
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: CustomShapeClipper2(),
            child: Container(
              height: _large? _height/12 : (_medium? _height/11 : _height/10),
              decoration: BoxDecoration(
                gradient: kPrimaryGradientColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

}
