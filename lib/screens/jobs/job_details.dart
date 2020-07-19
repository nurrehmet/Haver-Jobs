import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haverjob/components/profile_avatar.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/models/jobs.dart';
import 'package:haverjob/screens/direction_map.dart';
import 'package:haverjob/screens/maps_view.dart';
import 'package:haverjob/services/firebase_auth_service.dart';
import 'package:haverjob/utils/global.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

String userID;
List applyStatus;
bool statusApply;
int jumlahPelamar;

class JobDetail extends StatefulWidget {
  String jobID;
  JobDetail({this.jobID});

  @override
  _JobDetailState createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  void initState() {
    getID();
    checkApplyStatus();
    super.initState();
  }

  getID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userID = user.uid;
    });
  }

  checkApplyStatus() {
    Firestore.instance
        .collection('jobs')
        .document(widget.jobID)
        .get()
        .then((DocumentSnapshot) => setState(() {
              applyStatus = DocumentSnapshot.data['applier'];
              if (applyStatus.contains(userID)) {
                setState(() {
                  statusApply = true;
                });
              } else {
                setState(() {
                  statusApply = false;
                });
              }
              print(statusApply);
              jumlahPelamar = applyStatus.length;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            .collection('jobs')
            .document(widget.jobID)
            .snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot,
        ) {
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
    final Set<Marker> _markers = {
      Marker(
        markerId: MarkerId("lokasi"),
        position: LatLng(snapshot.data['latitude'], snapshot.data['longitude']),
        icon: BitmapDescriptor.defaultMarker,
      ),
    };
    //fungsi time ago
    var date = snapshot.data['createdAt'].toDate();
    var now = DateTime.now();
    var diff = now.difference(date);
    return Scaffold(
      bottomNavigationBar: new Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        color: Colors.white.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 70,
              width: 300,
              child: RoundedButton(
                text: 'Lamar Pekerjaan  | ${jumlahPelamar} Pelamar',
                color: secColor,
                onPress: statusApply == false
                    ? () => applyJob(snapshot.documentID, userID)
                    : null,
              ),
            ),
            
          ],
        ),
      ),
      backgroundColor: bgColor,
      body: DefaultTabController(
        length: 2,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        snapshot.data['judul'],
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      trailing: ProfileAvatar(
                        detailEmployee: true,
                        uid: snapshot.data['creator'],
                      ),
                      subtitle: Text(
                          snapshot.data['namaPerusahaan'] +
                              ' - ' +
                              snapshot.data['kota'],
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    ListTile(
                      leading: Text('Part Time'),
                      trailing: Text('Rp.' + snapshot.data['gaji'] + '/ jam'),
                    ),
                  ],
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: ListTile(
                      title: Text(
                        'Deskripsi pekerjaan',
                        style: styleBold,
                      ),
                      subtitle: Text(
                        timeago.format(now.subtract(diff)),
                        // snapshot.data.documents[index]['createdAt'].toString(),
                        style: styleFade,
                      ),
                    ),
                  ),
                  ListTile(
                    subtitle: Text(snapshot.data['deskripsi']),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListTile(
                      title: Text('Kualifikasi pekerjaan', style: styleBold),
                    ),
                  ),
                  ListTile(
                    title: Text('Jam Kerja'),
                    subtitle: Text(snapshot.data['jamKerja']),
                  ),
                  ListTile(
                    title: Text('Pendidikan'),
                    subtitle: Text(snapshot.data['pendidikan']),
                  ),
                  ListTile(
                    title: Text('Kategori Pekerjaan'),
                    subtitle: Text(snapshot.data['kategoriPekerjaan']),
                  ),
                  ListTile(
                    title: Text('Gender'),
                    subtitle: Text(snapshot.data['gender']),
                  ),
                  ListTile(
                    title: Text('Kota'),
                    subtitle: Text(snapshot.data['kota']),
                  ),
                  ListTile(
                    title: Text('Alamat'),
                    subtitle: Text(snapshot.data['lokasi']),
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
                        target: LatLng(snapshot.data['latitude'],
                            snapshot.data['longitude']),
                        zoom: 14.0,
                      ),
                    ),
                  ),
                  RoundedButton(
                    color: secColor,
                    text: 'Arahkan Ke Lokasi',
                    onPress: () async {
                      launch(
                          'https://www.google.com/maps/dir/?api=1&destination=${snapshot.data['latitude']},${snapshot.data['longitude']}');
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  //fungsi lamar pekerjaan
  void applyJob(String jobID, String userID) async {
    var id = '["${userID}"]';
    var applier = json.decode(id);
    final DocumentReference postRef =
        Firestore.instance.document('jobs/${jobID}');
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef,
            <String, dynamic>{'applier': FieldValue.arrayUnion(applier)});
      }
      saveJob(jobID, userID);
    }).whenComplete(() {
      EdgeAlert.show(context,
          title: 'Sukses',
          description: 'Lamaran Pekerjaan Berhasil Dikirim',
          gravity: EdgeAlert.TOP,
          icon: Icons.check_circle,
          backgroundColor: secColor);
    });
  }

  //save id ke db
  void saveJob(String jobID, String userID) async {
    var id = '["${jobID}"]';
    var appliedJob = json.decode(id);
    final DocumentReference postRef =
        Firestore.instance.document('employee/${userID}');
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef,
            <String, dynamic>{'appliedJob': FieldValue.arrayUnion(appliedJob)});
      }
    });
  }
}
