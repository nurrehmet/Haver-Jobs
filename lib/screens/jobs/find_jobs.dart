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
          title: Text("Cari Lowongan"),
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: mainColor,
            indicatorColor: secColor,
          
            tabs: [
              Tab(
                child: Text("Lowongan Terbaru",style: TextStyle(color: Colors.white),),
              ),
              Tab(
                child: Text("Kategori Pekerjaan",style: TextStyle(color: Colors.white),),
              ),
              // Tab(
              //   text: 'Kategori',
              // ),
            ],
          ),
        ),
        backgroundColor: Colors.grey[200],
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            JobList(),
            JobsCategory()
          ],
        ),
      ),
    );
  }
}
