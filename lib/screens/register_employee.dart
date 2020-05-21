import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/models/list_data.dart';
import 'package:haverjob/screens/home.dart';
import 'package:haverjob/utils/global.dart';
import 'package:place_picker/place_picker.dart';

final _formKeyEmployee = GlobalKey<FormState>();
String userId, _kota, _alamat;
//data employee
String _nama, _email, _password, _noHp;
String _gender, _pendidikan, _usia, _jamKerja, _keahlian, _gaji, _pengKerja;
//data lokasi
double _lat, _long;
bool showCircular = false;
Geoflutterfire geo = Geoflutterfire();
Firestore _firestore = Firestore.instance;
GeoFirePoint myLocation;

class RegisterEmployee extends StatefulWidget {
  @override
  _RegisterEmployeeState createState() => _RegisterEmployeeState();
}

class _RegisterEmployeeState extends State<RegisterEmployee> {
  //init state
  @override
  void initState() {
    _gender = '';
    _pendidikan = '';
    super.initState();
  }

  //get location
  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "AIzaSyDX1cPMy9zPG39wvwaDl85NJddg7SFNBEI",
            )));
    setState(() {
      _lat = result.latLng.latitude;
      _long = result.latLng.longitude;
      _alamat = result.formattedAddress;
      myLocation = geo.point(latitude: _lat, longitude: _long);
    });
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
            Form(
              key: _formKeyEmployee,
              child: Column(
                children: <Widget>[
                  Heading(
                    title: 'Daftar sebagai Employee',
                    subtitle:
                        'Sebagai Employee anda bisa mencari informasi lowongan pekerjaan part time.',
                  ),
                  new TextFields(
                      labelText: 'Nama Lengkap',
                      iconData: Icons.person,
                      onSaved: (input) => _nama = input,
                      obscureText: false,
                      textInputType: TextInputType.text),
                  new TextFields(
                      labelText: 'Email',
                      iconData: Icons.email,
                      onSaved: (input) => _email = input,
                      obscureText: false,
                      textInputType: TextInputType.emailAddress),
                  new PasswordField(
                      labelText: 'Password',
                      iconData: Icons.lock,
                      onSaved: (input) => _password = input,
                      obscureText: true,
                      textInputType: TextInputType.text),
                  new TextFields(
                      labelText: 'No Handphone / WhatsApp',
                      iconData: Icons.phone,
                      onSaved: (input) => _noHp = input,
                      obscureText: false,
                      textInputType: TextInputType.number),
                  new AgeField(
                      labelText: 'Usia',
                      iconData: Icons.date_range,
                      onSaved: (input) => _usia = input,
                      obscureText: false,
                      textInputType: TextInputType.number),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: DropDownFormField(
                      titleText: 'Gender',
                      hintText: 'Pilih Gender Anda',
                      value: _gender,
                      onSaved: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Gender tidak boleh kosong';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      dataSource: ListGender().getList(),
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: DropDownFormField(
                      titleText: 'Pendidikan Terakhir',
                      hintText: 'Pilih Pendidikan Terakhir',
                      value: _pendidikan,
                      onSaved: (value) {
                        setState(() {
                          _pendidikan = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Pendidikan Terakhir tidak boleh kosong';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _pendidikan = value;
                        });
                      },
                      dataSource: ListPendidikan().getList(),
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: DropDownFormField(
                      titleText: 'Kota',
                      hintText: 'Pilih Kota',
                      value: _kota,
                      onSaved: (value) {
                        setState(() {
                          _kota = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Kota tidak boleh kosong';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _kota = value;
                        });
                      },
                      dataSource: ListKota().getList(),
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  new RoundedButton(
                      text: 'Pilih Lokasi Anda',
                      onPress: showPlacePicker,
                      color: mainColor),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        _alamat == null
                            ? 'Lokasi belum dipilih'
                            : 'Lokasi Anda: $_alamat',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: DropDownFormField(
                      titleText: 'Jam Kerja',
                      hintText: 'Pilih Jam Kerja Anda',
                      value: _jamKerja,
                      onSaved: (value) {
                        setState(() {
                          _jamKerja = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Jam Kerja tidak boleh kosong';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _jamKerja = value;
                        });
                      },
                      dataSource: ListJamKerja().getList(),
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: DropDownFormField(
                      titleText: 'Keahlian',
                      hintText: 'Pilih Keahlian Anda',
                      value: _keahlian,
                      onSaved: (value) {
                        setState(() {
                          _keahlian = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Keahlian tidak boleh kosong';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _keahlian = value;
                        });
                      },
                      dataSource: ListKeahlian().getList(),
                      textField: 'display',
                      valueField: 'value',
                    ),
                  ),
                  TextFields(
                      labelText: 'Gaji per Jam (Rp)',
                      iconData: Icons.attach_money,
                      onSaved: (input) => _gaji = input,
                      obscureText: false,
                      textInputType: TextInputType.number),
                  new TextFields(
                      labelText: 'Pengalaman Kerja',
                      iconData: Icons.history,
                      onSaved: (input) => _pengKerja = input,
                      obscureText: false,
                      textInputType: TextInputType.text),
                  showCircular
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(),
                  new RoundedButton(
                      text: 'Registrasi',
                      onPress: _submitEmployee,
                      color: secColor),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //submit employee
  Future<void> _submitEmployee() async {
    if (_formKeyEmployee.currentState.validate()) {
      _formKeyEmployee.currentState.save();
      setState(() {
        showCircular = true;
      });
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        final FirebaseUser user = await FirebaseAuth.instance.currentUser();
        setState(() {
          userId = user.uid;
        });
        _registerEmployee();
      } catch (e) {
        print(e.message);
      }
    }
  }

  //registrasi employee
  Future<void> _registerEmployee() async {
    var id = '[]';
    var appliedJob = json.decode(id);
    String _gajiFormat = _gaji.replaceAll(',', '');
    Firestore.instance.collection("employee").document(userId).setData({
      'nama': _nama,
      'email': _email,
      'role': 'employee',
      'alamat': _alamat,
      'usia': _usia,
      'pendidikan': _pendidikan,
      'jamKerja': _jamKerja,
      'noHp': _noHp,
      'gender': _gender,
      'keahlian': _keahlian,
      'gaji': _gajiFormat.replaceAll('.', ''),
      'kota': _kota,
      'latitude': _lat,
      'longitude': _long,
      'position': myLocation.data,
      'statusKerja': true,
      'pengKerja': _pengKerja,
      'appliedJob': appliedJob
    });
    _firestore.collection('users').document(userId).setData(
      {
        'nama': _nama,
        'email': _email,
        'role': 'employee',
        'alamat': _alamat,
        'lat': _lat,
        'long': _long,
        'password': _password
      },
    );
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home(user: user)));
  }
}
