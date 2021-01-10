import 'package:flutter/material.dart';
import 'package:haverjob/screens/jobs/job_list.dart';
import 'package:haverjob/screens/jobs/jobs_category.dart';
import 'package:haverjob/utils/global.dart';

class FindJob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          centerTitle: true,
          backgroundColor: mainColor,
          title: Text("HaverJobs"),
        ),
        backgroundColor: Colors.grey[200],
        body: JobList(),
      ),
    );
  }
}
