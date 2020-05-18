import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/screens/employee/job_details.dart';

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
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
                title: Text(
                  'Lamaran Pekerjaan Terkirim',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
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
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white,
                          elevation: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(snapshot.data['judul']),
                              subtitle: Text(snapshot.data['namaPerusahaan']),
                              trailing: FlatButton.icon(icon: Icon(Icons.delete_forever),label: Text('Lowongan telah dihapus'),
                              onPressed: null),
                            ),
                          ),
                        );
                      }
                      var job = snapshot.data;
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(job['status'] == 'deleted'
                                ? 'Lowongan telah dihapus'
                                : job['judul']),
                            subtitle: Text(job['status'] == 'deleted'
                                ? 'Lowongan telah dihapus'
                                : job['namaPerusahaan']),
                            trailing: FlatButton.icon(
                              icon: Icon(Icons.exit_to_app),
                              label: Text('Detail Pekerjaan'),
                              onPressed: job['status'] == 'deleted'
                                  ? null
                                  : () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => JobDetail(
                                          jobID: i,
                                        ),
                                      )),
                            ),
                          ),
                        ),
                      );
                    })
            ],
          ),
        ),
      ),
    );
  }
}
