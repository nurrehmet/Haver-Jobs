import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    getID();
    super.initState();
  }
  String _userID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(_userID)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return profileBuilder(snapshot.data);
          }
          return LinearProgressIndicator();
        },
      ),
    );
  }

  profileBuilder(DocumentSnapshot snapshot) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.account_circle),
        title: Text(snapshot.data['nama']),
        subtitle: Text(snapshot.data['email']),
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
    );
  }

  getID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      _userID = user.uid;
    });
  }
}
