import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/details_account.dart';
import 'package:haverjob/utils/global.dart';

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
        title: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'Daftar Pelamar Pekerjaan',
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
      body: ListView(
        children: <Widget>[
          for (var i in jobApplier)
            StreamBuilder(
                stream: Firestore.instance
                    .collection('employee')
                    .document(i)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(child: new Text('Belum ada pelamar'));
                  }
                  var job = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 1,),
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(job['nama'],style: styleBold,),
                              subtitle: Text(job['email']),
                              trailing: Icon(Icons.keyboard_arrow_right),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AkunDetail(
                                      userID: i,
                                    ),
                                  )),
                            ),
                            ListTile(
                              leading: Text('Pendidikan: '+ job['pendidikan'],style: styleFade,),
                              trailing: Text('Gaji / Jam: Rp.'+ job['gaji'].toString(),style: styleFade,),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                })
        ],
      ),
    );
  }
}
