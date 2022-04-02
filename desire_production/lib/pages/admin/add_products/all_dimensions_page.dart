import 'dart:convert';

import 'package:desire_production/bloc/add_products_bloc.dart';
import 'package:desire_production/model/all_dimensions_model.dart';
import 'package:desire_production/pages/admin/add_products/edit_dimensions_page.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AllDimensionsPage extends StatefulWidget {
  @override
  _allDimensionsPageState createState() => _allDimensionsPageState();
}

class _allDimensionsPageState extends State<AllDimensionsPage> {
  AddProductsBloc addProductsBloc = AddProductsBloc();
  AsyncSnapshot<AllDimensionsModel> asyncSnapshot;
  List<AllDimension> _searchResult = [];
  List<AllDimension> allDimesion = [];
  TextEditingController searchView;
  bool search = false;

  @override
  void initState() {
    super.initState();
    searchView = TextEditingController();
    addProductsBloc.fetchAllDimensions();
  }

  @override
  void dispose() {
    super.dispose();
    addProductsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "All Dimensions",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(50), child: _searchView())),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return EditDimensionsPage();
            }));
          },
          label: Text(
            "Add Dimension",
          ),
          icon: Icon(Icons.add),
          backgroundColor: kPrimaryColor,
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return StreamBuilder<AllDimensionsModel>(
        stream: addProductsBloc.newAccessoryStream,
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
          } else if (s.data.data.isEmpty) {
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
            allDimesion = asyncSnapshot.data.data;
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.83,
                child: searchView.text.length == 0
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: allDimesion.length,
                        itemBuilder: (BuildContext context, int index) {
                          return AllDimensionsListTile(
                            addProductBloc: addProductsBloc,
                            imgPath: asyncSnapshot.data.imagePath,
                            allDimension: allDimesion[index],
                          );
                        })
                    : _searchResult.length == 0
                        ? Container(
                            alignment: Alignment.center,
                            child: Text(
                              "No Data Found",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800),
                            ))
                        : ListView.builder(
                            itemCount: _searchResult.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return AllDimensionsListTile(
                                addProductBloc: addProductsBloc,
                                imgPath: asyncSnapshot.data.imagePath,
                                allDimension: _searchResult[index],
                              );
                            }),
              ),
            );
          }
        });
  }

  Widget _searchView() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(border: Border.all(color: kSecondaryColor)),
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: TextFormField(
            controller: searchView,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.left,
            onChanged: (value) {
              setState(() {
                search = true;
                onSearchTextChangedICD(value);
              });
            },
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: "Search Dimension",
            ),
          ),
        ),
      ),
    );
  }

  onSearchTextChangedICD(String text) async {
    _searchResult.clear();
    print("$text value from search");
    if (text.isEmpty) {
      setState(() {
        search = false;
      });
      return;
    }

    allDimesion.forEach((exp) {
      if (exp.size.contains(text)) {
        _searchResult.add(exp);
      }
    });

    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }
}

class AllDimensionsListTile extends StatelessWidget {
  final AllDimension allDimension;
  final String imgPath;
  final AddProductsBloc addProductBloc;

  const AllDimensionsListTile(
      {Key key, this.allDimension, this.imgPath, this.addProductBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return EditDimensionsPage(
                dimensionId: allDimension.dimensionsId,
                dmSize: allDimension.size,
                image: imgPath + allDimension.image,
              );
            })).then((val) => val ? _fetchList() : null);
          },
          child: Card(
            elevation: 5,
            margin: EdgeInsets.zero,
            child: Container(
              height: 80,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: kPrimaryColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: "assets/images/dimensions.png",
                    image: imgPath + allDimension.image,
                    width: 50,
                    height: 50,
                  ),
                  Flexible(
                    child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: "Size : ",
                                style:
                                    TextStyle(color: kBlackColor, fontSize: 15),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: allDimension.size,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                            RichText(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                text: "Size in inch : ",
                                style:
                                    TextStyle(color: kBlackColor, fontSize: 15),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: allDimension.sizeInch,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                  IconButton(
                      onPressed: () {
                        deleteItem(
                            allDimension.dimensionsId, context, addProductBloc);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ],
              ),
            ),
          ),
        ));
  }

  deleteItem(String dimensionId, BuildContext context,
      AddProductsBloc addProductBloc) async {
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    pr.style(
      message: 'Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),
    );
    pr.show();
    var response;
    response = await http.post(
        Uri.parse(
            "http://loccon.in/desiremoulding/api/AdminApiController/deleteDimension"),
        body: {
          'secretkey': Connection.secretKey,
          'dimensions_id': dimensionId,
        });
    var results = json.decode(response.body);
    print('response == $results  ${response.body}');
    pr.hide();
    if (results['status'] == true) {
      Alerts.showAlertAndBack(context, "User Not Found", results['message']);
      addProductBloc.fetchAllDimensions();
    } else {
      Alerts.showAlertAndBack(context, "User Not Found", results['message']);
    }
  }

  _fetchList() {
    addProductBloc.fetchAllDimensions();
  }
}
