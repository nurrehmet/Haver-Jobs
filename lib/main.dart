import 'dart:async';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haverjob/components/upload_picture.dart';
import 'package:haverjob/screens/edit_data.dart';
import 'package:haverjob/screens/employee_seeker/find_employee_screen.dart';
import 'package:haverjob/screens/home.dart';
import 'package:haverjob/screens/login_screen.dart';
import 'package:haverjob/screens/register_employee.dart';
import 'package:haverjob/screens/register_es.dart';
import 'package:haverjob/screens/reset_password.dart';
import 'package:haverjob/screens/welcome_screen.dart';
import 'package:haverjob/utils/ad_manager.dart';
import 'package:haverjob/utils/global.dart';
import 'package:provider/provider.dart';

// void main() => runApp(
//   DevicePreview(
//     enabled: !kReleaseMode,
//     builder: (context) => MyApp(),
//   ),
// );
void main() {

  // OneSignal.shared
  //     .init("36ff5c9c-f8ab-4fcf-b862-992fc6aa8d4d", iOSSettings: null);
  // OneSignal.shared
  //     .setInFocusDisplayType(OSNotificationDisplayType.notification);
  Admob.initialize(AdManager.appId);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn;
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    // OneSignal.shared
    //     .setNotificationReceivedHandler((OSNotification notification) {
    //   // will be called whenever a notification is received
    // });

    // OneSignal.shared
    //     .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   // will be called whenever a notification is opened/button pressed.
    // });
    checkUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: mainColor, fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: analytics)],
      title: 'Haver Jobs',
      home: MultiProvider(providers: [
        StreamProvider<FirebaseUser>.value(
            value: FirebaseAuth.instance.onAuthStateChanged),
      ], child: _getLandingPage()),
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => LoginScreen(),
        '/home': (BuildContext context) => Home(),
        '/welcome': (BuildContext context) => WelcomeScreen(),
        '/findEmployee': (BuildContext context) => FindEmployeeScreen(),
        '/editEmployee': (BuildContext context) => EditData(),
        '/uploadPicture': (BuildContext context) => UploadPicture(),
        '/resetPassword': (BuildContext context) => ResetPassword(),
        '/registerES': (BuildContext context) => RegisterES(),
        '/registerEmployee': (BuildContext context) => RegisterEmployee(),
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
