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
                          'Haver Jobs',
                          style: TextStyle(
                              color: mainColor, fontWeight: bold, fontSize: 30),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Icon(
                            Icons.near_me,
                            color: secColor,
                            size: 33,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Cari Lowongan Pekerjaan Terdekat',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: RoundedButton(
                            text: 'Daftar',
                            onPress: () {
                              _roleModal(context);
                            },
                            color: mainColor,
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
