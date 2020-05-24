import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/screens/jobs/job_details.dart';
import 'package:haverjob/utils/global.dart';

class AppliedJobs extends StatefulWidget {
  String userID;
  AppliedJobs({this.userID});
  @override
  _AppliedJobsState createState() => _AppliedJobsState();
}

class _AppliedJobsState extends State<AppliedJobs> {
  List appliedJobs = [];
  int length;
  void initState() {
    checkAppliedJobs();
    super.initState();
  }

  checkAppliedJobs() async {
    await Firestore.instance
        .collection('employee')
        .document(widget.userID)
        .get()
        .then((DocumentSnapshot) => setState(() {
              appliedJobs = DocumentSnapshot.data['appliedJob'];
            }));
  }

  final Firestore firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          backgroundColor: secColor,
          elevation: 0,
          child: Icon(
            Icons.refresh
          ),
          onPressed: (){
            checkAppliedJobs();
          },
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'Lamaran Terkirim',
            style: TextStyle(color: mainColor, fontWeight: bold, fontSize: 22),
          ),
        ),
        iconTheme: IconThemeData(
          color: secColor, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[200],
      body: ListView(
        children: <Widget>[
          for (var i in appliedJobs)
            StreamBuilder(
                stream: Firestore.instance
                    .collection('jobs')
                    .document(i)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: new Text('Belum ada lamaran terkirim'));
                  } else if (snapshot.data['status'] == 'deleted') {
                    return Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(
                              snapshot.data['judul'],
                              style: TextStyle(color: Colors.grey),
                            ),
                            subtitle: Text(
                              snapshot.data['namaPerusahaan'],
                              style: TextStyle(color: Colors.grey),
                            ),
                            trailing: FlatButton.icon(
                                icon: Icon(
                                  Icons.close,
                                ),
                                label: Text('Status Tidak Aktif'),
                                onPressed: null),
                          ),
                        ),
                      ),
                    );
                  }
                  var job = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobDetail(
                                        jobID: i,
                                      ),
                                    )),
                                title: Text(
                                  job['judul'],
                                  style: TextStyle(fontWeight: bold),
                                ),
                                subtitle: Text(job['namaPerusahaan'] +
                                    ' - ' +
                                    job['kota']),
                                trailing: Icon(Icons.keyboard_arrow_right),
                              ),
                              ListTile(
                                subtitle: Text(
                                  job['deskripsi'] + ' ...',
                                  maxLines: 3,
                                ),
                              )
                            ],
                          )),
                    ),
                  );
                })
        ],
      ),
    );
  }
}