import 'package:flutter/material.dart';

//colors
var mainColor = Color(0xff222831);
var secColor = Colors.green[700];
var subTextColor = Colors.grey;
//text
var bold = FontWeight.bold;
//key
var formKey = GlobalKey<FormState>();
//heading
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
            child: Text(title,style: TextStyle(fontWeight: bold,fontSize: 30),),
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
