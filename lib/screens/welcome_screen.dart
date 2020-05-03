import 'package:flutter/material.dart';
import 'package:haverjob/components/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Image(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/welcome.png'),
          ),
          Spacer(),
          Container(
            height: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 25.0, // soften the shadow
                  spreadRadius: 5.0, //extend the shadow
                  offset: Offset(
                    15.0, // Move to right 10  horizontally
                    15.0, // Move to bottom 10 Vertically
                  ),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Haver Jobs',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Haver Jobs adalah platform untuk mencari pekerja Part Time terdekat',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 20,
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
                  height: 15,
                ),
                Text('App Version 1.0.1',style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
