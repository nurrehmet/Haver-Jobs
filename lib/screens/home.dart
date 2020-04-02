import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haverjob/screens/employee_screen.dart';
import 'package:haverjob/screens/employee_seeker_screen.dart';

class Home extends StatefulWidget {
  const Home({Key key, this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[900],
        title: Text('Haver Jobs'),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.lock_outline,
                  size: 26.0,
                ),
              )),
        ],
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(widget.user.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return checkRole(snapshot.data);
          }
          return LinearProgressIndicator();
        },
      ),
    );
  }

  checkRole(DocumentSnapshot snapshot) {
    if (snapshot.data == null) {
      return Center(
        child: FlatButton(
          child: Text('Sign Out'),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushNamed(context, "/login");
          },
        ),
      );
    }
    if (snapshot.data['role'] == 'employee seeker') {
      return new EmployeeSeekerScreen();
    }
    if (snapshot.data['role'] == 'employee') {
      return EmployeeScreen();
    }
    return Center(child: Text('Anda Siapa?'));
  }

  adminPage(DocumentSnapshot snapshot) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Text(
                  ' Role Anda : ${snapshot.data['role']} , Nama Anda : ${snapshot.data['nama']}')),
          SizedBox(
            height: 20.0,
          ),
          FlatButton(
            child: Text(
              'Signout',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red,
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
            },
          ),
        ]);
  }

  Center userPage(DocumentSnapshot snapshot) {
    return Center(child: Text(snapshot.data['nama']));
  }
}
