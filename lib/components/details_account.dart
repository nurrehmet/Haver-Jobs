import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AkunDetail extends StatelessWidget {
  String userID;
  AkunDetail({this.userID});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Akun'),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('employee')
            .document(userID)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return accountScreen(snapshot.data);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  accountScreen(DocumentSnapshot snapshot) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,20,0,0),
                child: CircleAvatar(
                  radius: 50,
                  child: Text('AV'),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text(snapshot.data['nama'],style:TextStyle(fontSize: 25)),
            Text(snapshot.data['keahlian'],style:TextStyle(fontSize: 20,color: Colors.blue)),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('Alamat'),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text('No Hp'),
                  ),
                ],
              ),
            )
          ],
        ),);
  }

 
}
