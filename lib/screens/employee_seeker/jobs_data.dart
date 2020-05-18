import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/screens/edit_data.dart';
import 'package:haverjob/screens/employee_seeker/create_jobs.dart';
import 'package:haverjob/screens/employee_seeker/edit_jobs.dart';
import 'package:haverjob/screens/employee_seeker/job_applier.dart';

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
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildListES(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
        backgroundColor: Colors.green,
      ),
    );
  }

  Container _buildListES() {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('jobs')
                    .where('creator', isEqualTo: widget.userID)
                    .where('status', isEqualTo: 'active')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document =
                          snapshot.data.documents[index];
                      Map<String, dynamic> jobsData = document.data;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(jobsData['judul'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                jobsData['deskripsi'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            isThreeLine: false,
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
                                            jobID: document.documentID),
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
                                          jobID: document.documentID,
                                        ),
                                      ));
                                }
                              },
                              child: Icon(Icons.more_vert),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
