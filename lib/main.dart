import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haverjob/components/upload_picture.dart';
import 'package:haverjob/models/users.dart';
import 'package:haverjob/screens/edit_data.dart';
import 'package:haverjob/screens/employee_seeker/find_employee_screen.dart';
import 'package:haverjob/screens/home.dart';
import 'package:haverjob/screens/login_screen.dart';
import 'package:haverjob/screens/signup_screen.dart';
import 'package:haverjob/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn;
  @override
  void initState() {
    checkUser();
    super.initState();

    // new Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons
      systemNavigationBarColor: Colors.black, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    ));
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blue,
          fontFamily: 'Poppins'
        ),
        debugShowCheckedModeBanner: false,
        title: 'Haver Jobs',
        home: MultiProvider(
          providers: [FutureProvider(create: (_) => Users().getUID()),],
          child: _getLandingPage()),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => LoginScreen(),
          '/register': (BuildContext context) => SignUpScreen(),
          '/home': (BuildContext context) => Home(),
          '/welcome': (BuildContext context) => WelcomeScreen(),
          '/findEmployee': (BuildContext context) => FindEmployeeScreen(),
          '/editEmployee': (BuildContext context) => EditData(),
          '/uploadPicture': (BuildContext context) => UploadPicture(),
        },
      
    );
  }

  Widget _getLandingPage() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.providerData.length == 1) {
            // logged in using email and password
            return snapshot.data.isEmailVerified
                ? WelcomeScreen()
                : Home(user: snapshot.data);
          } else {
            // logged in using other providers
            return Home(user: snapshot.data);
          }
        } else {
          return WelcomeScreen();
        }
      },
    );
  }

  Future<void> checkUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
    print(isLoggedIn);
  }
}
