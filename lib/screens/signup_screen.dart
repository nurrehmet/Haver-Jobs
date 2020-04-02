import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/models/kategori_perusahaan.dart';
import 'package:haverjob/screens/login_screen.dart';
import 'package:place_picker/place_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home.dart';

class SignUpScreen extends StatefulWidget {
  static final id = 'signup_screen';
  final FirebaseUser user;
  const SignUpScreen({Key key, this.user}) : super(key: key);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String userId;
  //data employee seeker
  String _nama, _email, _password, _alamat, _noHp, _kategoriPerusahaan, _lokasi;
  //data employee
  String _namaEmployee,
      _gender,
      _pendidikan,
      _tglLahir,
      _pengKerja,
      _hariKerja,
      _gaji;
  double _lat, _long;
  bool showCircular = false;

  //get location
  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyDX1cPMy9zPG39wvwaDl85NJddg7SFNBEI")));
    setState(() {
      _lat = result.latLng.latitude;
      _long = result.latLng.longitude;
      _lokasi = result.formattedAddress;
      _alamat = _lokasi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.blue[900],
              title: Text('Registrasi Akun'),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.search),
                    text: 'Employee Seeker',
                  ),
                  Tab(
                    icon: Icon(Icons.people),
                    text: 'Employee',
                  )
                ],
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              )),
          body: TabBarView(
            children: <Widget>[
              _registerEmployeeSeeker(context),
              _registrasiEmployee(context)
            ],
          ),
        ),
      ),
    );
  }

  //form registrasi employee
  Widget _registrasiEmployee(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          new TextFields(
              labelText: 'Nama',
              iconData: Icons.person,
              onSaved: (input) => _nama = input,
              obscureText: false,
              textInputType: TextInputType.text),
          new RoundedButton(
              text: 'Test Button', onPress: _submitES, color: Colors.blue[900])
        ],
      ),
    );
  }

  //dropdown listener
  List<KategoriPerusahaan> _dataKategoriPerusahaan =
      KategoriPerusahaan.getKategoriPerusahaan();
  List<DropdownMenuItem<KategoriPerusahaan>> _dropdownMenuItems;
  KategoriPerusahaan _selectedKategoriPerusahaan;
  //init state
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_dataKategoriPerusahaan);
    _selectedKategoriPerusahaan = _dropdownMenuItems[0].value;
    _lokasi = 'Belum dipilih';
    super.initState();
  }

  List<DropdownMenuItem<KategoriPerusahaan>> buildDropdownMenuItems(
      List kategoris) {
    List<DropdownMenuItem<KategoriPerusahaan>> items = List();
    for (KategoriPerusahaan kategori in kategoris) {
      items.add(DropdownMenuItem(
        value: kategori,
        child: Text(kategori.name),
      ));
    }
    return items;
  }

  onChangedDropdownItem(KategoriPerusahaan selectedKategoriPerusahaan) {
    setState(() {
      _selectedKategoriPerusahaan = selectedKategoriPerusahaan;
      _kategoriPerusahaan = selectedKategoriPerusahaan.name;
    });
  }

  //form registrasi employee seeker
  Widget _registerEmployeeSeeker(BuildContext context) {
    return Container(
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
                    onSaved: (input) => _password = input,
                    obscureText: false,
                    textInputType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Pilih Kategori Perusahaan',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                  fontFamily: 'Product Sans'),
                            )),
                        SizedBox(
                          height: 20.0,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: DropdownButton(
                            value: _selectedKategoriPerusahaan,
                            items: _dropdownMenuItems,
                            onChanged: (onChangedDropdownItem),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Pilih Lokasi Anda',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                  fontFamily: 'Product Sans'),
                            ),
                            Spacer(),
                            FlatButton.icon(
                              icon: Icon(
                                Icons.location_searching,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showPlacePicker();
                              },
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.all(10.0),
                              color: Colors.lightGreen,
                              label: Text(
                                'Pilih Lokasi',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Lokasi anda adalah: $_lokasi',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  showCircular
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(),
                  new RoundedButton(
                    text: 'Registrasi',
                    onPress: _submitES,
                    color: Colors.blue[900],
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
    );
  }

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
        // Navigator.pushReplacement(
        //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } catch (e) {
        print(e.message);
      }
    }
  }

  Future<void> _registerES() async {
    Firestore.instance.collection("users").document(userId).setData({
      'nama': _nama,
      'email': _email,
      'role': 'employee seeker',
      'alamat': _alamat,
      'noHp': _noHp,
      'kategoriPerusahaan': _kategoriPerusahaan,
      'latitude': _lat,
      'longitude': _long
    });
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home(user: user)));
  }
}
