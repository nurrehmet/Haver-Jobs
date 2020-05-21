import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/utils/global.dart';

class ResetPassword extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _email;
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
      body: Column(
        children: <Widget>[
          Heading(
            title: 'Reset password anda',
            subtitle:
                'Anda akan mendapatkan petunjuk mengenai perubahan password melalui email yang anda masukan.',
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                new TextFields(
                  labelText: 'Email',
                  iconData: Icons.email,
                  obscureText: false,
                  onSaved: (input) => _email = input,
                  textInputType: TextInputType.emailAddress,
                ),
                new RoundedButton(
                  text: 'Reset Password',
                  color: secColor,
                  onPress: (){
                    resetPassword(_email);
                  }
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Future<void> resetPassword(String email) async {
    if (_formKey.currentState.validate()) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    }
  }
}
