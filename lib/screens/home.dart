import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:haverjob/services/authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String isLoggedIn;
  bool check;
  @override
  void initState() {
    super.initState();
    // new Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home ${widget.user.email}'),
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
        child: Text('no data set in the userId document in firestore'),
      );
    }
    if (snapshot.data['role'] == 'admin') {
      return adminPage(snapshot);
    } else {
      return userPage(snapshot);
    }
  }

  Column adminPage(DocumentSnapshot snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children:<Widget>[
           Center(child: Text(' Role Anda : ${snapshot.data['role']} , Nama Anda : ${snapshot.data['nama']}')),
           SizedBox(height: 20.0,),
           FlatButton(
             child: Text('Signout',style: TextStyle(color: Colors.white),),
             color: Colors.red,
             onPressed: (){
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
