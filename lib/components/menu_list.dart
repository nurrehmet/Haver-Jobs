import 'package:flutter/material.dart';
import 'package:haverjob/screens/jobs/get_job_data.dart';
import 'package:haverjob/utils/global.dart';

class MenuList extends StatelessWidget {
  final String title;
  final String icon;
  final String provider;

  MenuList({this.title, this.icon, this.provider});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 50,
      child: InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  title:Text('Lowongan Pekerjaan ${title}')),
                body: SingleChildScrollView(child: GetJobData(provider: provider,)),),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 45,
              width: 45,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(icon),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              width: 50,
              height: 26,
              child: Text(
                "$title",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
