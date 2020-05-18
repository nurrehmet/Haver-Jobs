import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/banner_card.dart';
import 'package:haverjob/components/details_account.dart';
import 'package:haverjob/components/item_grid.dart';
import 'package:haverjob/components/profile_avatar.dart';
import 'package:haverjob/components/status_kerja.dart';
import 'package:haverjob/functions/get_data.dart';
import 'package:haverjob/models/global.dart';
import 'package:haverjob/screens/edit_data.dart';
import 'package:haverjob/screens/employee/applied_job.dart';
import 'package:haverjob/screens/employee/job_list.dart';
import 'package:haverjob/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool _statusKerja = false;
String _userID, email;

class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  String _imageUrl;
  FirebaseUser currentUser;
  void initState() {
    getID();
    super.initState();
  }

  int _selectedIndex = 0;

  List<Widget> get _widgetOptions => [
        FindJob(),
        AppliedJobs(userID: _userID,)
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      email == null ? 'Email' : email,
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
      // body: FindJob(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text(
              'Cari Pekerjaan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            title: Text(
              'Lamaran Pekerjaan',
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
      email = user.email;
      var ref = FirebaseStorage.instance.ref().child('avatar/$_userID');
      ref.getDownloadURL().then((loc) => setState(() => _imageUrl = loc));
      print(_imageUrl);
    });
  }
}

class WelcomeEmployee extends StatefulWidget {
  String imageUrl;
  WelcomeEmployee({this.imageUrl});

  @override
  _WelcomeEmployeeState createState() => _WelcomeEmployeeState();
}

class _WelcomeEmployeeState extends State<WelcomeEmployee> {
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
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Selamat Datang',
                      style:
                          TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
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
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.amber,
                    elevation: 1,
                    child: ListTile(
                      leading: Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Tip of the day'),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'Tambahkan foto profil di menu Edit Data Diri, untuk membuat profilmu tampil meyakinkan'),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
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
                            builder: (context) => EditData(role: 'employee'),
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
    );
  }
}

class FindJob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: SingleChildScrollView(
                  child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Cari Lowongan Pekerjaan',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Cari lowongan pekerjaan part time dengan kategori keahlian tertentu',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 25,
              ),
             GridBanner(),
            ],
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
                    builder: (context) => JobsList(
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
                    builder: (context) => JobsList(
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
                    builder: (context) => JobsList(
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
                    builder: (context) => JobsList(
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
                    builder: (context) => JobsList(
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
                    builder: (context) => JobsList(
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
