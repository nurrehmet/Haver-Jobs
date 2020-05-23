import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haverjob/components/banner_card.dart';
import 'package:haverjob/components/profile_avatar.dart';
import 'package:haverjob/components/settings.dart';
import 'package:haverjob/models/list_data.dart';
import 'package:haverjob/screens/edit_data.dart';
import 'package:haverjob/screens/employee_seeker/job_screen.dart';
import 'package:haverjob/screens/employee_seeker/jobs_data.dart';
import 'package:haverjob/screens/jobs/job_list.dart';
import 'package:haverjob/screens/jobs/jobs_category.dart';
import 'package:haverjob/screens/maps_view.dart';
import 'package:haverjob/screens/welcome_screen.dart';
import 'package:haverjob/utils/global.dart';

double lat, long;
String lokasi, kota;
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

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(activeColor: secColor, items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              title: Text(
                "Cari Pekerja",
                style: poppins,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.note),
              title: Text("Daftar Pekerjaan", style: poppins)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text("Akun", style: poppins))
        ]),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return WelcomeES(
                lat1: lat,long1: long,
              );
              break;
            case 1:
              return JobsData(
                userID: _userID,
              );
              break;
            case 2:
              return Accounts(
                type: 'employee-seeker',
              );
              break;
            // case 2:
            //   return ThirdPage();
            //   break;
            default:
              return WelcomeES();
              break;
          }
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
    List<Placemark> newPlace =
        await geolocator.placemarkFromCoordinates(lat, long);
    Placemark placeMark = newPlace[0];
    setState(() {
      lokasi = placeMark.name;
      kota = placeMark.locality;
    });
  }
}

class WelcomeES extends StatelessWidget {
  double lat1,long1;
  WelcomeES({this.lat1,this.long1});
  var user = FirebaseAuth.instance.currentUser();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(
            color: secColor, //change your color here
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Logo(),
          bottom: TabBar(
            isScrollable: false,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: mainColor,
            indicatorColor: secColor,
            tabs: [
              Tab(
                text: 'Pekerja Terdekat',
              ),
              Tab(
                text: 'Kategori',
              ),
            ],
          ),
        ),
        backgroundColor: bgColor,
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
              child: MapsView(
                lat: lat1,
                long: long1,
                type: 'filter',
              ),
            ),
            JobsCategory(lat: lat,long: long,type: 'worker',)
          ],
        ),
      ),
    );
  }
}
