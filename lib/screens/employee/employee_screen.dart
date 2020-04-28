import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/banner_card.dart';
import 'package:haverjob/components/details_account.dart';
import 'package:haverjob/components/profile_avatar.dart';
import 'package:haverjob/models/global.dart';
import 'package:haverjob/screens/edit_data.dart';
import 'package:haverjob/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  String _userID;
  String _imageUrl;
  void initState() {
    getID();
    super.initState();
  }

  int _selectedIndex = 0;

  List<Widget> get _widgetOptions => [
        WelcomeEmployee(
          imageUrl: _imageUrl,
        ),
        Center(child: Text('Cari Pekerjaan')),
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Beranda',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text(
              'Chat',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      _userID = user.uid;
      var ref = FirebaseStorage.instance.ref().child('avatar/$_userID');
      ref.getDownloadURL().then((loc) => setState(() => _imageUrl = loc));
      print(_imageUrl);
    });
  }
}

class WelcomeEmployee extends StatelessWidget {
  String imageUrl;
  WelcomeEmployee({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Haver Jobs'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
              textColor: Colors.white,
              child: Icon(Icons.edit),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditData(role: 'employee'),
                  )))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  ProfileAvatar(radius: 50),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Data Diri'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditData(role: 'employee'),
                  )),
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ),
              title: Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Selamat Datang',
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Update data diri kamu untuk mendapatkan penawaran pekerjaan part time',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      BannerCard(
                          title: 'Update Data Diri Kamu',
                          subtitle:
                              'Update data diri kamu agar memudahkan pemilik perusahaan untuk mencari pekerja part time yang sesuai',
                          color: Colors.green,
                          btText: 'UPDATE DATA DIRI',
                          image: 'assets/images/update.png',
                          action: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditData(role: 'employee'),
                              ))),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
