import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/utils/global.dart';

class ResetPassword extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _email, errorMessage;
  @override
  Widget build(BuildContext context) {
    void resetPassword(String email) async {
      if (_formKey.currentState.validate()) {
        _formKey.currentState.save();
        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
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
          EdgeAlert.show(context,
              title: 'Error',
              description: errorMessage,
              gravity: EdgeAlert.TOP,
              icon: Icons.close,
              backgroundColor: errColor);
        }
        EdgeAlert.show(context,
            title: 'Sukses',
            description: 'Email reset password berhasil terkirim',
            gravity: EdgeAlert.TOP,
            icon: Icons.check_circle,
            backgroundColor: secColor);
      }
    }

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
                    onPress: () {
                      resetPassword(_email);
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
