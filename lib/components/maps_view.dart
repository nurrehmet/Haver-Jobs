import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haverjob/screens/employee_seeker_screen.dart';
import 'package:haverjob/screens/find_employee_screen.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:rxdart/rxdart.dart';

class MapsView extends StatefulWidget {
  const MapsView(
      {Key key,
      this.keahlian,
      this.gender,
      this.pendidikan,
      this.lat,
      this.long,
      this.listQuery})
      : super(key: key);
  final String keahlian, gender, pendidikan;
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
  SolidController _bsController = SolidController();
  double lat, long;
  double _value = 1;
  String _label = '';
  BitmapDescriptor markerIcon;
  Set<Circle> circles;
  double _nilaiRadius;
  @override
  void initState() {
    super.initState();
    print(widget.listQuery);
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
      appBar: AppBar(
        title: Text(
          'Hasil Pencarian',
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
                        child: Icon(Icons.tune),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> EmployeeSeekerScreen()))),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                        heroTag: "btn2",
                        tooltip: 'Lokasi Sekarang',
                        backgroundColor: Colors.white,
                        child: Icon(Icons.near_me, color: Hexcolor('#3f72af')),
                        onPressed: () => _currentLocation()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: markers.isEmpty
                                ? Text(
                                    'Tidak Ada Pekerja Part Time Terdekat',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'Product Sans',
                                        fontWeight: FontWeight.bold),
                                  )
                                : Text('Pekerja Part Time Ditemukan',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: 'Product Sans',
                                        fontWeight: FontWeight.bold)),
                          ),
                          Slider(
                            min: 1,
                            max: 15,
                            divisions: 5,
                            value: _value,
                            label: _label,
                            activeColor: Hexcolor('#3f72af'),
                            inactiveColor: Colors.blue.withOpacity(0.2),
                            onChanged: (double value) => changed(value),
                          ),
                        ],
                      ),
                    ),
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
                  padding: const EdgeInsets.all(0.0),
                  child: Text(
                    'Informasi Penggunaan',
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
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: <Widget>[
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading:
                                    Icon(Icons.my_location, color: Colors.blue),
                                title: Text('Atur Radius Pencarian'),
                                subtitle: Text(
                                    'Jika hasil pencarian tidak ada, mohon atur radius pencarian karyawan dengan menggunakan slider ',style: TextStyle(fontFamily: 'Product Sans',),),
                                trailing: Icon(Icons.looks_one),
                              ),
                            ),
                          ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Icon(Icons.tune, color: Colors.blue),
                                title: Text('Filter Pencarian'),
                                subtitle: Text(
                                    'Filter pencarian dengan kriteria tertentu dengan tap tombol filter ',style: TextStyle(fontFamily: 'Product Sans',)),
                                trailing: Icon(Icons.looks_two),
                              ),
                            ),
                          )
                        ],
                      ))),
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

  void _addMarker(
    double lat,
    double lng,
    String nama,
  ) {
    var point = geo.point(latitude: widget.lat, longitude: widget.long);
    var distance = point.distance(lat: lat, lng: lng);
    MarkerId id = MarkerId(lat.toString() + lng.toString());
    Marker _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      infoWindow: InfoWindow(
          title: nama, snippet: 'Jarak ' + distance.toString() + ' KM'),
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
      );
    });
  }

  changed(value) {
    setState(() {
      _value = value;
      _label = '${_value.toInt().toString()} KM';
      circles = Set.from([
        Circle(
          strokeWidth: 2,
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: Colors.blue,
          circleId: CircleId('circle'),
          center: LatLng(widget.lat, widget.long),
          radius: value * 1000,
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
          .where('gender', isEqualTo: widget.gender);
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'position', strictMode: false);
    });
  }
}
