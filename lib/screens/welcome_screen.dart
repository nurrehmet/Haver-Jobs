import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/screens/home.dart';
import 'package:haverjob/screens/login_screen.dart';
import 'package:haverjob/services/authentication_service.dart';
import 'package:haverjob/utils/global.dart';

import 'employee/employee_screen_temp.dart';
import 'jobs/find_jobs.dart';
import 'jobs/find_jobs.dart';
import 'jobs/find_jobs.dart';



class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
  
}

class _WelcomeScreenState extends State<WelcomeScreen> {
final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn = GoogleSignIn();

 Future<FirebaseUser> _handleSignIn() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final AuthResult result  = await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = result.user;
    print("signed in " + user.displayName);
    Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EmployeeScreenTemp()));
    return user;
    
  }

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
                          'HaverJobs',
                          style: TextStyle(
                              color: mainColor, fontWeight: bold, fontSize: 55),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Cari Lowongan Pekerjaan Terdekat',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50, bottom: 20),
                          child: _signInButton()
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                'Login menggunakan email',
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
  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        _handleSignIn();
       },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      highlightedBorderColor: Colors.grey,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png"), height: 15.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Masuk dengan akun Google',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}





