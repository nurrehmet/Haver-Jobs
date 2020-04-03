import 'package:flutter/material.dart';
import 'package:haverjob/components/widgets.dart';

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
                      color: Colors.white,
                      fontFamily: 'Product Sans',
                      fontSize: 50,),
                ),
                Text(
                  'Cari Lowongan Pekerjaan Part Time Terdekat',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Product Sans',
                      fontSize: 15,),
                ),
                Spacer(),
                new RoundedButton(
                  text: 'Login',
                  onPress: () => {Navigator.pushNamed(context, "/login")},
                  color: Colors.blue[900],
                ),
                new RoundedButton(
                  text: 'Register',
                  onPress: () => {Navigator.pushNamed(context, "/register")},
                  color: Colors.green,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
