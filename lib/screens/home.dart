import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haverjob/screens/admin/admin_screen.dart';
import 'package:haverjob/screens/employee/employee_screen.dart';
import 'package:haverjob/screens/employee_seeker/employee_seeker_screen.dart';

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
      // appBar: AppBar(
      //   leading: Icon(Icons.menu),
      //   elevation: 0,
      //   actions: <Widget>[
      //     Padding(
      //       padding: const EdgeInsets.all(15.0),
      //       child: Icon(Icons.search),
      //     )
      //   ],
      //   centerTitle: true,
      //   backgroundColor: Hexcolor('#112d4e'),
      //   title: Text('Haver Jobs'),
      //   automaticallyImplyLeading: false,
      // ),
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
    if (snapshot.data['role'] == 'admin') {
      return AdminScreen();
    }
    return Center(child: Text('Anda Siapa?'));
  }
}

