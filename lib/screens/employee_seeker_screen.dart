import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/maps_view.dart';
import 'package:haverjob/components/setting_screen.dart';
import 'package:haverjob/components/widgets.dart';
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
        MapsView(),
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text('Cari Karyawan'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Pekerjaan'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Hexcolor('#112d4e'),
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
