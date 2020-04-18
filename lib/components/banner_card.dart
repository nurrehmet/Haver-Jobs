import 'package:flutter/material.dart';

class BannerCard extends StatelessWidget {
  String title, subtitle, btText, image;
  Color color;
  Function action;
  BannerCard(
      {@required this.title,
      this.subtitle,
      this.btText,
      this.image,
      this.action,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: color,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage(image),
              width: 300,
              height: 200,
              fit: BoxFit.cover,
            ),
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    title: Text(title,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    subtitle: Text(subtitle,style: TextStyle(color: Colors.grey),),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          btText,
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        onPressed: action,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 1,
      ),
    );
  }
}
