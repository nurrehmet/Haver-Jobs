import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/screens/jobs/job_details_v2.dart';
import 'package:haverjob/utils/global.dart';

class SavedJobs extends StatelessWidget {
  String userid;
  SavedJobs({this.userid});

  Future<List<dynamic>> getSavedJob() async {
    var firestore = Firestore.instance;

    var querySnap = await firestore
        .collection('saved-jobs')
        .where('savedBy', isEqualTo: userid)
        .getDocuments();
    return querySnap.documents.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: mainColor,
        title: Text("Lowongan Tersimpan"),),
      body: FutureBuilder<List>(
        future: getSavedJob(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // Success case
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobsDetailV2(
                                  title: snapshot.data[index]['title'],
                                  content: snapshot.data[index]['content'],
                                  url: snapshot.data[index]['link'],
                                  pubDate: snapshot.data[index]['pubDate'],
                                ),
                              )),
                                // leading: provider == "lokernas" ? Image(image:NetworkImage(snapshot.data[index]['thumbnail'])) : CircleAvatar(child: Text('DK'),),
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.data[index]['title'],style: TextStyle(fontWeight: FontWeight.bold,color: mainColor),),
                                ),),
                                // subtitle: Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text(snapshot.data[index]['content'],maxLines: 4,)
                                //   ),
                                // ),
                                // trailing: Text(snapshot.data[index]['link']),
                              ListTile(
                                // trailing: Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text(uperCase(snapshot.data[index]['categories'][0]),style: TextStyle(color: secColor),),
                                // ),
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.data[index]['pubDate'],style: styleFade,),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: snapshot.data.length,
              );
            }
            // Error case
            return Text('Something went wrong');
          } else {
            // Loading data
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}