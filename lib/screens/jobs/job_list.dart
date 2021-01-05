import 'dart:convert';

import 'package:haverjob/screens/employee_seeker/jobs_data.dart';
import 'package:haverjob/screens/jobs/get_job_data.dart';
import 'package:haverjob/screens/jobs/jobs_carousel.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/screens/jobs/job_details.dart';
import 'package:haverjob/utils/global.dart';
import 'package:http/http.dart' as http;

class JobList extends StatefulWidget {
  String category;
  JobList({this.category});
  // Function to get the JSON data
  

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  final Firestore firestore = Firestore.instance;
  
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // this.getData();
    // controller.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.category == null
          ? null
          : (AppBar(
              title: Text(
                'Lowongan ${widget.category}',
                style:
                    TextStyle(color: Colors.white, fontWeight: bold, fontSize: 22),
              ),
              iconTheme: IconThemeData(
                color: secColor, //change your color here
              ),
              elevation: 0,
              backgroundColor: mainColor,
            )),
      backgroundColor: bgColor,
      body:  SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
             JobsCarousel(),
             GetJobData(provider:"disnakerja")
          ],
        ),
      ),
    );
  }
}
