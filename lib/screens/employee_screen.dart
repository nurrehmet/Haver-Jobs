import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/profile.dart';
import 'package:haverjob/components/widgets.dart';

class EmployeeScreen extends StatefulWidget {
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
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
            'Cari Pekerjaan Widget',
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
            icon: Icon(Icons.business_center),
            title: Text('Cari Pekerjaan'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Akun'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue[900],
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