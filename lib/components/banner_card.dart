import 'package:flutter/material.dart';

class BannerCard extends StatelessWidget {
  String title, subtitle, btText, image;
  Function action;
  BannerCard(
      {@required this.title,
      this.subtitle,
      this.btText,
      this.image,
      this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.blue,
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
                    subtitle: Text(subtitle),
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
        elevation: 5,
      ),
    );
  }
}
