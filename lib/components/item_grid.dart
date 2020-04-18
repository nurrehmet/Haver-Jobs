import 'package:flutter/material.dart';

class ItemGrid extends StatelessWidget {
  String label,image;
  Function action;
  ItemGrid({@required this.label,this.action,this.image});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 110,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        highlightColor: Colors.blue.withOpacity(0.5),
        onTap: action,
        child: Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage(image),
                  height: 48,
                  width: 48,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5,),
                Text(label,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),)
              ],
            )),
      ),
    );
  }
}
