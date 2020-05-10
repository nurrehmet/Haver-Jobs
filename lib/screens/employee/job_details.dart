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
        elevation: 0,
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
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 25.0, // soften the shadow
                spreadRadius: 5.0, //extend the shadow
                offset: Offset(
                  15.0, // Move to right 10  horizontally
                  15.0, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ProfileAvatar(
                  uid: snapshot.data['creator'],
                  detailEmployee: true,
                  radius: 30,
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Center(
                      child: Text(snapshot.data['judul'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                    ),
                    subtitle: Center(
                      child: Text('${snapshot.data['namaPerusahaan']}  ',
                          style: TextStyle(
                            fontSize: 18,
                          )),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          height: 70,
                          width: 150,
                          child: Center(child: Text('Part Time')),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.green[200],
                              borderRadius: BorderRadius.circular(10)),
                          height: 70,
                          width: 150,
                          child: Center(
                            child:
                                Text('Rp.' + snapshot.data['gaji'] + ' /Jam'),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Deksripsi Pekerjaan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(snapshot.data['deskripsi']),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Lokasi',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(snapshot.data['lokasi']),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Gaji per Jam',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Rp. ' + snapshot.data['gaji']),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Jam Kerja',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(snapshot.data['jamKerja']),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Pendidikan Minimal',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(snapshot.data['pendidikan']),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text('Gender Yang Dibutuhkan',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(snapshot.data['gender']),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          height: 70,
                          width: 100,
                          child: Center(
                            child: Icon(Icons.bookmark_border),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await launch(
                                "mailto:${snapshot.data['emailPerusahaan']}");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red[200],
                                borderRadius: BorderRadius.circular(10)),
                            height: 70,
                            width: 200,
                            child: Center(
                              child: Text('Kirim Email Lamaran'),
                            ),
                          ),
                        )
                      ],
                    ),
                    // FloatingActionButton.extended(
                    //   backgroundColor: Colors.green,
                    //   icon: Icon(Icons.send),
                    //   label: Text('Kirim Email Lamaran'),
                    //   onPressed: () async {

                    //   },
                    // ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
