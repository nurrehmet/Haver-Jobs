import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/screens/home.dart';
import 'package:haverjob/services/authentication_service.dart';

class LoginScreen extends StatefulWidget {
  static final id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;
  bool showCircular = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            showCircular
                ? Center(child: CircularProgressIndicator())
                : SizedBox(),
            Text(
              'Haver Jobs',
              style: TextStyle(fontFamily: 'Product Sans', fontSize: 50.0),
            ),
            SizedBox(
              height: 27.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                          ),
                          prefixIcon: Icon(Icons.email),
                          fillColor: Colors.grey,
                          labelText: 'Email',
                          labelStyle: TextStyle(fontFamily: 'Product Sans')),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!value.contains('@') || (!value.contains('.com')))
                          return 'Masukan format Email yang valid';
                        return null;
                      },
                      onSaved: (input) => _email = input,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(fontFamily: 'Product Sans'),
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length < 6) {
                          return 'Password harus berjumlah 6 karakter';
                        }
                        return null;
                      },
                      onSaved: (input) => _password = input,
                      obscureText: true,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: 250.0,
                    child: FlatButton(
                      onPressed: signIn,
                      padding: EdgeInsets.all(10.0),
                      color: Colors.blue,
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: 250.0,
                    child: FlatButton(
                      onPressed: () =>
                          {Navigator.pushNamed(context, "/register")},
                      padding: EdgeInsets.all(10.0),
                      color: Colors.blue,
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
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
        print(e);
      }
    }
  }
}
