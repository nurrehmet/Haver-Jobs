import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Widgets extends StatelessWidget {
  final IconData titleIcon;
  final String tileTitle;
  final String tileSubtitle;

  Widgets({
    @required this.titleIcon,
    @required this.tileTitle,
    @required this.tileSubtitle,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                child: ListTile(
                  leading: Icon(titleIcon),
                  title: Text(tileTitle),
                  subtitle: Text(tileSubtitle),
                  trailing: FlatButton(
                    child: Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamed(context, "/login");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
