import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileHead extends StatelessWidget {
  final IconData titleIcon;
  final String tileTitle;
  final String tileSubtitle;

  ProfileHead({
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
                      Navigator.pushNamed(context, "/welcome");
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
//example load data from firestore
class StreamData extends StatelessWidget {
  final String collection;
  final String document;

  StreamData({@required this.collection, @required this.document});
  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
        stream: Firestore.instance
            .collection(collection)
            .document(document)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return new Text("Loading");
          }
          var userDocument = snapshot.data;
          return new Text(userDocument['nama']);
        });
  }
}
//rounded button
class RoundedButton extends StatelessWidget {
  final String text;
  final Function onPress;
  final Color color;

  RoundedButton({@required this.text, @required this.onPress, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: FlatButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          onPressed: onPress,
          padding: EdgeInsets.all(10.0),
          color: color,
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
//textfields
class TextFields extends StatelessWidget {
  final String labelText;
  final IconData iconData;
  final Function onSaved;
  final bool obscureText;
  final TextInputType textInputType;

  TextFields(
      {@required this.labelText,
      this.iconData,
      this.onSaved,
      this.obscureText,
      this.textInputType});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        keyboardType: textInputType,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            prefixIcon: Icon(iconData),
            labelText: labelText,
            labelStyle: TextStyle(fontFamily: 'Product Sans')),
        validator: (value) {
          if (value.isEmpty) {
            return '$labelText tidak boleh kosong';
          }
          return null;
        },
        onSaved: onSaved,
        obscureText: obscureText,
      ),
    );
  }
}

