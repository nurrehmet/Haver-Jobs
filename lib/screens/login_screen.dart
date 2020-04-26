import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/screens/home.dart';
import 'package:haverjob/services/authentication_service.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 27.0,
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
                    new TextFields(
                      labelText: 'Password',
                      iconData: Icons.lock,
                      onSaved: (input) => _password = input,
                      obscureText: true,
                      textInputType: TextInputType.text,
                    ),
                    showCircular
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : SizedBox(),
                    new RoundedButton(
                        text: 'Login', onPress: signIn, color: Colors.blue),
                    Row(children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Divider(color: Colors.grey, height: 36),
                      )),
                      Text(
                        'Belum punya akun?',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Divider(color: Colors.grey, height: 36),
                      )),
                    ]),
                    new RoundedButton(
                        text: 'Register',
                        onPress: () =>
                            {Navigator.pushNamed(context, "/register")},
                        color: Colors.green),
                  ],
                ),
              )
            ],
          ),
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
