import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/screens/edit_data.dart';
import 'package:haverjob/screens/employee_seeker/create_jobs.dart';
import 'package:haverjob/screens/employee_seeker/edit_jobs.dart';
import 'package:haverjob/screens/employee_seeker/job_applier.dart';
import 'package:haverjob/screens/jobs/job_details.dart';
import 'package:haverjob/utils/global.dart';

class JobsData extends StatefulWidget {
  String userID;
  JobsData({this.userID});
  @override
  _JobsDataState createState() => _JobsDataState();
}

class _JobsDataState extends State<JobsData> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Firestore firestore = Firestore.instance;
  bool delete = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'Daftar Lowongan Pekerjaan',
            style: TextStyle(color: mainColor, fontWeight: bold, fontSize: 22),
          ),
        ),
        iconTheme: IconThemeData(
          color: secColor, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: bgColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('jobs')
            .where('creator', isEqualTo: widget.userID)
            .orderBy('createdAt', descending:true)
            .where('status', isEqualTo: 'active')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 1,
                color: bgColor,
              ),
              itemCount: snapshot.data.documents.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                //fungsi time ago
                var date = snapshot.data.documents[index]['createdAt'].toDate();
                var now = DateTime.now();
                var diff = now.difference(date);
                return Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          trailing: PopupMenuButton(
                              itemBuilder: (BuildContext context) {
                                return List<PopupMenuEntry<String>>()
                                  ..add(PopupMenuItem<String>(
                                    value: 'pelamar',
                                    child: Text('Data Pelamar'),
                                  ))
                                  ..add(PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ))
                                  ..add(PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text(
                                      'Hapus',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ));
                              },
                              onSelected: (String value) async {
                                if (value == 'edit') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditJobs(
                                            jobID: snapshot.data.documents[index].documentID),
                                      ));
                                } else if (value == 'delete') {
                                  await Firestore.instance.runTransaction(
                                      (Transaction myTransaction) async {
                                    await myTransaction.update(
                                        snapshot
                                            .data.documents[index].reference,
                                        <String, dynamic>{'status': 'deleted'});
                                  });
                                  EdgeAlert.show(context,
                                      title: 'Sukses',
                                      description:
                                          'Pekerjaaan berhasil dihapus',
                                      gravity: EdgeAlert.TOP,
                                      icon: Icons.check_circle,
                                      backgroundColor: Colors.green);
                                } else if (value == 'pelamar') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JobApplier(
                                          jobID: snapshot.data.documents[index].documentID,
                                        ),
                                      ));
                                }
                              },
                              child: Icon(Icons.more_vert),
                            ),
                          title: Text(
                            snapshot.data.documents[index]["judul"],
                            style: styleBold,
                          ),
                          subtitle: Text(snapshot.data.documents[index]
                                  ['namaPerusahaan'] +
                              ' - ' +
                              (snapshot.data.documents[index]['kota'] == null
                                  ? 'Kota'
                                  : (snapshot.data.documents[index]['kota']))),
                        ),
                        ListTile(
                          subtitle: Text(
                            (snapshot.data.documents[index]['deskripsi'] +
                                '...'),
                            maxLines: 3,
                          ),
                        ),
                        ListTile(
                          leading: Text(
                            timeago.format(now.subtract(diff)),
                            style: styleFade,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: secColor,
            ));
          }
        },
      ),
      // body: SafeArea(
      //   child: Stack(
      //     children: <Widget>[
      //       _buildListES(),
      //     ],
      //   ),
      // ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          elevation: 0,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateJobs(
                  userID: widget.userID,
                ),
              ),
            );
          },
          backgroundColor: secColor,
        ),
      ),
    );
  }
}
