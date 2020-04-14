import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:haverjob/components/maps_view.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Init firestore and geoFlutterFire

class FindEmployeeScreen extends StatefulWidget {
  @override
  _FindEmployeeScreenState createState() => _FindEmployeeScreenState();
}

class _FindEmployeeScreenState extends State<FindEmployeeScreen> {
  String _keahlian, _pendidikan, _gender;
  String _myActivityResult;
  double _lat,_long;
  List _listKeahlian = [
    {
      "display": "Barista",
      "value": "Barista",
    },
    {
      "display": "Programmer",
      "value": "Programmer",
    },
    {
      "display": "Waiter",
      "value": "Waiter",
    },
    {
      "display": "Penyiar Radio",
      "value": "Penyiar Radio",
    },
    {
      "display": "Guru Les Privat",
      "value": "Guru Les Privat",
    },
    {
      "display": "Penulis Lepas",
      "value": "Penulis Lepas",
    },
  ];
  List _listPendidikan = [
    {
      "display": "SMA",
      "value": "SMA",
    },
    {
      "display": "D3",
      "value": "D3",
    },
    {
      "display": "S1",
      "value": "S1",
    }
  ];
  List _listGender = [
    {
      "display": "Laki-Laki",
      "value": "Laki-Laki",
    },
    {
      "display": "Perempuan",
      "value": "Perempuan",
    },
  ];
  List _listQuery = [];
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
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: formKey,
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: DropDownFormField(
                    titleText: 'Keahlian',
                    hintText: 'Pilih kategori keahlian',
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
                    dataSource: _listKeahlian,
                    textField: 'display',
                    valueField: 'value',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: DropDownFormField(
                  titleText: 'Pendidikan',
                  hintText: 'Pilih kategori pendidikan',
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
                  dataSource: _listPendidikan,
                  textField: 'display',
                  valueField: 'value',
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: DropDownFormField(
                  titleText: 'Gender',
                  hintText: 'Pilih gender',
                  value: _gender,
                  onSaved: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                      _listQuery = [_gender,_keahlian,_pendidikan];
                    });
                  },
                  dataSource: _listGender,
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
                          lat: _lat,
                          long: _long,
                          listQuery: _listQuery,
                        ),
                      ),
                    );
                    setState(() {
                      _myActivityResult = _keahlian + _pendidikan + _gender;
                    });
                  }
                },
                color: Hexcolor('#3f72af'),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Text(_myActivityResult),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
