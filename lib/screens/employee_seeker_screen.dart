import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/banner_card.dart';
import 'package:haverjob/components/item_grid.dart';
import 'package:haverjob/components/maps_view.dart';
import 'package:haverjob/components/setting_screen.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/models/global.dart';
import 'package:haverjob/screens/find_employee_screen.dart';
import 'package:hexcolor/hexcolor.dart';

class EmployeeSeekerScreen extends StatefulWidget {
  @override
  _EmployeeSeekerScreenState createState() => _EmployeeSeekerScreenState();
}

class _EmployeeSeekerScreenState extends State<EmployeeSeekerScreen> {
  String _userID;
  String _documents = 'users';
  String _nama;
  String _email;

  void initState() {
    getID();
    super.initState();
  }

  int _selectedIndex = 0;

  List<Widget> get _widgetOptions => [
        // FindEmployeeScreen(),
        WelcomeES(),
        Center(
          child: Text(
            'Posting Pekerjaan',
          ),
        ),
        SettingScreen(),
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(
              'Cari Pekerja',
              style: TextStyle(),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Chat', style: TextStyle()),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings', style: TextStyle()),
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

class WelcomeES extends StatelessWidget {
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
                        child: Text(
                          'Haver Jobs',
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
                          'Haver Jobs adalah platform untuk mencari pekerja Part Time terdekat',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      BannerCard(
                        title: 'Cari Pekerja Part Time Dengan Filter',
                        subtitle:
                            'Cari pekerja part time dengan menggunakan kriteria tertentu, seperti lokasi, pendidikan, dan keahlian',
                        btText: 'MULAI MENCARI',
                        image: 'assets/images/filter.png',
                        action: () =>
                            {Navigator.pushNamed(context, "/findEmployee")},
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Cari Pekerja Dengan Kategori',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      GridBanner(),
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

class GridBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ItemGrid(
              label: 'Programmer',
              action: () => {Navigator.pushNamed(context, "/listEmployee")},
              image: 'assets/icons/programmer.png',
            ),
            ItemGrid(
              label: 'Barista',
              action: () {},
              image: 'assets/icons/barista.png',
            ),
            ItemGrid(
              label: 'Penulis Lepas',
              action: () {},
              image: 'assets/icons/penulis.png',
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ItemGrid(
              label: 'Guru Les',
              action: () {},
              image: 'assets/icons/guru.png',
            ),
            ItemGrid(
              label: 'Desain Grafis',
              action: () {},
              image: 'assets/icons/designer.png',
            ),
            ItemGrid(
              label: 'Waiter',
              action: () {},
              image: 'assets/icons/waiter.png',
            ),
          ],
        ),
      ],
    );
  }
}
