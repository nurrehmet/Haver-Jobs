import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class UserData {
  String userid;

  getID() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userid = user.uid.toString();
    return userid;
  }
}
