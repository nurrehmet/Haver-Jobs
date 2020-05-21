import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/screens/home.dart';
import 'package:haverjob/services/authentication_service.dart';
import 'package:haverjob/utils/global.dart';

class LoginScreen extends StatefulWidget {
  static final id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, errorMessage;
  bool showCircular = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: secColor, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Heading(
              title: 'Login ke Haver Jobs',
              subtitle:
                  'Dapatkan informasi mengenai pekerja part time terdekat.',
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new TextFields(
                    labelText: 'Email',
                    iconData: Icons.email,
                    onSaved: (input) => _email = input,
                    obscureText: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                  new PasswordField(
                    labelText: 'Password',
                    iconData: Icons.lock,
                    onSaved: (input) => _password = input,
                    obscureText: true,
                    textInputType: TextInputType.text,
                  ),
                  showCircular
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: CircularProgressIndicator(
                            backgroundColor: secColor,
                          )),
                        )
                      : SizedBox(),
                  new RoundedButton(
                      text: 'Login', onPress: signIn, color: secColor),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton.icon(
                        icon: Icon(
                          Icons.lock_outline,
                          color: secColor,
                        ),
                        label: Text(
                          'Lupa password anda?',
                          style: TextStyle(color: secColor, fontWeight: bold),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/resetPassword');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 203,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Dengan login ke dalam sistem anda setuju dengan Terms of Service dan Privacy Policy kami',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 12),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      FlatButton(child: Text('Privacy Policy'), onPressed: (){},),
                      FlatButton(child: Text('Terms of Service'),onPressed: (){},)
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        showCircular = true;
      });
      try {
        final user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        if (user != null) {
          final FirebaseUser user = await auth.currentUser();
          setState(() {
            showCircular = false;
          });
          print('success login');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(user: user),
              ));
        }
      } catch (e) {
        switch (e.code) {
          case "ERROR_INVALID_EMAIL":
            errorMessage = "Email yang anda masukan tidak valid.";
            break;
          case "ERROR_WRONG_PASSWORD":
            errorMessage = "Password yang anda masukan salah.";
            break;
          case "ERROR_USER_NOT_FOUND":
            errorMessage = "Pengguna tidak terdaftar dalam sistem.";
            break;
          case "ERROR_USER_DISABLED":
            errorMessage = "Pengguna telah dinonaktifkan.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "Server sibuk, mohon coba lagi.";
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            errorMessage = "Terjadi kesalahan sistem.";
            break;
          default:
            errorMessage = "Terjadi kesalahan sistem.";
        }
        setState(() {
          showCircular = false;
        });
        EdgeAlert.show(context,
            title: 'Error',
            description: errorMessage,
            gravity: EdgeAlert.TOP,
            icon: Icons.error,
            backgroundColor: Colors.red);
        print(e);
      }
    }
  }
}
