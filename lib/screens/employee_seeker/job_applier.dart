import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/details_account.dart';

class JobApplier extends StatefulWidget {
  String jobID;
  JobApplier({this.jobID});
  @override
  _JobApplierState createState() => _JobApplierState();
}

class _JobApplierState extends State<JobApplier> {
  List jobApplier = [];
  void initState() {
    checkJobApplier();
    super.initState();
  }

  checkJobApplier() async {
    await Firestore.instance
        .collection('jobs')
        .document(widget.jobID)
        .get()
        .then((DocumentSnapshot) => setState(() {
              jobApplier = DocumentSnapshot.data['applier'];
            }));
  }

  final Firestore firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Pelamar Pekerjaan'),
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5,
              ),
              for (var i in jobApplier)
                StreamBuilder(
                    stream: Firestore.instance
                        .collection('employee')
                        .document(i)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: new Text('Belum ada pelamar'));
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
                            title: Text(job['nama']),
                            subtitle: Text(job['email']),
                            trailing: FlatButton.icon(
                              icon: Icon(Icons.exit_to_app),
                              label: Text('Detail Pelamar'),
                              onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AkunDetail(
                                  userID: i,
                                ),
                              )),
                            ),
                          ),
                        ),
                      );
                      // return Card(
                      //    shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     color: Colors.white,
                      //     elevation: 1,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Text(job == null ?'Data tidak ditemukan':job["judul"]),
                      //   ));
                    })
            ],
          ),
        ),
      ),
    );
  }
}
