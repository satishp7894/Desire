import 'dart:async';
import 'dart:ffi';

import 'package:desire_production/bloc/sales_current_location_bloc.dart';
import 'package:desire_production/model/sales_location_model.dart';
import 'package:desire_production/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class SalesLocationScreen extends StatefulWidget {
  final salesId;

  const SalesLocationScreen({@required this.salesId});

  @override
  _SalesLocationScreenState createState() => _SalesLocationScreenState();
}

class _SalesLocationScreenState extends State<SalesLocationScreen> {
  SalesCurrentLocationBloc locationBloc = SalesCurrentLocationBloc();
  List<SalesmanLocation> salesmanList = [];
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> markers = new Set(); //markers for google map
  static const LatLng showLocation = const LatLng(27.7089427, 85.3086209);

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationBloc.fetchLocation(widget.salesId);
    Timer.periodic(Duration(minutes: 5),
        (Timer t) => locationBloc.fetchLocation(widget.salesId));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    locationBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Salesman Location",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return RefreshIndicator(
      color: kPrimaryColor,
      onRefresh: () {
        return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (builder) =>
                    SalesLocationScreen(salesId: widget.salesId)));
      },
      child: StreamBuilder<SalesLocationModel>(
          stream: locationBloc.locationStream,
          builder: (context, s) {
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
            }
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

            salesmanList = s.data.salesmanLocation;

            return Stack(
              alignment: Alignment.topRight,
              children: [
                GoogleMap(
                  markers: getmarkers(salesmanList[0]),
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse(salesmanList[0].latitude),
                          double.parse(salesmanList[0].longitude)),
                      zoom: 14.4746),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      formatDate(salesmanList[0].locationDatetime),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ))
              ],
            );
          }),
    );
  }

  Set<Marker> getmarkers(SalesmanLocation salesmanList) {
    //markers to place on map
    markers.add(Marker(
      //add first marker
      markerId: MarkerId(showLocation.toString()),
      position: LatLng(double.parse(salesmanList.latitude),
          double.parse(salesmanList.longitude)), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Marker Title First ',
        snippet: 'My Custom Subtitle',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
    //add more markers here
    return markers;
  }

  String formatDate(String locationDatetime) {
    var parse = DateTime.parse(locationDatetime);
    String formattedDate = DateFormat('dd-MM-yyyy – kk:mm').format(parse);
    return formattedDate;
  }
}
