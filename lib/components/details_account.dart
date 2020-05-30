import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haverjob/components/profile_avatar.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/screens/direction_map.dart';
import 'package:haverjob/utils/global.dart';
import 'package:url_launcher/url_launcher.dart';

class AkunDetail extends StatelessWidget {
  String userID, nama, jarak;
  AkunDetail({this.userID, this.nama, this.jarak});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //     'Data Diri Pekerja',
        //     style: TextStyle(color: mainColor, fontWeight: bold, fontSize: 22),
        //   ),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.bookmark_border,
              color: secColor,
            ),
            onPressed: () {},
          )
        ],
        iconTheme: IconThemeData(
          color: secColor, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('employee')
            .document(userID)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return accountScreen(snapshot.data);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  accountScreen(DocumentSnapshot snapshot) {
    final Set<Marker> _markers = {Marker(
        markerId: MarkerId("lokasi"),
        position: LatLng(snapshot.data['latitude'],snapshot.data['longitude']),
        icon: BitmapDescriptor.defaultMarker,
      ),};
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: new Container(
        height: 100,
        color: Colors.white.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 70,
              width: 250,
              child: RoundedButton(
                text: 'Whatsapp',
                color: secColor,
                onPress: () async {
                  await launch(
                      "https://api.whatsapp.com/send?phone=+62${snapshot.data['noHp']}&text=&source=&data=&app_absent=");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: FloatingActionButton.extended(
                elevation: 0,
                icon: Icon(Icons.email),
                label: Text('Email'),
                backgroundColor: mainColor,
                onPressed: () async {
                  await launch(
                      'mailto:${snapshot.data['email']}');
                },
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    trailing: ProfileAvatar(
                      uid: userID,
                      detailEmployee: true,
                    ),
                    title: Text(
                      snapshot.data['nama'],
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        snapshot.data['keahlian'] +
                            ' - ' +
                            snapshot.data['kota'],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Text(jarak == null
                        ? 'Pendidikan: ' + snapshot.data['pendidikan']
                        : 'Jarak ' + jarak + ' KM'),
                    trailing: Text('Gaji: Rp.' +
                        snapshot.data['gaji'].toString() +
                        '/ jam'),
                  )
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Data Diri',
                style: styleBold,
              ),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(snapshot.data['email']),
            ),
            ListTile(
              title: Text('No Handphone'),
              subtitle: Text(snapshot.data['noHp']),
            ),
            ListTile(
              title: Text('Jam Kerja'),
              subtitle: Text(snapshot.data['jamKerja']),
            ),
            Visibility(
              visible: jarak == null ? false : true,
              child: ListTile(
                title: Text('Pendidikan'),
                subtitle: Text(snapshot.data['pendidikan']),
              ),
            ),
            ListTile(
              title: Text('Usia'),
              subtitle: Text(snapshot.data['usia']),
            ),
            ListTile(
              title: Text('Pengalaman Kerja'),
              subtitle: Text(snapshot.data['pengKerja']),
            ),
            ListTile(
              title: Text('Kota'),
              subtitle: Text(snapshot.data['kota']),
            ),
            ListTile(
              title: Text('Alamat'),
              subtitle: Text(snapshot.data['alamat']),
            ),
            ListTile(
              title: Text('Lokasi'),
            ),
            Container(
              height: 250,
              child: GoogleMap(
                markers: _markers,
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(snapshot.data['latitude'], snapshot.data['longitude']),
                  zoom: 14.0,
                ),
              ),
            ),
             RoundedButton(
                  color: secColor,
                  text: 'Arahkan Ke Lokasi',
                  onPress: ()async{
                    launch('https://www.google.com/maps/dir/?api=1&destination=${snapshot.data['latitude']},${snapshot.data['longitude']}');
                  },
                )
          ],
        ),
      ),
    );
  }
}
