import 'package:flutter/material.dart';
import 'package:haverjob/components/banner_card.dart';
import 'package:haverjob/screens/employee_seeker/create_jobs.dart';
import 'package:haverjob/screens/employee_seeker/jobs_data.dart';

class JobScreen extends StatefulWidget {
  String userID;
  JobScreen({this.userID});
  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  var jarak = SizedBox(
    height: 15,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Managemen Pekerjaan',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Ini merupakan halaman manajemen pekerjaan untuk menambah dan mengedit dan menghapus pekerjaan part time',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              BannerCard(
                title: 'Buat Lowongan Pekerjaan Part Time',
                subtitle:
                    'Buat lowongan pekerjaan part time dengan menggunakan kriteria tertentu, seperti lokasi, pendidikan, dan keahlian',
                color: Colors.green,
                btText: 'BUAT LOWONGAN KERJA',
                image: 'assets/images/update.png',
                action: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateJobs(userID: widget.userID,))),
              ),
              jarak,
              BannerCard(
                title: 'Atur Lowongan Pekerjaan Part Time',
                subtitle: 'Atur Lowongan Pekerjaan Yang Sudah Dibuat',
                color: Colors.blue,
                btText: 'ATUR LOWONGAN KERJA',
                image: 'assets/images/manage.png',
                action: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => JobsData(userID: widget.userID,))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
