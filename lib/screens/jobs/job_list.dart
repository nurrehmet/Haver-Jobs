import 'dart:convert';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:haverjob/components/menu_list.dart';
import 'package:haverjob/screens/employee_seeker/jobs_data.dart';
import 'package:haverjob/screens/jobs/get_job_data.dart';
import 'package:haverjob/screens/jobs/jobs_carousel.dart';
import 'package:haverjob/utils/ad_manager.dart';
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
    AdmobInterstitial interstitialAd;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.category == null
          ? null
          : (AppBar(
              title: Text(
                'Lowongan ${widget.category}',
                style: TextStyle(
                    color: Colors.white, fontWeight: bold, fontSize: 22),
              ),
              iconTheme: IconThemeData(
                color: secColor, //change your color here
              ),
              elevation: 0,
              backgroundColor: mainColor,
            )),
      backgroundColor: bgColor,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            //  JobsCarousel(),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MenuList(
                  title: 'BUMN',
                  icon: "https://img.icons8.com/fluent/96/000000/museum.png",
                  provider: 'bumn',
                ),
                MenuList(
                  title: 'CPNS',
                  icon:
                      "https://img.icons8.com/fluent/96/000000/department.png",
                  provider: 'instansi',
                ),
                MenuList(
                  title: 'Medis',
                  icon: "https://img.icons8.com/color/96/000000/hospital-3.png",
                  provider: 'medis',
                ),
                MenuList(
                  title: 'Migas',
                  icon:
                      "https://img.icons8.com/color/96/000000/oil-pump-jack.png",
                  provider: 'migas',
                ),
                MenuList(
                  title: 'Mining',
                  icon: "https://img.icons8.com/color/96/000000/digger.png",
                  provider: 'mining',
                ),
                MenuList(
                  title: 'Manufaktur',
                  icon:
                      "https://img.icons8.com/color/96/000000/factory-breakdown.png",
                  provider: 'manufaktur',
                ),
              ],
            ),
            AdmobBanner(adSize: AdmobBannerSize.LARGE_BANNER,adUnitId: AdManager.bannerAdUnitId,),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    color: secColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Mohon simpan lowongan yang anda inginkan, karena data akan update setiap hari nya",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
            ),
            GetJobData(provider: "disnakerja")
          ],
        ),
      ),
    );
  }
}
