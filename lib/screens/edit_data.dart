import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:haverjob/components/status_kerja.dart';
import 'package:haverjob/components/upload_picture.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/models/list_data.dart';
import 'package:haverjob/utils/global.dart';
import 'package:place_picker/place_picker.dart';
import 'package:edge_alert/edge_alert.dart';

//data employee seeker
String _kategoriPerusahaan;
//data employee
String _nama,
    _email,
    _password,
    _noHp,
    _gender,
    _pendidikan,
    _usia,
    _jamKerja,
    _keahlian,
    _gaji,
    _alamat,
    _kota,
    _pengKerja,
    _userID;
//temp data

final _formKey = GlobalKey<FormState>();
final _formKeyES = GlobalKey<FormState>();
//data lokasi
double _lat, _long;
bool showCircular = false;
Geoflutterfire geo = Geoflutterfire();
final databaseReference = Firestore.instance;
GeoFirePoint myLocation;

class EditData extends StatefulWidget {
  String role;
  EditData({this.role});
  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  void initState() {
    getID();
    super.initState();
    _gender = '';
    _pendidikan = '';
    _kota = '';
    _jamKerja = '';
    _keahlian = '';
    _kategoriPerusahaan = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Edit Data"),
        iconTheme: IconThemeData(
          color: secColor, //change your color here
        ),
        elevation: 0,
        backgroundColor: mainColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection(
                widget.role == 'employee' ? 'employee' : 'employee-seeker')
            .document(_userID)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            switch (widget.role) {
              case 'employee':
                return formEmployee(snapshot.data);
                break;
              case 'employee-seeker':
                return formES(snapshot.data);
                break;
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  formES(DocumentSnapshot snapshot) {
    return Container(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              new UploadPicture(
                userID: _userID,
              ),
              new TextFields(
                  labelText: 'Nama Perusahaan',
                  value: snapshot.data['namaPerusahaan'],
                  iconData: Icons.person,
                  onSaved: (input) => _nama = input,
                  obscureText: false,
                  textInputType: TextInputType.text),
              new TextFields(
                  value: snapshot.data['noHp'],
                  labelText: 'No Handphone',
                  iconData: Icons.phone,
                  onSaved: (input) => _noHp = input,
                  obscureText: false,
                  textInputType: TextInputType.number),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: DropDownFormField(
                  titleText: 'Kategori Perusahaan',
                  hintText: snapshot.data['kategoriPerusahaan'] == null
                      ? 'Kategori Perusahaan'
                      : snapshot.data['kategoriPerusahaan'],
                  value: _kategoriPerusahaan,
                  onSaved: (value) {
                    setState(() {
                      _kategoriPerusahaan = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Kategori Perusahaan harus diubah';
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
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: DropDownFormField(
                  titleText: 'Kota',
                  hintText: snapshot.data['kota'] == null
                      ? 'Kota'
                      : snapshot.data['kota'],
                  value: _kota,
                  onSaved: (value) {
                    setState(() {
                      _kota = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Kota harus diubah';
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
                  text: 'Update Lokasi Anda',
                  onPress: showPlacePicker,
                  color: mainColor),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
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
              new RoundedButton(
                  text: 'Simpan Perubahan',
                  onPress: updateDataES,
                  color: secColor),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }

  //form
  formEmployee(DocumentSnapshot snapshot) {
    return Container(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              new UploadPicture(
                userID: _userID,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: new StatusKerja(
                  userId: _userID,
                  statusKerja: snapshot.data['statusKerja'],
                ),
              ),
              new TextFields(
                  labelText: 'Nama',
                  value: snapshot.data['nama'],
                  iconData: Icons.person,
                  onSaved: (input) => _nama = input,
                  obscureText: false,
                  textInputType: TextInputType.text),
              new TextFields(
                  value: snapshot.data['noHp'],
                  labelText: 'No Handphone',
                  iconData: Icons.phone,
                  onSaved: (input) => _noHp = input,
                  obscureText: false,
                  textInputType: TextInputType.number),
              new AgeField(
                  labelText: 'Usia',
                  value: snapshot.data['usia'],
                  iconData: Icons.date_range,
                  onSaved: (input) => _usia = input,
                  obscureText: false,
                  textInputType: TextInputType.number),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: DropDownFormField(
                  titleText: 'Gender',
                  hintText: snapshot.data['gender'] == null
                      ? 'Gender'
                      : snapshot.data['gender'],
                  value: _gender,
                  onSaved: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                  // validator: (value) {
                  //   if (value == null) {
                  //     return 'Gender tidak boleh kosong';
                  //   }
                  //   return null;
                  // },
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
                  hintText: snapshot.data['pendidikan'] == null
                      ? 'Pendidikan'
                      : snapshot.data['pendidikan'],
                  value: _pendidikan,
                  onSaved: (value) {
                    setState(() {
                      _pendidikan = value;
                    });
                  },
                  // validator: (value) {
                  //   if (value == null) {
                  //     return 'Pendidikan tidak boleh kosong';
                  //   }
                  //   return null;
                  // },
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
                  hintText: snapshot.data['kota'] == null
                      ? 'Kota'
                      : snapshot.data['kota'],
                  value: _kota,
                  onSaved: (value) {
                    setState(() {
                      _kota = value;
                    });
                  },
                  // validator: (value) {
                  //   if (value == null) {
                  //     return 'Kota tidak boleh kosong';
                  //   }
                  //   return null;
                  // },
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
                  text: 'Update Lokasi Anda',
                  onPress: showPlacePicker,
                  color: mainColor),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
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
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: DropDownFormField(
                  titleText: 'Jam Kerja',
                  hintText: snapshot.data['jamKerja'] == null
                      ? 'Jam Kerja'
                      : snapshot.data['jamKerja'],
                  value: _jamKerja,
                  onSaved: (value) {
                    setState(() {
                      _jamKerja = value;
                    });
                  },
                  // validator: (value) {
                  //   if (value == null) {
                  //     return 'Jam Kerja tidak boleh kosong';
                  //   }
                  //   return null;
                  // },
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
                  hintText: snapshot.data['keahlian'] == null
                      ? 'Keahlian'
                      : snapshot.data['keahlian'],
                  value: _keahlian,
                  onSaved: (value) {
                    setState(() {
                      _keahlian = value;
                    });
                  },
                  // validator: (value) {
                  //   if (value == null) {
                  //     return 'Keahlian tidak boleh kosong';
                  //   }
                  //   return null;
                  // },
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
                  labelText: 'Gaji',
                  value: snapshot.data['gaji'].toString() == null
                      ? 'Gaji'
                      : snapshot.data['gaji'].toString(),
                  iconData: Icons.attach_money,
                  onSaved: (input) => _gaji = input,
                  obscureText: false,
                  textInputType: TextInputType.number),
              new TextFields(
                  labelText: 'Pengalaman Kerja',
                  value: snapshot.data['pengKerja'].toString() == null
                      ? 'Pengalaman Kerja'
                      : snapshot.data['pengKerja'].toString(),
                  iconData: Icons.access_time,
                  onSaved: (input) => _pengKerja = input,
                  obscureText: false,
                  textInputType: TextInputType.text),
              showCircular
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(),
              new RoundedButton(
                  text: 'Simpan Perubahan',
                  onPress: () => updateData(
                      snapshot.data['gender'],
                      snapshot.data['pendidikan'],
                      snapshot.data['kota'],
                      snapshot.data['keahlian'],
                      snapshot.data['jamKerja']),
                  color: secColor),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //get id
  getID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      _userID = user.uid;
    });
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

  void updateDataES() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<String, dynamic> dataES = {
        'namaPerusahaan': _nama,
        'alamat': _alamat,
        'latitude': _lat,
        'longitude': _long,
        'kota': _kota,
        'kategoriPerushaan': _kategoriPerusahaan,
        'position': myLocation.data
      };
      Map<String, dynamic> dataUsers = {
        'nama': _nama.toString(),
        'alamat': _alamat,
        'latitude': _lat,
        'longitude': _long,
      };
      Firestore.instance
          .collection('employee-seeker')
          .document(_userID)
          .updateData(dataES)
          .whenComplete(() {
        setState(() {
          showCircular = false;
        });
      });

      Firestore.instance
          .collection('users')
          .document(_userID)
          .updateData(dataUsers)
          .whenComplete(() {
        setState(() {
          showCircular = false;
        });
        print('Document Updated');
        EdgeAlert.show(context,
            title: 'Sukses',
            description: 'Data Diri Berhasil Diubah',
            gravity: EdgeAlert.TOP,
            icon: Icons.check_circle,
            backgroundColor: Colors.green);
      });
    }
  }

  void updateData(gender, pendidikan, kota, keahlian, jamKerja) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      Map<String, dynamic> dataEmployee = {
        'nama': _nama.toString(),
        'alamat': _alamat,
        'usia': _usia,
        'pendidikan': _pendidikan == null ? pendidikan : _pendidikan,
        'jamKerja': _jamKerja == null ? jamKerja : _jamKerja,
        'noHp': _noHp,
        'gender': _gender == null ? gender : _gender,
        'keahlian': _keahlian == null ? keahlian : _keahlian,
        'gaji': int.parse(_gaji),
        'kota': _kota == null ? kota : _kota,
        'latitude': _lat,
        'longitude': _long,
        'position': myLocation.data,
        'pengKerja': _pengKerja
      };

      Map<String, dynamic> dataUsers = {
        'nama': _nama.toString(),
        'alamat': _alamat,
        'latitude': _lat,
        'longitude': _long,
      };

      Firestore.instance
          .collection('employee')
          .document(_userID)
          .updateData(dataEmployee)
          .whenComplete(() {
        setState(() {
          showCircular = false;
        });
      });

      Firestore.instance
          .collection('users')
          .document(_userID)
          .updateData(dataUsers)
          .whenComplete(() {
        setState(() {
          showCircular = false;
        });
        print('Document Updated');
        EdgeAlert.show(context,
            title: 'Sukses',
            description: 'Data Diri Berhasil Diubah',
            gravity: EdgeAlert.TOP,
            icon: Icons.check_circle,
            backgroundColor: Colors.green);
      });
    }
  }
}
