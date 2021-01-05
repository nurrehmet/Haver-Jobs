import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/screens/home.dart';
import 'package:haverjob/screens/login_screen.dart';
import 'package:haverjob/services/authentication_service.dart';
import 'package:haverjob/utils/global.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            children: <Widget>[
              Spacer(),
              Spacer(),
              Spacer(),
              Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 350),
                    child: Container(
                      child: Image.asset('assets/images/bg-welcome-01.png'),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'HaverJobs',
                          style: TextStyle(
                              color: mainColor, fontWeight: bold, fontSize: 50),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Portal Lowongan Kerja Terbaru',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: RoundedButton(
                            text: 'Cari Lowongan Pekerjaan',
                            onPress: () {
                              Navigator.pushNamed(context, "/registerEmployee");
                            },
                            color: secColor,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                'Sudah mempunyai akun?',
                                style: TextStyle(fontWeight: bold),
                              ),
                            ),
                            InkWell(
                              child: Text('Masuk',
                                  style: TextStyle(
                                    color: secColor,
                                    decoration: TextDecoration.underline,
                                  )),
                              onTap: () =>
                                  {Navigator.pushNamed(context, "/login")},
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

void _roleModal(context) {
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 25.0, // soften the shadow
                spreadRadius: 5.0, //extend the shadow
                offset: Offset(
                  15.0, // Move to right 10  horizontally
                  15.0, // Move to bottom 10 Vertically
                ),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: new Wrap(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.maximize,
                      color: Colors.grey,
                      size: 48,
                    ),
                  ),
                ),
                Center(
                  child: new RoundedButton(
                    text: 'Akun Perusahaan',
                    color: mainColor,
                    onPress: () {
                      Navigator.pushNamed(context, "/registerES");
                    },
                  ),
                ),
                Center(
                  child: new RoundedButton(
                    text: 'Akun Pencari Kerja',
                    color: secColor,
                    onPress: () {
                      Navigator.pushNamed(context, "/registerEmployee");
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
