import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/screens/edit_data.dart';
import 'package:haverjob/screens/home.dart';
import 'package:haverjob/screens/jobs/job_list.dart';
import 'package:haverjob/screens/welcome_screen.dart';
import 'package:haverjob/utils/global.dart';

class Accounts extends StatelessWidget {
  String type;
  Accounts({this.type});
  @override
  Widget build(BuildContext context) {
    List<String> listEmployee = ['Edit Data Diri', 'Upload CV', 'Logout'];
    List<String> listES = ['Edit Data Perusahaan', 'Logout'];
    List<Icon> listESIcon = [
      Icon(
        Icons.person_outline,
        color: secColor,
      ),
      Icon(Icons.exit_to_app, color: secColor)
    ];
    List<Icon> listEmployeeIcon = [
      Icon(
        Icons.person_outline,
        color: secColor,
      ),
      Icon(Icons.note_add, color: secColor),
      Icon(Icons.exit_to_app, color: secColor)
    ];
    List<Function> listEmployeeFunction = [
      () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditData(
              role: 'employee',
            ),
          )),
      () => null,
      () {
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      }
    ];
    List<Function> listESFunction = [
      () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditData(
              role: 'employee-seeker',
            ),
          )),
      () {
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      }
    ];
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'Akun',
            style: TextStyle(color: mainColor, fontWeight: bold, fontSize: 22),
          ),
        ),
        iconTheme: IconThemeData(
          color: secColor, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 1,
          color: bgColor,
        ),
        itemCount: type == 'employee' ? listEmployee.length : listES.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return Container(
            color: Colors.white,
            child: new ListTile(
              onTap: type == 'employee'
                  ? listEmployeeFunction[index]
                  : listESFunction[index],
              leading: type == 'employee'
                  ? listEmployeeIcon[index]
                  : listESIcon[index],
              title: Text(
                  type == 'employee' ? listEmployee[index] : listES[index]),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          );
        },
      ),
    );
  }
}
