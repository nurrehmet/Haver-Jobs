import 'package:flutter/material.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:hexcolor/hexcolor.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Haver Jobs',
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/bg.png"), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Haver Jobs',
                  style: TextStyle(
                      color: Hexcolor('#112d4e'),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Product Sans',
                      fontSize: 50,),
                ),
                SizedBox(height: 10,),
                Text(
                  'Cari Lowongan Pekerjaan Part Time Terdekat',
                  style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Product Sans',
                      fontSize: 17,),
                ),
                Spacer(),
                new RoundedButton(
                  text: 'Login',
                  onPress: () => {Navigator.pushNamed(context, "/login")},
                  color: Hexcolor('#3f72af'),
                ),
                new RoundedButton(
                  text: 'Register',
                  onPress: () => {Navigator.pushNamed(context, "/register")},
                  color: Colors.green,
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
