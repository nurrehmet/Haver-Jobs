import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haverjob/components/banner_card.dart';
import 'package:haverjob/components/details_account.dart';
import 'package:haverjob/components/item_grid.dart';
import 'package:haverjob/components/profile_avatar.dart';
import 'package:haverjob/components/upload_picture.dart';
import 'package:haverjob/functions/get_location.dart';
import 'package:haverjob/screens/edit_data.dart';
import 'package:haverjob/screens/maps_view.dart';
import 'package:haverjob/components/setting_screen.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/models/global.dart';
import 'package:haverjob/screens/employee/employee_list.dart';
import 'package:haverjob/screens/employee_seeker/find_employee_screen.dart';

double lat, long;

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
    _getCurrentLocation();
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
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 2,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(
              'Cari Pekerja',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            title: Text('Chat', style: TextStyle(fontWeight: FontWeight.bold)),
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

  //get user location
  Future<void> _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        lat = position.latitude;
        long = position.longitude;
      });
      print(lat);
      print(long);
    }).catchError((e) {
      print(e);
    });
  }
}

class WelcomeES extends StatelessWidget {
  var user = FirebaseAuth.instance.currentUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Haver Jobs'),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            child: Icon(Icons.search),
            onPressed: () => {Navigator.pushNamed(context, "/findEmployee")},
          )
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
              title: Text('Edit Data Perusahaan'),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditData(role: 'employee seeker'),
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
                          'Haver Jobs adalah platform untuk mencari pekerja Part Time terdekat',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      BannerCard(
                        title: 'Cari Pekerja Part Time Dengan Filter',
                        subtitle:
                            'Cari pekerja part time dengan menggunakan kriteria tertentu, seperti lokasi, pendidikan, dan keahlian',
                        color: Colors.amber,
                        btText: 'CARI PEKERJA PART TIME',
                        image: 'assets/images/filter.png',
                        action: () =>
                            {Navigator.pushNamed(context, "/findEmployee")},
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      BannerCard(
                        title: 'Tampilkan Semua Pekerja Part Time',
                        subtitle:
                            'Menampilkan semua pekerja part time yang terdekat dengan lokasi kamu',
                        color: Colors.blue,
                        btText: 'TAMPILKAN SEMUA',
                        image: 'assets/images/all.png',
                        action: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapsView(
                                type: 'all',
                                lat: lat,
                                long: long,
                              ),
                            ),
                          )
                        },
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
              action: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeList(
                      keahlian: 'Programmer',
                    ),
                  ),
                )
              },
              image: 'assets/icons/programmer.png',
            ),
            ItemGrid(
              label: 'Barista',
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeList(
                      keahlian: 'Barista',
                    ),
                  ),
                );
              },
              image: 'assets/icons/barista.png',
            ),
            ItemGrid(
              label: 'Penulis Lepas',
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeList(
                      keahlian: 'Penulis Lepas',
                    ),
                  ),
                );
              },
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
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeList(
                      keahlian: 'Guru Les Privat',
                    ),
                  ),
                );
              },
              image: 'assets/icons/guru.png',
            ),
            ItemGrid(
              label: 'Desain Grafis',
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeList(
                      keahlian: 'Desainer Grafis',
                    ),
                  ),
                );
              },
              image: 'assets/icons/designer.png',
            ),
            ItemGrid(
              label: 'Waiter',
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmployeeList(
                      keahlian: 'Waiter',
                    ),
                  ),
                );
              },
              image: 'assets/icons/waiter.png',
            ),
          ],
        ),
      ],
    );
  }
}
