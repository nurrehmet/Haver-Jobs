import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/models/list_data.dart';
import 'package:haverjob/models/users.dart';
import 'package:haverjob/screens/employee/employee_screen.dart';
import 'package:haverjob/screens/home.dart';
import 'package:haverjob/utils/global.dart';
import 'package:place_picker/place_picker.dart';

final _formKey = GlobalKey<FormState>();
String userId, _kota;
//data employee seeker
String _nama, _email, _password, _alamat, _noHp, _kategoriPerusahaan;
//data lokasi
double _lat, _long;
bool showCircular = false;
Geoflutterfire geo = Geoflutterfire();
Firestore _firestore = Firestore.instance;
GeoFirePoint myLocation;

class RegisterES extends StatefulWidget {
  @override
  _RegisterESState createState() => _RegisterESState();
}

class _RegisterESState extends State<RegisterES> {
  //init state
  @override
  void initState() {
    showCircular = false;
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
            Heading(
              title: 'Daftar sebagai Employee Seeker',
              subtitle:
                  'Sebagai Employee Seeker anda bisa mencari informasi karyawan pekerja part time terdekat.',
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new TextFields(
                    labelText: 'Nama Perusahaan',
                    iconData: Icons.business,
                    onSaved: (input) => _nama = input,
                    obscureText: false,
                    textInputType: TextInputType.text,
                  ),
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
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
                        child: DropDownFormField(
                          titleText: 'Kategori Perusahaan',
                          hintText: 'Pilih Kategori Perusahaan',
                          value: _kategoriPerusahaan,
                          onSaved: (value) {
                            setState(() {
                              _kategoriPerusahaan = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Kategori Perusahaan tidak boleh kosong';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _kategoriPerusahaan = value;
                            });
                          },
                          dataSource: ListKategoriPerusahaan().getList(),
                          textField: 'display',
                          valueField: 'value',
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 10.0),
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
                    ],
                  ),
                  showCircular
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: RoundedButton(
                      color: secColor,
                      text: 'Daftar',
                      onPress: _submitES,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //submit employee seeker
  Future<void> _submitES() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
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
        _registerES();
      } catch (e) {
        print(e.message);
      }
    }
  }

  //registrasi employee seeker
  Future<void> _registerES() async {
    Firestore.instance.collection("employee-seeker").document(userId).setData({
      'namaPerusahaan': _nama,
      'email': _email,
      'role': 'employee seeker',
      'alamat': _alamat,
      'noHp': _noHp,
      'kategoriPerusahaan': _kategoriPerusahaan,
      'latitude': _lat,
      'longitude': _long,
      'position': myLocation.data,
    });
    _firestore.collection('users').document(userId).setData(
      {
        'nama': _nama,
        'email': _email,
        'role': 'employee seeker',
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
