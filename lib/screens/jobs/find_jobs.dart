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
          iconTheme: IconThemeData(
            color: secColor, //change your color here
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Logo(),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: mainColor,
            indicatorColor: secColor,
            tabs: [
              Tab(
                text: 'Lowongan Terbaru',
              ),
              Tab(
                text: 'Kategori',
              ),
              // Tab(
              //   text: 'Kategori',
              // ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: TabBarView(
          children: [
            JobList(),
            JobsCategory()
          ],
        ),
      ),
    );
  }
}
