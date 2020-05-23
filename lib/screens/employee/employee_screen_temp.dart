import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/settings.dart';
import 'package:haverjob/screens/jobs/applied_job.dart';
import 'package:haverjob/screens/jobs/find_jobs.dart';
import 'package:haverjob/utils/global.dart';

class EmployeeScreenTemp extends StatefulWidget {
  @override
  _EmployeeScreenTempState createState() => _EmployeeScreenTempState();
}

class _EmployeeScreenTempState extends State<EmployeeScreenTemp> {
  String _userID;

  void initState() {
    getID();
    super.initState();
  }

  getID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      _userID = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(activeColor: secColor, items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              title: Text(
                "Cari Lowongan",
                style: poppins,
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              title: Text("Lamaran Kerja", style: poppins)),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text("Akun", style: poppins))
        ]),
        tabBuilder: (context, index) {
          switch (index) {
            case 0:
              return FindJob();
              break;
            case 1:
              return AppliedJobs(
                userID: _userID,
              );
              break;
            case 2:
              return Accounts(type: 'employee',);
              break;
            // case 2:
            //   return ThirdPage();
            //   break;
            default:
              return FindJob();
              break;
          }
        });
  }
}
