import 'package:flutter/material.dart';
import 'package:haverjob/components/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Haver Jobs',
      theme: ThemeData(fontFamily: 'Poppins'),
      home: Container(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Haver Jobs',
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Haver Jobs adalah platform untuk mencari pekerja Part Time terdekat',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                Image(
                  image: AssetImage('assets/images/welcome.png'),
                ),
                new RoundedButton(
                  text: 'Login',
                  onPress: () => {Navigator.pushNamed(context, "/login")},
                  color: Colors.blue,
                ),
                new RoundedButton(
                  text: 'Register',
                  onPress: () => {Navigator.pushNamed(context, "/register")},
                  color: Colors.green,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Beta Version 1.0.1',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
