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
  String _email, _password;
  bool showCircular = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Login',style: TextStyle(fontFamily: 'Product Sans',)),
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
                    SizedBox(
                      height: 20.0,
                    ),
                    showCircular
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(),
                    new RoundedButton(
                        text: 'Login',
                        onPress: signIn,
                        color: Colors.blue[900]),
                    Row(children: <Widget>[
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Divider(color: Colors.grey, height: 36),
                      )),
                      Text(
                        'OR',
                        style: TextStyle(color: Colors.grey, fontFamily: 'Product Sans'),
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
        print(e);
      }
    }
  }
}
