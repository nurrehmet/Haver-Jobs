import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haverjob/components/profile_avatar.dart';
import 'package:haverjob/models/jobs.dart';
import 'package:haverjob/screens/direction_map.dart';
import 'package:haverjob/screens/maps_view.dart';
import 'package:haverjob/services/firebase_auth_service.dart';
import 'package:haverjob/utils/global.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
            child: Icon(Icons.bookmark_border,color: secColor,),
            onPressed: (){},
          )
        ],
        iconTheme: IconThemeData(
          color: secColor, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
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
    return Scaffold(
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        child: Column(
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: ProfileAvatar(
              //     uid: snapshot.data['creator'],
              //     detailEmployee: true,
              //     radius: 30,
              //   ),
              // ),
              // Container(
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: ListTile(
              //       title: Center(
              //         child: Text(snapshot.data['judul'],
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //                 fontSize: 25, fontWeight: FontWeight.bold)),
              //       ),
              //       subtitle: Center(
              //         child: Text('${snapshot.data['namaPerusahaan']}  ',
              //             style: TextStyle(
              //               fontSize: 18,
              //             )),
              //       ),
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Column(
              //     children: <Widget>[
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: <Widget>[
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.grey[200],
              //                 borderRadius: BorderRadius.circular(10)),
              //             height: 70,
              //             width: 170,
              //             child: Center(
              //                 child: Text(
              //               '${jumlahPelamar} Orang Pelamar',
              //               style: TextStyle(fontWeight: FontWeight.bold),
              //             )),
              //           ),
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.green[200],
              //                 borderRadius: BorderRadius.circular(10)),
              //             height: 70,
              //             width: 150,
              //             child: Center(
              //               child: Text(
              //                 'Rp.' + snapshot.data['gaji'] + ' /Jam',
              //                 style: TextStyle(
              //                     color: Colors.green[700],
              //                     fontWeight: FontWeight.bold),
              //               ),
              //             ),
              //           )
              //         ],
              //       ),
              //       SizedBox(
              //         height: 15,
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: ListTile(
              //           title: Text('Tanggal Diposting',
              //               style: TextStyle(fontWeight: FontWeight.bold)),
              //           // subtitle: Text(date.toString()),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: ListTile(
              //           title: Text('Deksripsi Pekerjaan',
              //               style: TextStyle(fontWeight: FontWeight.bold)),
              //           subtitle: Text(snapshot.data['deskripsi']),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: ListTile(
              //           title: Text('Lokasi',
              //               style: TextStyle(fontWeight: FontWeight.bold)),
              //           subtitle: Text(snapshot.data['lokasi']),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: ListTile(
              //           title: Text('Gaji per Jam',
              //               style: TextStyle(fontWeight: FontWeight.bold)),
              //           subtitle: Text('Rp. ' + snapshot.data['gaji']),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: ListTile(
              //           title: Text('Jam Kerja',
              //               style: TextStyle(fontWeight: FontWeight.bold)),
              //           subtitle: Text(snapshot.data['jamKerja']),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: ListTile(
              //           title: Text('Pendidikan Minimal',
              //               style: TextStyle(fontWeight: FontWeight.bold)),
              //           subtitle: Text(snapshot.data['pendidikan']),
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: ListTile(
              //           title: Text('Gender Yang Dibutuhkan',
              //               style: TextStyle(fontWeight: FontWeight.bold)),
              //           subtitle: Text(snapshot.data['gender']),
              //         ),
              //       ),
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: <Widget>[
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.grey[200],
              //                 borderRadius: BorderRadius.circular(10)),
              //             height: 70,
              //             width: 100,
              //             child: Center(
              //               child: Icon(Icons.bookmark_border),
              //             ),
              //           ),
              //           Container(
              //             decoration: BoxDecoration(
              //                 color: Colors.blue[200],
              //                 borderRadius: BorderRadius.circular(10)),
              //             height: 70,
              //             width: 250,
              //             child: FlatButton.icon(
              //               icon: Icon(Icons.send),
              //               label: lamarWidget(),
              //               onPressed: statusApply == false
              //                   ? () => applyJob(snapshot.documentID, userID)
              //                   : null,
              //             ),
              //           )
              //           // InkWell(
              //           //   onTap: () => applyJob(snapshot.documentID, userID),
              //           //   child: Container(

              //           //     child: Center(
              //           //       child: lamarWidget(),
              //           //     ),
              //           //   ),
              //           // )
              //         ],
              //       ),
              //       SizedBox(
              //         height: 15,
              //       )
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
    );
  }

  lamarWidget() {
    if (statusApply == false) {
      return Text('Lamar Pekerjaan');
    } else if (statusApply == true) {
      return Text('Pekerjaan Sudah Dilamar');
    }
  }

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
          icon: Icons.error,
          backgroundColor: Colors.green);
    });
  }

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
