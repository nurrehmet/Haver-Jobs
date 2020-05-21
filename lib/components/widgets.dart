import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/screens/welcome_screen.dart';
import 'package:haverjob/utils/global.dart';

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
            borderRadius: new BorderRadius.circular(25.0),
          ),
          onPressed: onPress,
          padding: EdgeInsets.all(10.0),
          color: color,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 14,fontWeight: bold),
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
  final String value;
  TextFields({
    this.labelText,
    this.iconData,
    this.onSaved,
    this.obscureText,
    this.textInputType,
    this.value,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        initialValue: value,
        keyboardType: textInputType,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide.none,
              //borderSide: const BorderSide(),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: Icon(iconData),
            hintText: labelText,
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

class PasswordField extends StatelessWidget {
  final String labelText;
  final IconData iconData;
  final Function onSaved;
  final bool obscureText;
  final TextInputType textInputType;
  final String value;
  PasswordField({
    this.labelText,
    this.iconData,
    this.onSaved,
    this.obscureText,
    this.textInputType,
    this.value,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        initialValue: value,
        keyboardType: textInputType,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide.none,
              //borderSide: const BorderSide(),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: Icon(iconData),
            hintText: labelText,
            labelStyle: TextStyle(fontFamily: 'Product Sans')),
        validator: (value) {
          if (value.isEmpty) {
            return '$labelText tidak boleh kosong';
          }
          else if (value.length < 6) {
            return '$labelText minimal 6 karakter';
          }
          return null;
        },
        onSaved: onSaved,
        obscureText: obscureText,
      ),
    );
  }
}
class AgeField extends StatelessWidget {
  final String labelText;
  final IconData iconData;
  final Function onSaved;
  final bool obscureText;
  final TextInputType textInputType;
  final String value;
  AgeField({
    this.labelText,
    this.iconData,
    this.onSaved,
    this.obscureText,
    this.textInputType,
    this.value,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      child: TextFormField(
        initialValue: value,
        keyboardType: textInputType,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              // width: 0.0 produces a thin "hairline" border
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide.none,
              //borderSide: const BorderSide(),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: Icon(iconData),
            hintText: labelText,
            labelStyle: TextStyle(fontFamily: 'Product Sans')),
        validator: (value) {
          if (value.isEmpty) {
            return '$labelText tidak boleh kosong';
          }
          else if (value.length > 2 || int.parse(value) < 15) {
            return '$labelText tidak valid';
          }
          return null;
        },
        onSaved: onSaved,
        obscureText: obscureText,
      ),
    );
  }
}

