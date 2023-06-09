
import 'dart:io';
import 'dart:math';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:desire_production/bloc/product_list.dart';
import 'package:desire_production/model/product_model.dart';
import 'package:desire_production/pages/dashboards/dashboard_page_admin.dart';
import 'package:desire_production/services/connections.dart';
import 'package:desire_production/utils/alerts.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:desire_production/utils/drawer_admin.dart';
import 'package:desire_production/utils/progress_dialog.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';


class BrochurePage extends StatefulWidget {

  final String page;

  const BrochurePage({@required this.page});

  @override
  _BrochurePageState createState() => _BrochurePageState();
}

class _BrochurePageState extends State<BrochurePage> {

  final productBloc = ProductListBloc();

  List<bool> check = [];
  bool checkAll = false;
  List<Product> send = [];

  AsyncSnapshot<ProductModel> as;

  TextEditingController searchView;
  bool search = false;
  List<Product> _searchResult = [];
  List<Product> _order = [];

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    searchView = TextEditingController();
    productBloc.fetchProductList();
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
    searchView.dispose();
    productBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => DashboardPageAdmin()));
      },
      child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              // leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black,), onPressed: () {
              //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => SalesHomePage()));
              // },),
              title: Text("Product List", style: TextStyle(color: Colors.black), textAlign: TextAlign.center,),
              centerTitle: true,
              leading: Builder(
                builder: (c){
                  return IconButton(icon: Image.asset("assets/images/logo.png"), onPressed: (){
                    Scaffold.of(c).openDrawer();
                  },);
                },
              ),
              actions: [
                PopupMenuButton(
                    icon: Icon(Icons.settings_outlined, color: Colors.black,),
                    itemBuilder: (b) =>[
                      PopupMenuItem(
                          child: TextButton(
                            child: Text("Generate PDF", textAlign: TextAlign.center,),
                            onPressed: (){
                              print("object search result inside pdf ${_searchResult.length}");
                              Navigator.pop(context);
                              //generatePdfGrid();
                              print("object value of send ${send.length}");
                              //send.length == 0 || send.length == as.data.products.length ? generatePdf() : generateSendPdf();
                              send.length > 0 ? generateSendPdf() : generatePdf();
                            },
                          )
                      ),
                      PopupMenuItem(
                          child: TextButton(
                            child: Text("Log Out", textAlign: TextAlign.center,),
                            onPressed: (){
                              Alerts.showLogOut(context, "Log Out", "Are you sure?");
                            },
                          )
                      ),
                    ]
                )
              ],
            ),
            drawer: DrawerAdmin(),
            body: _body(),
          )),
    );
  }

  Widget _body(){
    return RefreshIndicator(
      onRefresh:(){
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => BrochurePage(page: widget.page,)), (route) => false);
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        physics: AlwaysScrollableScrollPhysics(),
        child: StreamBuilder<ProductModel>(
            stream: productBloc.productStream,
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
              if (s.data.product.length == 0) {
                print("as3 empty");
                return Container(height: 300,
                  alignment: Alignment.center,
                  child: Text("No Details Found",),);
              }

              as=s;
              _order = s.data.product;

              for(int i=0; i<s.data.product.length; i++){
                check.add(false);
              }

              print("object length ${s.data.product.length} ${check.length}");


              return Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _searchView(),
                    _searchResult.length == 0 ? Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFA53E),
                                    border: Border(left: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                  ),
                                  child: Text('', //style: content1,
                                    textAlign: TextAlign.center,),
                                  //alignment: Alignment.center,
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFA53E),
                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                      ),
                                      child: Text('Product Name', //style: content1,
                                        textAlign: TextAlign.center,),
                                      alignment: Alignment.center,
                                    )
                                ),
                                Container(
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFA53E),
                                    border: Border(top: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                  ),
                                  child: Checkbox(
                                    value: checkAll,
                                    checkColor: Colors.white,
                                    onChanged: (value) {
                                      setState(() {
                                        checkAll = value;
                                      });
                                      print("object remember $checkAll");
                                      if(checkAll == true){
                                        for(int i=0; i<s.data.product.length; i++){
                                          check[i] = true;
                                          send.add(s.data.product[i]);
                                        }
                                      } else{
                                        for(int i=0; i<s.data.product.length; i++){
                                          check[i] = false;
                                          send = [];
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          for(int i=0; i<s.data.product.length;i++)
                            s.data.product.length == 0 ? Container(height: 300,
                              alignment: Alignment.center,
                              child: Text("No Orders Found",),) : AnimationConfiguration.staggeredList(
                              position: i,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Container(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            //color: bg,
                                            border: Border(left: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                          ),
                                          child: Text('${i+1}', //style: content1,
                                            textAlign: TextAlign.center,),
                                          //alignment: Alignment.center,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('${s.data.product[i].productName}', //style: content1,
                                                textAlign: TextAlign.center,),
                                              alignment: Alignment.center,
                                            )
                                        ),
                                        Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            //color: bg,
                                            border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                          ),
                                          child: Checkbox(
                                            value: check[i],
                                            activeColor: kPrimaryColor,
                                            onChanged: (value) {
                                              setState(() {
                                                check[i] = value;
                                              });
                                              print("object remember ${check[i]}");
                                              if(check[i] == true){
                                                send.add(s.data.product[i]);
                                              } else{
                                                send.remove(s.data.product[i].id);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ) :
                    Container(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            child: Row(
                              children: [
                                Container(
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFA53E),
                                    border: Border(left: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                  ),
                                  child: Text('', //style: content1,
                                    textAlign: TextAlign.center,),
                                  //alignment: Alignment.center,
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFFA53E),
                                        border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black),top: BorderSide(color: Colors.black)),
                                      ),
                                      child: Text('Product Name', //style: content1,
                                        textAlign: TextAlign.center,),
                                      alignment: Alignment.center,
                                    )
                                ),
                                Container(
                                  width: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFA53E),
                                    border: Border(top: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                  ),
                                  child: Checkbox(
                                    value: checkAll,
                                    checkColor: Colors.white,
                                    onChanged: (value) {
                                      setState(() {
                                        checkAll = value;
                                      });
                                      print("object remember $checkAll");
                                      if(checkAll == true){
                                        for(int i=0; i<_searchResult.length; i++){
                                          check[i] = true;
                                          send.add(_searchResult[i]);
                                        }
                                      } else{
                                        for(int i=0; i<_searchResult.length; i++){
                                          check[i] = false;
                                          send = [];
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          for(int i=0; i<_searchResult.length;i++)
                            AnimationConfiguration.staggeredList(
                              position: i,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: Container(
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            //color: bg,
                                            border: Border(left: BorderSide(color: Colors.black),right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                          ),
                                          child: Text('${i+1}', //style: content1,
                                            textAlign: TextAlign.center,),
                                          //alignment: Alignment.center,
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                              ),
                                              child: Text('${_searchResult[i].productName}', //style: content1,
                                                textAlign: TextAlign.center,),
                                              alignment: Alignment.center,
                                            )
                                        ),
                                        Container(
                                          width: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            //color: bg,
                                            border: Border(right: BorderSide(color: Colors.black),bottom: BorderSide(color: Colors.black)),
                                          ),
                                          child: Checkbox(
                                            value: check[i],
                                            activeColor: kPrimaryColor,
                                            onChanged: (value) {
                                              setState(() {
                                                check[i] = value;
                                              });
                                              print("object remember ${check[i]}");
                                              if(check[i] == true){
                                                send.add(_searchResult[i]);
                                              } else{
                                                send.remove(_searchResult[i].id);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
        ),
      ),
    );
  }

  Widget _searchView() {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.black,),
          SizedBox(width: 8,),
          Expanded(
            child: TextField(
              controller: searchView,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.left,
              onChanged: (value){
                setState(() {
                  search = true;
                  onSearchTextChangedICD(value);
                });
              },
              decoration: new InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
              ),
            ),
          ),
        ],
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

    _order.forEach((exp) {
      if (exp.productName.contains(text))
        _searchResult.add(exp);
    });
    //print("search objects ${_searchResult.first}");
    print("search result length ${_searchResult.length}");
    setState(() {});
  }

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.post(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
  }

  final document = pw.Document();

  generatePdf() async{
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Downloading Images. Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    final List<dynamic> imageN =[];
    //final http.Response responseData = await http.post(Uri.parse(Connection.image+"${as.data.products[0].image}"));
    final image = pw.MemoryImage((await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),);
    //final image1 = pw.MemoryImage(responseData.bodyBytes.buffer.asUint8List());
    for(int i=0; i<as.data.product.length;i++){
      File fileImage = await urlToFile(Connection.image + "${as.data.product[i].image[0]}");
      var img = File(fileImage.path);
      print("file details ${fileImage.path}");
      imageN.add(pw.MemoryImage(img.readAsBytesSync()));
    }
    document.addPage(
        pw.MultiPage(
          //margin: pw.EdgeInsets.all(20),
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          pageFormat: PdfPageFormat.a4,
          build: (context){
            return <pw.Widget>  [
              pw.Header(
                //level: 0,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Image(image,height: 100, width: 100, alignment: pw.Alignment.centerLeft),
                        pw.SizedBox(width: 20),
                        pw.Text("Product Brochure", textAlign: pw.TextAlign.center, style: pw.TextStyle(
                          fontSize: 40,
                          color: PdfColor.fromHex('#4684C2'),
                          fontWeight: pw.FontWeight.bold,
                        ))
                      ]
                  )
              ),
              //pw.Divider(color: PdfColor.fromHex('#4684C2'),thickness: 3),
              pw.GridView(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  children: [
                    for(int i=0; i<as.data.product.length; i++)
                      pw.Container(
                          margin: pw.EdgeInsets.only(top: 10),
                          alignment: pw.Alignment.centerLeft,
                          //height: 300,
                          child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Image(imageN[i],alignment: pw.Alignment.centerLeft,height: 100, width: 200),
                                pw.Text("Product Name: ${as.data.product[i].productName}",
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      fontSize: 15,
                                    )),
                                pw.Text("Model No.: ${as.data.product[i].modelNo}",
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      fontSize: 15,
                                    )),
                                pw.Text("Profile No: ${as.data.product[i].profileNo}",
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      fontSize: 15,
                                    )),
                                pw.Text("Dimensions: ${as.data.product[i].dimensionId} ${as.data.product[i].modelNo}",
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      fontSize: 15,
                                    )),
                              ]
                          )
                      ),
                  ]
              ),
            ];
          },
        )
    );
    String path;
    //pr.hide();
    if(await _reqPer(Permission.storage)){
      var dir = await getApplicationDocumentsDirectory();
      File file = File(dir.path + "/ProductBrochure.pdf");
      path = dir.path + "/ProductBrochure.pdf";
      print(path);
      file.writeAsBytes(List.from(await document.save()));
      print("path of file open $path");
      pr.hide();
      Alerts.showAlertPdf(context, 'Product Brochure', 'Pdf Generated', path);
    }
  }

  generateSendPdf() async{
    print("object send length ${send.length}");
    ProgressDialog pr = ProgressDialog(context, type: ProgressDialogType.Normal,
      isDismissible: false,);
    pr.style(message: 'Downloading Images. Please wait...',
      progressWidget: Center(child: CircularProgressIndicator()),);
    pr.show();
    final List<dynamic> imageN =[];
    //final http.Response responseData = await http.post(Uri.parse(Connection.image+"${as.data.products[0].image}"));
    final image = pw.MemoryImage((await rootBundle.load('assets/images/logo.png')).buffer.asUint8List(),);
    //final image1 = pw.MemoryImage(responseData.bodyBytes.buffer.asUint8List());
    for(int i=0; i<send.length;i++){
      File fileImage = await urlToFile(Connection.image + "${send[i].image[0]}");
      var img = File(fileImage.path);
      print("file details ${fileImage.path}");
      imageN.add(pw.MemoryImage(img.readAsBytesSync()));
    }
    document.addPage(
        pw.MultiPage(
          //margin: pw.EdgeInsets.all(20),
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          pageFormat: PdfPageFormat.a4,
          build: (context){
            return <pw.Widget>  [
              pw.Header(
                //level: 0,
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Image(image,height: 100, width: 100, alignment: pw.Alignment.centerLeft),
                        pw.SizedBox(width: 20),
                        pw.Text("Product Brochure", textAlign: pw.TextAlign.center, style: pw.TextStyle(
                          fontSize: 40,
                          color: PdfColor.fromHex('#4684C2'),
                          fontWeight: pw.FontWeight.bold,
                        ))
                      ]
                  )
              ),
              //pw.Divider(color: PdfColor.fromHex('#4684C2'),thickness: 3),
              pw.GridView(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  children: [
                    for(int i=0; i<send.length; i++)
                      pw.Container(
                          margin: pw.EdgeInsets.only(top: 10),
                          alignment: pw.Alignment.centerLeft,
                          //height: 300,
                          child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Image(imageN[i],alignment: pw.Alignment.centerLeft,height: 100, width: 200),
                                pw.Text("Product Name: ${send[i].productName}",
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      fontSize: 15,
                                    )),
                                pw.Text("Model No.: ${send[i].modelNo}",
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      fontSize: 15,
                                    )),
                                pw.Text("Profile No: ${send[i].profileNo}",
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      fontSize: 15,
                                    )),
                                pw.Text("Dimensions: ${send[i].dimensionId} ${send[i].modelNo}",
                                    textAlign: pw.TextAlign.left,
                                    style: pw.TextStyle(
                                      fontSize: 15,
                                    )),
                              ]
                          )
                      ),
                  ]
              ),
            ];
          },
        )
    );
    String path;
    //pr.hide();
    if(await _reqPer(Permission.storage)){
      var dir = await getApplicationDocumentsDirectory();
      File file = File(dir.path + "/ProductBrochure.pdf");
      path = dir.path + "/ProductBrochure.pdf";
      print(path);
      file.writeAsBytes(List.from(await document.save()));
      print("path of file open $path");
      pr.hide();
      Alerts.showAlertPdf(context, 'Product Brochure', 'Pdf Generated', path);
    }
  }

  Future<bool> _reqPer(Permission permission) async{
    if(await permission.isGranted){
      return true;
    } else{
      var res = await permission.request();
      // ignore: unrelated_type_equality_checks
      if(res == permission.isGranted){
        return true;
      }else{
        return false;
      }
    }
  }

}
