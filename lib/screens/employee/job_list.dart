import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/details_account.dart';
import 'package:haverjob/components/profile_avatar.dart';
import 'package:haverjob/screens/employee/job_details.dart';
import 'package:intl/intl.dart';

String _keahlian;

class JobsList extends StatefulWidget {
  final String keahlian;

  const JobsList({Key key, this.keahlian}) : super(key: key);

  @override
  _JobsListState createState() => _JobsListState();
}

class _JobsListState extends State<JobsList> {
  @override
  void initState() {
    super.initState();
    _keahlian = widget.keahlian;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Loker ' + _keahlian + ' Part Time'),
        centerTitle: true,
      ),
      body: EmployeeData(),
    );
  }
}

class EmployeeData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('jobs')
          .where('kategoriPekerjaan', isEqualTo: _keahlian)
          .where('status', isEqualTo: 'active')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        if (!snapshot.hasData) return Text('Tidak Ada Lowongan Kerja Tersedia');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                Timestamp t = document['createdAt'];
                var date = DateFormat.yMMMd().add_jm().format(t.toDate());
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetail(
                                jobID: document.documentID,
                              ),
                            )),
                        child: Card(
                          color: Colors.white,
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 1,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors.white,
                                  child: new ListTile(
                                    leading: new ProfileAvatar(
                                      uid: document['creator'],
                                      detailEmployee: true,
                                      radius: 25,
                                    ),
                                    title: new Text(document['judul'],style: TextStyle(fontWeight: FontWeight.bold),),
                                    subtitle: new Text(
                                      document['namaPerusahaan'] == null
                                          ? 'Nama Perusahaan'
                                          : document['namaPerusahaan'],
                                    ),
                                    trailing: Text('Rp.'+document['gaji'] + ' /jam'),
                                  ),
                                ),
                              ),
                              new ListTile(
                                leading: Text(document['kota'],style: TextStyle(color: Colors.grey),),
                                trailing: Text(date.toString(),style: TextStyle(color: Colors.grey),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
        }
      },
    );
  }
}

