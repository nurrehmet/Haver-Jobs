import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/models/list_data.dart';
import 'package:haverjob/screens/admin/admin_screen.dart';
import 'package:place_picker/place_picker.dart';

class CreateES extends StatefulWidget {
  @override
  _CreateESState createState() => _CreateESState();
}

class _CreateESState extends State<CreateES> {
  final _formKey = GlobalKey<FormState>();
  //data ES
  String _nama, _email, _password, _alamat, _noHp, _kategoriPerusahaan, _kota;
  String userID;
  //data lokasi
  double _lat, _long;
  bool showCircular = false;
  Geoflutterfire geo = Geoflutterfire();
  Firestore _firestore = Firestore.instance;
  GeoFirePoint myLocation;
  FirebaseAuth mauth1;
  FirebaseAuth mauth2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Employee Seeker Baru'),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                    new TextFields(
                      labelText: 'Password',
                      iconData: Icons.lock,
                      onSaved: (input) => _password = input,
                      obscureText: true,
                      textInputType: TextInputType.text,
                    ),
                    new TextFields(
                      labelText: 'No Handphone',
                      iconData: Icons.phone,
                      onSaved: (input) => _noHp = input,
                      obscureText: false,
                      textInputType: TextInputType.number,
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
                            text: 'Pilih Lokasi User',
                            onPress: showPlacePicker,
                            color: Colors.green),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              _alamat == null
                                  ? 'Lokasi belum dipilih'
                                  : 'Lokasi User: $_alamat',
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
                    new RoundedButton(
                      text: 'Registrasi',
                      onPress: _submitES,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              )
            ],
          ),
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
          userID = user.uid;
        });
        _registerES();
        
      } catch (e) {
        print(e.message);
      }
      
    }
  }

  //registrasi employee seeker
  Future<void> _registerES() async {
    Firestore.instance.collection("employee-seeker").document(userID).setData({
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
    _firestore.collection('users').document(userID).setData(
      {
        'nama': _nama,
        'email': _email,
        'role': 'employee seeker',
        'alamat': _alamat,
        'lat': _lat,
        'long': _long
      },
    );
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => AdminScreen()));
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
}
