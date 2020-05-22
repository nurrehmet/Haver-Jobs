import 'package:flutter/material.dart';

//colors
var mainColor = Color(0xff222831);
var secColor = Colors.green[700];
var subTextColor = Colors.grey;
var errColor = Colors.red[900];
var bgColor = Colors.grey[200];
//text
var styleBold = TextStyle(fontWeight: FontWeight.bold);
var styleFade = TextStyle(color: subTextColor);
var bold = FontWeight.bold;
var poppins = TextStyle(fontFamily: 'Poppins');
//key
var formKey = GlobalKey<FormState>();

//texts
class Heading extends StatelessWidget {
  String title, subtitle;
  Heading({this.title, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontWeight: bold, fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(subtitle),
          )
        ],
      ),
    );
  }
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Text(
              'Haver Jobs',
              style: TextStyle(color:mainColor,fontWeight: bold, fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Icon(
              Icons.maximize,
              color: secColor,
              size:25,
            ),
          ),
        ],
      ),
    );
  }
}
