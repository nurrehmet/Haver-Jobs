import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/screens/employee_seeker/create_jobs.dart';

class JobsData extends StatefulWidget {
  String userID;
  JobsData({this.userID});
  @override
  _JobsDataState createState() => _JobsDataState();
}

class _JobsDataState extends State<JobsData> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;

    return Scaffold(
      key: scaffoldState,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildListES(widthScreen, heightScreen, context),
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
              builder: (context) => CreateJobs(),
            ),
          );
        },
        backgroundColor: Colors.blue,
      ),
    );
  }

  Container _buildListES(
      double widthScreen, double heightScreen, BuildContext context) {
    return Container(
      width: widthScreen,
      height: heightScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Data Pekerjaan',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('jobs')
                  .where('creator' ,isEqualTo: widget.userID)
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
                    DocumentSnapshot document = snapshot.data.documents[index];
                    Map<String, dynamic> jobsData = document.data;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Colors.blue[50],
                      elevation: 1,
                      child: ListTile(
                        title: Text(jobsData['judul']),
                        subtitle: Text(
                          jobsData['deskripsi'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        isThreeLine: false,
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return List<PopupMenuEntry<String>>()
                              ..add(PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ))
                              ..add(PopupMenuItem<String>(
                                value: 'delete',
                                child: Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ));
                          },
                          onSelected: (String value) async {
                            if (value == 'edit') {
                              // TODO: fitur edit task
                            } else if (value == 'delete') {
                              // TODO: fitur hapus task
                            }
                          },
                          child: Icon(Icons.more_vert),
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
    );
  }
}
