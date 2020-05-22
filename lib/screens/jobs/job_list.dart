import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/screens/jobs/job_details.dart';
import 'package:haverjob/utils/global.dart';

class JobList extends StatefulWidget {
  String category;
  JobList({this.category});
  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  final Firestore firestore = Firestore.instance;

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.category == null
          ? null
          : (AppBar(
              iconTheme: IconThemeData(
                color: secColor, //change your color here
              ),
              elevation: 0,
              backgroundColor: Colors.white,
            )),
      backgroundColor: bgColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('jobs')
            .orderBy('createdAt', descending: true)
            .where('kategoriPekerjaan', isEqualTo: widget.category)
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
              controller: controller,
              itemBuilder: (context, index) {
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
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobDetail(
                                  jobID:
                                      snapshot.data.documents[index].documentID,
                                ),
                              )),
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
                            // snapshot.data.documents[index]['createdAt'].toString(),
                            style: styleFade,
                          ),
                          trailing: FlatButton.icon(
                            icon: Icon(
                              Icons.bookmark_border,
                              color: secColor,
                            ),
                            label: Text('Simpan'),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobDetail(
                                    jobID: snapshot
                                        .data.documents[index].documentID,
                                  ),
                                )),
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
    );
  }
}
