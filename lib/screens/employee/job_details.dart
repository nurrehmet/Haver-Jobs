import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haverjob/components/profile_avatar.dart';
import 'package:haverjob/screens/direction_map.dart';
import 'package:haverjob/screens/maps_view.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetail extends StatelessWidget {
  String jobID;
  JobDetail({this.jobID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pekerjaan'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            Firestore.instance.collection('jobs').document(jobID).snapshots(),
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
    Timestamp t = snapshot.data['createdAt'];
    var date = DateFormat.yMMMd().add_jm().format(t.toDate());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProfileAvatar(
                uid: snapshot.data['creator'],
                detailEmployee: true,
                radius: 70,
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(snapshot.data['judul'],
                      style: TextStyle(
                        fontSize: 22,
                      )),
                  subtitle: Text('${snapshot.data['namaPerusahaan']}  ',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                FloatingActionButton.extended(
                  backgroundColor: Colors.green,
                  icon: Icon(Icons.send),
                  label: Text('Kirim Email Lamaran'),
                  onPressed: () async {
                    await launch("mailto:${snapshot.data['emailPerusahaan']}");
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.date_range,
                    color: Colors.blue,
                  ),
                  title: Text('Tanggal Dipublikasikan'),
                  subtitle: Text(date.toString()),
                ),
                ListTile(
                  leading: Icon(
                    Icons.title,
                    color: Colors.blue,
                  ),
                  title: Text('Deksripsi Pekerjaan'),
                  subtitle: Text(snapshot.data['deskripsi']),
                ),
                ListTile(
                  leading: Icon(
                    Icons.location_city,
                    color: Colors.blue,
                  ),
                  title: Text('Lokasi'),
                  subtitle: Text(snapshot.data['lokasi']),
                ),
                ListTile(
                  leading: Icon(
                    Icons.attach_money,
                    color: Colors.blue,
                  ),
                  title: Text('Gaji per Jam'),
                  subtitle: Text('Rp. '+snapshot.data['gaji']),
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
                    Icons.school,
                    color: Colors.blue,
                  ),
                  title: Text('Pendidikan Minimal'),
                  subtitle: Text(snapshot.data['pendidikan']),
                ),
                ListTile(
                  leading: Icon(
                    Icons.people,
                    color: Colors.blue,
                  ),
                  title: Text('Gender Yang Dibutuhkan'),
                  subtitle: Text(snapshot.data['gender']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
