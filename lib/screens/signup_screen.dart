import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/components/upload_picture.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:haverjob/models/list_data.dart';
import 'package:place_picker/place_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
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
  final _formKeyEmployee = GlobalKey<FormState>();
  String userId, _kota;
  //data employee seeker
  String _nama, _email, _password, _alamat, _noHp, _kategoriPerusahaan;
  //data employee
  String _gender, _pendidikan, _usia, _jamKerja, _keahlian, _gaji,_pengKerja;
  //data lokasi
  double _lat, _long;
  bool showCircular = false;
  Geoflutterfire geo = Geoflutterfire();
  Firestore _firestore = Firestore.instance;
  GeoFirePoint myLocation;

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue, fontFamily: 'Poppins'),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FlatButton.icon(
                    icon: Icon(Icons.info, color: Colors.white),
                    textColor: Colors.white,
                    label: Text('Informasi'),
                    onPressed: _infoRegistrasi,
                  ),
                )
              ],
              title: Text(
                'Registrasi Akun',
              ),
              bottom: TabBar(
                tabs: <Widget>[
                  Tab(
                    icon: Icon(
                      Icons.search,
                    ),
                    text: 'Employee Seeker',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.people,
                    ),
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
                          color: Colors.green),
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
                                color: Colors.grey, fontFamily: 'Product Sans'),
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
    );
  }

  //form registrasi employee
  Widget _registrasiEmployee(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Form(
          key: _formKeyEmployee,
          child: Column(
            children: <Widget>[
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
              new TextFields(
                  labelText: 'Password',
                  iconData: Icons.lock,
                  onSaved: (input) => _password = input,
                  obscureText: true,
                  textInputType: TextInputType.text),
              new TextFields(
                  labelText: 'No Handphone',
                  iconData: Icons.phone,
                  onSaved: (input) => _noHp = input,
                  obscureText: false,
                  textInputType: TextInputType.number),
              new TextFields(
                  labelText: 'Usia',
                  iconData: Icons.date_range,
                  onSaved: (input) => _usia = input,
                  obscureText: false,
                  textInputType: TextInputType.number),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: DropDownFormField(
                  titleText: 'Gender',
                  hintText: 'Pilih Gender Anda',
                  value: _gender,
                  onSaved: (value) {
                    setState(() {
                      _gender = value;
                    });
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
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: DropDownFormField(
                  titleText: 'Pendidikan Terakhir',
                  hintText: 'Pilih Pendidikan Terakhir',
                  value: _pendidikan,
                  onSaved: (value) {
                    setState(() {
                      _pendidikan = value;
                    });
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
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
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
                  text: 'Pilih Lokasi Anda',
                  onPress: showPlacePicker,
                  color: Colors.green),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _alamat == null
                        ? 'Lokasi belum dipilih'
                        : 'Lokasi Anda: $_alamat',
                    style: TextStyle(
                        color: Colors.grey, fontFamily: 'Product Sans'),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: DropDownFormField(
                  titleText: 'Jam Kerja',
                  hintText: 'Pilih Jam Kerja Anda',
                  value: _jamKerja,
                  onSaved: (value) {
                    setState(() {
                      _jamKerja = value;
                    });
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
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: DropDownFormField(
                  titleText: 'Keahlian',
                  hintText: 'Pilih Keahlian Anda',
                  value: _keahlian,
                  onSaved: (value) {
                    setState(() {
                      _keahlian = value;
                    });
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
              new TextFields(
                  labelText: 'Gaji per Jam (Tanpa Koma/Titik)',
                  iconData: Icons.attach_money,
                  onSaved: (input) => _gaji = input,
                  obscureText: false,
                  textInputType: TextInputType.number),
              new TextFields(
                  labelText: 'Pengalaman Kerja',
                  iconData: Icons.access_time,
                  onSaved: (input) => _pengKerja = input,
                  obscureText: false,
                  textInputType: TextInputType.text),
              showCircular
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(),
              new RoundedButton(
                  text: 'Registrasi', onPress: _cekInput, color: Colors.blue),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

//submit employee

  void _cekInput() {
    if (_pendidikan == null) {
      EdgeAlert.show(context,
          title: 'Error',
          description: 'Pendidikan Belum Dipilih',
          gravity: EdgeAlert.TOP,
          icon: Icons.error,
          backgroundColor: Colors.red);
    } else if (_gender == null) {
      EdgeAlert.show(context,
          title: 'Error',
          description: 'Gender Belum Dipilih',
          gravity: EdgeAlert.TOP,
          icon: Icons.error,
          backgroundColor: Colors.red);
    } else if (_alamat == null) {
      EdgeAlert.show(context,
          title: 'Error',
          description: 'Lokasi Belum Dipilih',
          gravity: EdgeAlert.TOP,
          icon: Icons.error,
          backgroundColor: Colors.red);
    } else if (_jamKerja == null) {
      EdgeAlert.show(context,
          title: 'Error',
          description: 'Jam Kerja Belum Dipilih',
          gravity: EdgeAlert.TOP,
          icon: Icons.error,
          backgroundColor: Colors.red);
    } else {
      _submitEmployee();
    }
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

//registrasi employee
  Future<void> _registerEmployee() async {
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
      'gaji': int.parse(_gaji),
      'kota': _kota,
      'latitude': _lat,
      'longitude': _long,
      'position': myLocation.data,
      'statusKerja': true,
      'pengKerja': _pengKerja
    });
    _firestore.collection('users').document(userId).setData(
      {
        'nama': _nama,
        'email': _email,
        'role': 'employee',
        'alamat': _alamat,
        'lat': _lat,
        'long': _long
      },
    );
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home(user: user)));
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
        'long': _long
      },
    );
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home(user: user)));
  }

  //informasi registrasi
  Future<void> _infoRegistrasi() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Informasi Registrasi'),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Employee Seeker adalah orang yang mencari karyawan pekerja paruh waktu'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Employee adalah calon karyawan kerja paruh waktu yang mencari lowongan pekerjaan'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('MENGERTI'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
