import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class MapsView extends StatefulWidget {
  @override
  State<MapsView> createState() => MapsViewState();
}

class MapsViewState extends State<MapsView> {
  final Firestore _database = Firestore.instance;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  SolidController _bsController = SolidController();
  double lat, long;
  CameraPosition _myLocation;
  Completer<GoogleMapController> _controller = Completer();
  Widget _mapPlaceholder;
  

  @override
  void initState() {
    _mapPlaceholder = Center(child: CircularProgressIndicator());
    _getCurrentLocation();
    createMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _mapPlaceholder,
          Padding(padding: const EdgeInsets.all(16.0), child: Container()),
          SafeArea(
            child: Column(
              children: <Widget>[
                Spacer(),
                Spacer(),
                Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                        tooltip: 'Filter Karyawan',
                        backgroundColor: Hexcolor('#3f72af'),
                        child: Icon(Icons.filter_list),
                        onPressed: () => null),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                        tooltip: 'Lokasi Sekarang',
                        backgroundColor: Hexcolor('#3f72af'),
                        child: Icon(Icons.location_searching),
                        onPressed: () => _currentLocation()),
                  ),
                ),
                Spacer()
              ],
            ),
          )
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SolidBottomSheet(
          controller: _bsController,
          draggableBody: true,
          headerBar: Column(
            children: <Widget>[
              Container(
                height: 50,
                child: Icon(
                  Icons.maximize,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    'Daftar Karyawan Terdekat',
                    style: TextStyle(fontFamily: 'Product Sans', fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              )
            ],
          ),
          body: Container(
            height: 30,
            child: Center(
              child: FloatingActionButton.extended(
                onPressed: () {},
                label: Text('Cari Karyawan'),
                icon: Icon(Icons.person_pin),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> createMarker() async {
    await _database
        .collection("users")
        .where("role", isEqualTo: "employee")
        .getDocuments()
        .then((docs) {
      if (docs.documents.isNotEmpty) {
        for (int i = 0; i < docs.documents.length; i++) {
          initMarker(docs.documents[i].data, docs.documents[i].documentID);
        }
      }
    }).catchError(
      (e) {
        print(e);
      },
    );
  }

  void initMarker(user, userid) {
    var markerIdVal = userid;
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(user['latitude'], user['longitude']),
      infoWindow: InfoWindow(title: user['nama'], snippet: user['noHp']),
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
      _mapPlaceholder = mapWidget();
      print(markerId);
    });
  }

  Future<void> _currentLocation() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myLocation));
  }

  Widget mapWidget() {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      // circles: circles,
      markers: Set<Marker>.of(markers.values),
      mapType: MapType.normal,
      initialCameraPosition: _myLocation,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;
        _myLocation = CameraPosition(target: LatLng(lat, long), zoom: 15);
      });
      print(lat);
    }).catchError((e) {
      print(e);
    });
  }
}
