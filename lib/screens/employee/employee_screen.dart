import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/banner_card.dart';
import 'package:haverjob/components/details_account.dart';
import 'package:haverjob/components/setting_screen.dart';
import 'package:haverjob/models/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  String _userID;
  void initState() {
    getID();
    print(UserData().getID());
    super.initState();
  }

  int _selectedIndex = 0;

  List<Widget> get _widgetOptions => [
        WelcomeEmployee(),
        Center(child: Text('Cari Pekerjaan')),
        SettingScreen()
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
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text(
              'Akun',
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
    });
  }
}

class WelcomeEmployee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            'https://iupac.org/wp-content/uploads/2018/05/default-avatar.png',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
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
                        action: () =>
                            {Navigator.pushNamed(context, "/editEmployee")},
                      ),
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
