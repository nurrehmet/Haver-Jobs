import 'package:flutter/material.dart';
import 'package:haverjob/models/list_data.dart';
import 'package:haverjob/screens/jobs/find_jobs.dart';
import 'package:haverjob/screens/jobs/job_list.dart';
import 'package:haverjob/screens/maps_view.dart';
import 'package:haverjob/utils/global.dart';

class JobsCategory extends StatefulWidget {
  String type,keahlian;
  double lat,long;
  JobsCategory({this.type,this.lat,this.long,this.keahlian});
  @override
  _JobsCategoryState createState() => _JobsCategoryState();
}

class _JobsCategoryState extends State<JobsCategory> {
  @override
  Widget build(BuildContext context) {
    List<String> keahlian = ListKeahlian.keahlianList;
    return Scaffold(
        backgroundColor: bgColor,
        body: ListView.separated(
            separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 1,
                  color: bgColor,
                ),
            itemCount: keahlian.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return Container(
                color: Colors.white,
                child: new ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => widget.type == 'worker'?MapsView(keahlian:keahlian[index],lat: widget.lat,long: widget.long,type: 'worker',): JobList(category: keahlian[index],),
                        ));
                  },
                  title: Text(keahlian[index]),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              );
            }));
  }
}
