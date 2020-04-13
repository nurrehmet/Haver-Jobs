import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';

class MapsView extends StatefulWidget {
  const MapsView({Key key, this.keahlian, this.gender, this.pendidikan,this.lat,this.long})
      : super(key: key);
  final String keahlian, gender, pendidikan;
  final double lat,long;
  @override
  State<MapsView> createState() => MapsViewState();
}

class MapsViewState extends State<MapsView> {
  // init geofluterfire
  Firestore _firestore = Firestore.instance;
  Geoflutterfire geo;
  Stream<List<DocumentSnapshot>> stream;
  var radius = BehaviorSubject<double>.seeded(1.0);
  GoogleMapController _mapController;
  // init app
  final Firestore _database = Firestore.instance;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  SolidController _bsController = SolidController();
  double lat, long;
  CameraPosition _myLocation;
  Completer<GoogleMapController> _controller = Completer();
  Widget _mapPlaceholder;
  var _initLocation =
      CameraPosition(target: LatLng(-6.921948, 107.607168), zoom: 15);
  double _value = 20.0;
  String _label = '';
  @override
  void initState() {
    super.initState();
    initData();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    super.dispose();
    radius.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cari Karyawan',
          style: TextStyle(fontFamily: 'Product Sans'),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          mapWidget(),
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
                        heroTag: "btn1",
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
                        heroTag: "btn2",
                        tooltip: 'Lokasi Sekarang',
                        backgroundColor: Hexcolor('#3f72af'),
                        child: Icon(Icons.location_searching),
                        onPressed: () => _currentLocation()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Slider(
                    min: 1,
                    max: 200,
                    divisions: 4,
                    value: _value,
                    label: _label,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.blue.withOpacity(0.2),
                    onChanged: (double value) => changed(value),
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
                  padding: const EdgeInsets.all(2.0),
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

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
//      _showHome();
      //start listening after map is created
      stream.listen((List<DocumentSnapshot> documentList) {
        _updateMarkers(documentList);
      });
    });
  }

  void _addMarker(double lat, double lng) {
    MarkerId id = MarkerId(lat.toString() + lng.toString());
    Marker _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(title: 'latLng', snippet: '$lat,$lng'),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint point = document.data['position']['geopoint'];
      _addMarker(point.latitude, point.longitude);
    });
  }

  changed(value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} kms';
      markers.clear();
    });
    radius.add(value);
  }

  Future<void> _currentLocation() async {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(_myLocation));
  }

  Widget mapWidget() {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      // circles: circles,
      markers: Set<Marker>.of(markers.values),
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(target: LatLng(widget.lat, widget.long), zoom: 15),
      onMapCreated: _onMapCreated,
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

  initData() {
    geo = Geoflutterfire();
    GeoFirePoint center =
        geo.point(latitude: widget.lat, longitude: widget.long);
    stream = radius.switchMap((rad) {
      var collectionReference = _firestore.collection('locations');
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'position', strictMode: true);
    });
  }
}
