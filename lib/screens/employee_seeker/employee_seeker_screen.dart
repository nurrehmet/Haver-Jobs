import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haverjob/components/banner_card.dart';
import 'package:haverjob/components/item_grid.dart';
import 'package:haverjob/components/profile_avatar.dart';
import 'package:haverjob/screens/edit_data.dart';
import 'package:haverjob/screens/employee_seeker/job_screen.dart';
import 'package:haverjob/screens/employee_seeker/jobs_data.dart';
import 'package:haverjob/screens/maps_view.dart';
import 'package:haverjob/screens/employee/job_list.dart';
import 'package:haverjob/screens/welcome_screen.dart';

double lat, long;
String lokasi,kota;
String _email;

class EmployeeSeekerScreen extends StatefulWidget {
  @override
  _EmployeeSeekerScreenState createState() => _EmployeeSeekerScreenState();
}

class _EmployeeSeekerScreenState extends State<EmployeeSeekerScreen> {
  String _userID;
  String _documents = 'users';
  String _nama;

  void initState() {
    getID();
    _getCurrentLocation();
    super.initState();
  }

  int _selectedIndex = 0;

  List<Widget> get _widgetOptions => [
        // FindEmployeeScreen(),
        WelcomeES(),
        JobsData(
          userID: _userID,
        )
      ];
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _email == null ? 'Email' : _email,
                      style: TextStyle(color: Colors.white),
                    ),
                  )
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(
              'Cari Pekerja',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center),
            title: Text('Lowongan Kerja',
                style: TextStyle(fontWeight: FontWeight.bold)),
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
      _email = user.email;
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
  List<Placemark> newPlace = await geolocator.placemarkFromCoordinates(lat, long);
  Placemark placeMark  = newPlace[0]; 
  setState(() {
    lokasi = placeMark.name;
    kota = placeMark.locality;
  });
  }
}



class WelcomeES extends StatelessWidget {
  var user = FirebaseAuth.instance.currentUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(
                    child: ListTile(
                      trailing: Icon(Icons.location_on),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Lokasi saat ini:'),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(lokasi==null?'Loading..':lokasi+' , '+kota),
                      ),
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
                    title: 'Pekerja Part Time Terdekat',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
