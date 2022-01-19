import 'package:desire_production/bloc/ProductFromModelBloc.dart';
import 'package:desire_production/model/ProductFromModelNoModel.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ProductFromModelPage extends StatefulWidget {
  final customerId;
  final customerName;
  final modelNoId;
  final modelNo;
  final type;

  const ProductFromModelPage(
      {Key key,
      this.customerId,
      this.modelNoId,
      this.modelNo,
      this.customerName,
      this.type})
      : super(key: key);

  @override
  _ProductFromModelPageState createState() => _ProductFromModelPageState();
}

class _ProductFromModelPageState extends State<ProductFromModelPage> {
  final productFromModelBloc = ProductFromModelBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productFromModelBloc.fetchProductFromModel(
        widget.modelNoId, widget.customerId);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    productFromModelBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: kBlackColor),
        title: Text(
          "Model No. " + widget.modelNo,
          style: TextStyle(color: kBlackColor),
        ),
        backgroundColor: kWhite,
        centerTitle: true,
      ),
      body: view(),
    );
  }

  Widget view() {
    return StreamBuilder<ProductFromModelNoModel>(
        stream: productFromModelBloc.productFromModelStream,
        builder: (c, s) {
          if (s.connectionState != ConnectionState.active) {
            print("all connection ${s.connectionState}");
            return Container(
                height: 300,
                alignment: Alignment.center,
                child: Center(
                  heightFactor: 50,
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ));
          }
          print("object of s ${s.connectionState}");
          if (s.hasError) {
            print("as3 error");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "Error Loading Data",
              ),
            );
          }
          if (s.data.toString().isEmpty) {
            print("as3 empty");
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: Text(
                "No Data Found",
              ),
            );
          }
          return s.data.status == false
              ? Center(child: Text("No Products"))
              : StaggeredGridView.countBuilder(
                  padding: EdgeInsets.all(15),
                  physics: BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  itemCount: s.data.data.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    onTap: () {
                      widget.type == "sales"
                          ? {}
                          : {};
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                "${s.data.imagepath}${s.data.data[index].image[0]}",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          s.data.data[index].productName.toUpperCase(),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "MRP: " "₹${s.data.data[index].customerprice}",
                              style: TextStyle(
                                decoration:
                                    s.data.data[index].customernewprice == ""
                                        ? TextDecoration.none
                                        : TextDecoration.lineThrough,
                                fontSize:
                                    s.data.data[index].customernewprice == ""
                                        ? 14
                                        : 12,
                                fontWeight: FontWeight.w600,
                                color: s.data.data[index].customernewprice == ""
                                    ? kPrimaryColor
                                    : kSecondaryColor,
                              ),
                            ),
                            Text(
                              s.data.data[index].customernewprice == ""
                                  ? ""
                                  : "Your Price " +
                                      "₹${s.data.data[index].customernewprice}",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                );
        });
  }
}
