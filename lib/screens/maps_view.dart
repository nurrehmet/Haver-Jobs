import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haverjob/components/details_account.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/screens/employee_seeker/find_employee_screen.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:haverjob/utils/global.dart';
import 'package:haverjob/utils/map_styles.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:ui' as ui;

//change marker
Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
      .buffer
      .asUint8List();
}

class MapsView extends StatefulWidget {
  const MapsView(
      {Key key,
      this.keahlian,
      this.gender,
      this.pendidikan,
      this.lat,
      this.long,
      this.listQuery,
      this.kota,
      this.jamKerja,
      this.type})
      : super(key: key);
  final String keahlian, gender, pendidikan, kota, jamKerja, type;
  final List listQuery;
  final double lat, long;

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
  double lat, long;
  double _value = 1;
  // detail employee
  String _label = '';
  List namaWindow = [];
  List keahlianWindow = [];
  double jarak;
  // marker icon
  BitmapDescriptor markerIcon;
  Set<Circle> circles;
  double _nilaiRadius;
  int countMarkers = 0;
  @override
  void initState() {
    super.initState();
    print(widget.listQuery);
    _nilaiRadius = 1000;
    initData();
  }

  @override
  void dispose() {
    super.dispose();
    radius.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.type == 'worker'
          ? AppBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Hasil Pencarian',
                  style: TextStyle(
                      color: mainColor, fontWeight: bold, fontSize: 22),
                ),
              ),
              iconTheme: IconThemeData(
                color: secColor, //change your color here
              ),
              elevation: 0,
              backgroundColor: Colors.white,
            )
          : null,
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
                    child: Visibility(
                      visible: widget.type == 'filter' ? true : false,
                      child: FloatingActionButton(
                          elevation: 0,
                          heroTag: "btn1",
                          tooltip: 'Filter Karyawan',
                          backgroundColor: mainColor,
                          child: Icon(Icons.tune),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FindEmployeeScreen()))),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                        elevation: 0,
                        heroTag: "btn2",
                        tooltip: 'Lokasi Sekarang',
                        backgroundColor: secColor,
                        child: Icon(Icons.near_me, color: Colors.white),
                        onPressed: () => _currentLocation()),
                  ),
                ),
                Container(
                  color: mainColor.withOpacity(0.2),
                  child: Slider(
                    min: 1,
                    max: 15,
                    divisions: 5,
                    value: _value,
                    label: _label,
                    activeColor: mainColor,
                    inactiveColor: secColor.withOpacity(0.2),
                    onChanged: (double value) => changed(value),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    // controller.setMapStyle(MapStyles.mapStyles);
    setState(() {
      _mapController = controller;
//      _showHome();
      //start listening after map is created
      stream.listen((List<DocumentSnapshot> documentList) {
        _updateMarkers(documentList);
      });
    });
  }

  Future<void> _addMarker(
      double lat, double lng, String nama, userid, keahlian) async {
    var point = geo.point(latitude: widget.lat, longitude: widget.long);
    var distance = point.distance(lat: lat, lng: lng);
    MarkerId id = MarkerId(lat.toString() + lng.toString());
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/marker.png', 150);
    Marker _marker = Marker(
      markerId: id,
      // onTap: _showModal,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.fromBytes(markerIcon),
      infoWindow: InfoWindow(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AkunDetail(
                  userID: userid,
                  nama: nama,
                  jarak: distance.toString(),
                ),
              )),
          title: nama,
          snippet: widget.type == 'filter'
              ? 'Jarak ' + distance.toString() + ' KM'
              : 'Keahlian: ' + keahlian),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void _updateMarkers(List<DocumentSnapshot> documentList) {
    documentList.forEach((DocumentSnapshot document) {
      GeoPoint point = document.data['position']['geopoint'];
      _addMarker(
        point.latitude,
        point.longitude,
        document.data['nama'],
        document.documentID,
        document.data['keahlian'],
      );
    });
  }

  changed(value) {
    setState(() {
      _value = value;
      _nilaiRadius = value * 1000;
      _label = '${_value.toInt().toString()} KM';
      circles = Set.from([
        Circle(
          strokeWidth: 2,
          fillColor: secColor.withOpacity(0.2),
          strokeColor: secColor,
          circleId: CircleId('circle'),
          center: LatLng(widget.lat, widget.long),
          radius: _nilaiRadius,
        )
      ]);
      // print(value);
      markers.clear();
    });
    radius.add(value);
  }

  Future<void> _currentLocation() async {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(widget.lat, widget.long), zoom: 15)));
  }

  Widget mapWidget() {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      circles: circles,
      markers: Set<Marker>.of(markers.values),
      mapType: MapType.normal,
      initialCameraPosition:
          CameraPosition(target: LatLng(widget.lat, widget.long), zoom: 15),
      onMapCreated: _onMapCreated,
    );
  }

  initData() {
    geo = Geoflutterfire();
    GeoFirePoint center =
        geo.point(latitude: widget.lat, longitude: widget.long);
    stream = radius.switchMap((rad) {
      var collectionReference = _firestore
          .collection('employee')
          .where('keahlian', isEqualTo: widget.keahlian)
          .where('pendidikan', isEqualTo: widget.pendidikan)
          .where('gender', isEqualTo: widget.gender)
          .where('kota', isEqualTo: widget.kota)
          .where('jamKerja', isEqualTo: widget.jamKerja)
          .where('statusKerja', isEqualTo: true);
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'position', strictMode: true);
    });
  }
}
