import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:haverjob/screens/welcome_screen.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  profileBuilder(DocumentSnapshot snapshot) {
    return Scaffold(
    backgroundColor: Colors.green,
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: Text('Settings',style: TextStyle(fontFamily: 'Product Sans')),
      centerTitle: true,
    ),
    body: SettingsList(
        sections: [
          SettingsSection(
            title: 'Akun',
            tiles: [
              SettingsTile(
                title: 'Nama',
                subtitle: snapshot.data['nama'],
                leading: Icon(Icons.assignment_ind),
                onTap: () {},
              ),
               SettingsTile(
                title: 'Email',
                subtitle: snapshot.data['email'] ,
                leading: Icon(Icons.email),
                onTap: () {},
              ),
              SettingsTile(
                title: 'Role',
                subtitle: snapshot.data['role'] ,
                leading: Icon(Icons.info),
                onTap: () {},
              ),
               SettingsTile(
                title: 'Alamat',
                subtitle: snapshot.data['alamat'] ,
                leading: Icon(Icons.map),
                onTap: () {},
              ),
              SettingsTile(
                title: 'Logout',
                leading: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
                },
              ),
            ],
          ),
        ],
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
