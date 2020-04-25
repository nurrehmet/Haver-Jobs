import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haverjob/screens/maps_view.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:haverjob/models/list_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Init firestore and geoFlutterFire

class FindEmployeeScreen extends StatefulWidget {
  @override
  _FindEmployeeScreenState createState() => _FindEmployeeScreenState();
}

class _FindEmployeeScreenState extends State<FindEmployeeScreen> {
  String _keahlian, _pendidikan, _gender, _kota, _jamKerja;
  String _myActivityResult;
  double _lat, _long;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _keahlian = '';
    _pendidikan = '';
    _gender = '';
    _myActivityResult = '';
  }

  _saveForm() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivityResult = _keahlian;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cari Karyawan',
          style: TextStyle(fontFamily: 'Product Sans'),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16),
                    child: DropDownFormField(
                      titleText: 'Keahlian',
                      hintText: 'Pilih Kategori Keahlian',
                      value: _keahlian,
                      onSaved: (value) {
                        setState(() {
                          _keahlian = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Kategori keahlian tidak boleh kosong';
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
                  Container(
                    padding: EdgeInsets.all(16),
                    child: DropDownFormField(
                      titleText: 'Pendidikan',
                      hintText: 'Pilih Kategori Pendidikan',
                      value: _pendidikan,
                      onSaved: (value) {
                        setState(() {
                          _pendidikan = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Kategori pendidikan tidak boleh kosong';
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
                    padding: EdgeInsets.all(16),
                    child: DropDownFormField(
                      titleText: 'Gender',
                      hintText: 'Pilih Gender',
                      value: _gender,
                      onSaved: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Kategori gender tidak boleh kosong';
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
                    padding: EdgeInsets.all(16),
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
                  Container(
                    padding: EdgeInsets.all(16),
                    child: DropDownFormField(
                      titleText: 'Jam Kerja',
                      hintText: 'Pilih Jam Kerja',
                      value: _jamKerja,
                      onSaved: (value) {
                        setState(() {
                          _jamKerja = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Jam kerja tidak boleh kosong';
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
                  new RoundedButton(
                    text: 'Cari Karyawan Part Time',
                    onPress: () {
                      var form = formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapsView(
                              gender: _gender,
                              keahlian: _keahlian,
                              pendidikan: _pendidikan,
                              kota: _kota,
                              jamKerja: _jamKerja,
                              lat: _lat,
                              long: _long,
                            ),
                          ),
                        );
                        setState(() {
                          _myActivityResult = _keahlian + _pendidikan + _gender;
                        });
                      }
                    },
                    color: Colors.blue
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(_myActivityResult),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //get user location
  Future<void> _getCurrentLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _lat = position.latitude;
        _long = position.longitude;
      });
      print(_lat);
      print(_long);
    }).catchError((e) {
      print(e);
    });
  }
}
