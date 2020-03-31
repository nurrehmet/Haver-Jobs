import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileHead extends StatelessWidget {
  final IconData titleIcon;
  final String tileTitle;
  final String tileSubtitle;

  ProfileHead({
    @required this.titleIcon,
    @required this.tileTitle,
    @required this.tileSubtitle,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(titleIcon),
                  title: Text(tileTitle),
                  subtitle: Text(tileSubtitle),
                  trailing: FlatButton(
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamed(context, "/login");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StreamData extends StatelessWidget {
  final String collection;
  final String document;

  StreamData({
    @required this.collection,
    @required this.document
  });
  @override
  Widget build(BuildContext context) {
  return new StreamBuilder(
      stream: Firestore.instance.collection(collection).document(document).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new Text("Loading");
        }
        var userDocument = snapshot.data;
        return new Text(userDocument['nama']);
      }
  );
}
}
