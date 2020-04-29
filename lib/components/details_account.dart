import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haverjob/components/profile_avatar.dart';
import 'package:url_launcher/url_launcher.dart';

class AkunDetail extends StatelessWidget {
  String userID, nama, jarak;
  AkunDetail({this.userID, this.nama, this.jarak});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(nama),
        centerTitle: true,
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfileAvatar(uid: snapshot.documentID,detailEmployee: true,radius: 70,),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  trailing: Icon(
                    Icons.chat,
                    color: Colors.green,
                  ),
                  title: Text(snapshot.data['nama'],
                      style: TextStyle(
                        fontSize: 22,
                      )),
                  subtitle: Text(
                      '${snapshot.data['gender']} , ${snapshot.data['keahlian']}  ',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Visibility(
                  visible: jarak == null ? false : true,
                  child: ListTile(
                    leading: Icon(
                      Icons.directions,
                      color: Colors.blue,
                    ),
                    title: Text('Jarak'),
                    subtitle: Text('$jarak KM'),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.location_city,
                    color: Colors.blue,
                  ),
                  title: Text('Kota'),
                  subtitle: Text(snapshot.data['kota']),
                ),
                ListTile(
                  leading: Icon(
                    Icons.map,
                    color: Colors.blue,
                  ),
                  title: Text('Alamat'),
                  subtitle: Text(snapshot.data['alamat']),
                ),
                ListTile(
                  trailing: FlatButton(
                    textColor: Colors.blue,
                    onPressed: () async {
                      await launch("tel:${snapshot.data['noHp']}");
                    },
                    child: Text('HUBUNGI',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  leading: Icon(
                    Icons.phone,
                    color: Colors.blue,
                  ),
                  title: Text('No Handphone'),
                  subtitle: Text(snapshot.data['noHp']),
                ),
                ListTile(
                  trailing: FlatButton(
                    textColor: Colors.blue,
                    onPressed: () async {
                      await launch("mailto:${snapshot.data['email']}");
                    },
                    child: Text('HUBUNGI',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  leading: Icon(
                    Icons.email,
                    color: Colors.blue,
                  ),
                  title: Text('Email'),
                  subtitle: Text(snapshot.data['email']),
                ),
                ListTile(
                  leading: Icon(
                    Icons.school,
                    color: Colors.blue,
                  ),
                  title: Text('Pendidikan Terakhir'),
                  subtitle: Text(snapshot.data['pendidikan']),
                ),
                ListTile(
                  leading: Icon(
                    Icons.date_range,
                    color: Colors.blue,
                  ),
                  title: Text('Usia'),
                  subtitle: Text(snapshot.data['usia']),
                ),
                ListTile(
                  leading: Icon(
                    Icons.access_time,
                    color: Colors.blue,
                  ),
                  title: Text('Jam Kerja'),
                  subtitle: Text(snapshot.data['jamKerja']),
                ),
                ListTile(
                  leading: Icon(
                    Icons.attach_money,
                    color: Colors.blue,
                  ),
                  title: Text('Gaji per Jam'),
                  subtitle: Text(snapshot.data['gaji'].toString()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


