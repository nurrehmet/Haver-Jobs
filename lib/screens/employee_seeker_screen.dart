import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/profile.dart';
import 'package:haverjob/components/widgets.dart';

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
        Center(child: Text('Home Widget')),
        Center(
          child: Text(
            'Nearby Widget',
          ),
        ),
        Profile(),
      ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Beranda'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop),
            title: Text('Cari Karyawan'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Akun'),
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
