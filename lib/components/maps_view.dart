import 'dart:async';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

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

  CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(-6.932694, 107.627449),
    zoom: 14.4746,
  );

  @override
  void initState() {
    _getCurrentLocation();
    createMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: Set<Marker>.of(markers.values),
            mapType: MapType.normal,
            initialCameraPosition:
                _myLocation == null ? _defaultLocation : _myLocation,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Padding(padding: const EdgeInsets.all(16.0), child: Container()),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                    child: Icon(Icons.location_searching),
                    onPressed: () => _currentLocation()),
              ),
            ),
          )
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SolidBottomSheet(
          controller: _bsController,
          draggableBody: true,
          headerBar: Container(
            height: 50,
            child: Icon(
              Icons.maximize,
              size: 50,
              color: Colors.grey,
            ),
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

 Future<void>  createMarker() async {
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
    }).catchError((e){
      print(e);
    },);
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
      print(markerId);
    });
  }

  Future<void> _currentLocation() async {
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myLocation));
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;
        _myLocation = CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(lat, long),
            tilt: 59.440717697143555,
            zoom: 15);
      });
      print(lat);
    }).catchError((e) {
      print(e);
    });
  }
}
