import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/functions/get_data.dart';
import 'package:haverjob/models/employee_seeker.dart';
import 'package:haverjob/models/list_data.dart';
import 'package:haverjob/screens/admin/create_jobs.dart';
import 'package:place_picker/place_picker.dart';
import 'package:random_string/random_string.dart';

class CreateJobs extends StatefulWidget {
  String userID;
  CreateJobs({this.userID});
  @override
  _CreateJobsState createState() => _CreateJobsState();
}

class _CreateJobsState extends State<CreateJobs> {
  final _formKey = GlobalKey<FormState>();
  void initState() {
    getData();
    super.initState();
  }

  //data pekerjaan
  String _judul,
      _kategoriPekerjaan,
      _gaji,
      _pendidikan,
      _keahlian,
      _gender,
      _jamKerja,
      _deskripsi,
      _lokasi,
      _kota,
      _namaPerusahaan,
      _emailPerusahaan;
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
        title: Text('Buat Lowongan Kerja'),
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
                      labelText: 'Judul Pekerjaan',
                      iconData: Icons.title,
                      onSaved: (input) => _judul = input,
                      obscureText: false,
                      textInputType: TextInputType.text,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                          color: Colors.grey[200],
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: (input) => _deskripsi = input,
                                maxLines: 5,
                                decoration: InputDecoration.collapsed(
                                    hintText: "Deskripsi Pekerjaan"),
                              ),
                            ),
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: DropDownFormField(
                        titleText: 'Kategori Pekerjaan',
                        hintText: 'Pilih Kategori Pekerjaan',
                        value: _kategoriPekerjaan,
                        onSaved: (value) {
                          setState(() {
                            _kategoriPekerjaan = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Kategori Pekerjaan tidak boleh kosong';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _kategoriPekerjaan = value;
                          });
                        },
                        dataSource: ListKeahlian().getList(),
                        textField: 'display',
                        valueField: 'value',
                      ),
                    ),
                    new TextFields(
                      labelText: 'Gaji per Jam',
                      iconData: Icons.attach_money,
                      onSaved: (input) => _gaji = input,
                      obscureText: false,
                      textInputType: TextInputType.number,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: DropDownFormField(
                        titleText: 'Jam Kerja',
                        hintText: 'Jam Kerja',
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: DropDownFormField(
                        titleText: 'Pendidikan Minimal',
                        hintText: 'Pilih Pendidikan Minimal',
                        value: _pendidikan,
                        onSaved: (value) {
                          setState(() {
                            _pendidikan = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Pendidikan Minimal tidak boleh kosong';
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: DropDownFormField(
                        titleText: 'Gender Yang Dibutuhkan',
                        hintText: 'Pilih Gender',
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
                        dataSource: ListGenderPekerjaan().getList(),
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
                        text: 'Tambahkan Lokasi Pekerjaan',
                        onPress: showPlacePicker,
                        color: Colors.green),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          _lokasi == null
                              ? 'Lokasi belum dipilih'
                              : 'Lokasi Anda: $_lokasi',
                          style: TextStyle(
                              color: Colors.grey, ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    showCircular
                        ? Center(child: CircularProgressIndicator())
                        : SizedBox(),
                    new RoundedButton(
                      text: 'Tambah Lowongan Kerja',
                      onPress: _submitJob,
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

  getData() {
    Firestore.instance
        .collection('employee-seeker')
        .document(widget.userID)
        .get()
        .then(
          (DocumentSnapshot) => setState(() {
            _namaPerusahaan = DocumentSnapshot.data['namaPerusahaan'];
            _emailPerusahaan = DocumentSnapshot.data['email'];
          }),
        );
  }

  //submit employee seeker
  Future<void> _submitJob() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        showCircular = true;
      });
      try {
        _createJob();
      } catch (e) {
        print(e.message);
      }
    }
  }

  //registrasi employee seeker
  Future<void> _createJob() async {
    String _gajiFormat = _gaji.replaceAll(',', '');
    Firestore.instance
        .collection('jobs')
        .document(randomAlphaNumeric(20))
        .setData({
      'creator': widget.userID,
      'namaPerusahaan': _namaPerusahaan,
      'emailPerusahaan': _emailPerusahaan,
      'createdAt': DateTime.now(),
      'judul': _judul,
      'kategoriPekerjaan': _kategoriPekerjaan,
      'gender': _gender,
      'jamKerja': _jamKerja,
      'gaji': _gajiFormat.replaceAll('.', ''),
      'pendidikan': _pendidikan,
      'kota':_kota,
      'deskripsi': _deskripsi,
      'lokasi': _lokasi,
      'latitude': _lat,
      'longitude': _long,
      'position': myLocation.data,
    });
    setState(() {
      showCircular = false;
    });
    EdgeAlert.show(context,
        title: 'Sukses',
        description: 'Pekerjaaan berhasil disimpan',
        gravity: EdgeAlert.TOP,
        icon: Icons.check_circle,
        backgroundColor: Colors.green);
    Navigator.pop(context);
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
      _lokasi = result.formattedAddress;
      myLocation = geo.point(latitude: _lat, longitude: _long);
    });
  }
}
