import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/widgets.dart';

class EmployeeSeekerScreen extends StatefulWidget {
  final FirebaseUser user;
  const EmployeeSeekerScreen({Key key, this.user}) : super(key: key);
  @override
  _EmployeeSeekerScreenState createState() => _EmployeeSeekerScreenState();

}

class _EmployeeSeekerScreenState extends State<EmployeeSeekerScreen> {
  int _selectedIndex = 0;
 final List<Widget> _widgetOptions = <Widget>[
    new userData(),
    // Widgets(
    //   tileTitle:  'title',
    //   titleIcon: Icons.account_circle,
    //   tileSubtitle: 'subtitle',
    // ),
    Text(
      'Index 1: Business',
    ),
    Text(
      'Index 2: School',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('Business'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('School'),
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
}

class userData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: Firestore.instance.collection('users').snapshots(),
       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.documents.map((document) {
            return new ListTile(
              title: new Text(document['nama']),
              subtitle: new Text(document['email']),
            );
          }).toList(),
        );
  }
    );
}
}