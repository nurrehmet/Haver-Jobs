import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/details_account.dart';
import 'package:haverjob/components/profile_avatar.dart';

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
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        elevation: 1,
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: Colors.amber,
                              child: new ListTile(
                                leading: new ProfileAvatar(uid: document['creator'],detailEmployee: true,),
                                title: new Text(document['judul']),
                                subtitle: new Text(document['lokasi'],maxLines: 2,),
                              ),
                            ),
                            new ListTile(
                              title: Text('Gaji per Jam'),
                              leading: Icon(
                                Icons.attach_money,
                                color: Colors.blue,
                              ),
                              subtitle: Text(document['gaji'].toString()),
                            ),
                            new ListTile(
                              title: Text('Kategori Pekerjaan'),
                              leading: Icon(
                                Icons.local_drink,
                                color: Colors.blue,
                              ),
                              subtitle: Text(document['kategoriPekerjaan'].toString()),
                            ),
                            ButtonBar(
                              children: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'CHAT',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {},
                                ),
                                FlatButton(
                                  child: Text(
                                    'DETAIL',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AkunDetail(
                                          userID: document.documentID,
                                          nama: document['nama'],
                                          jarak: null,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ],
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
