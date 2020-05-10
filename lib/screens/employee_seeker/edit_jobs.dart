import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/models/list_data.dart';
import 'package:place_picker/place_picker.dart';

class EditJobs extends StatefulWidget {
  String jobID, creator;
  EditJobs({this.jobID, this.creator});
  @override
  _EditJobsState createState() => _EditJobsState();
}

class _EditJobsState extends State<EditJobs> {
  final _formKey = GlobalKey<FormState>();
  //data pekerjaan
  String _judul,
      _kategoriPekerjaan,
      _gaji,
      _pendidikan,
      _keahlian,
      _gender,
      _jamKerja,
      _deskripsi,
      _kota,
      _lokasi,
      _namaPerusahaan,
      _emailPerusahaan;
  String userID;
  //data lokasi
  double _lat, _long;
  bool showCircular = false;
  Geoflutterfire geo = Geoflutterfire();
  Firestore _firestore = Firestore.instance;
  GeoFirePoint myLocation;

  void initState() {
    super.initState();
    _kategoriPekerjaan = '';
    _pendidikan = '';
    _jamKerja = '';
    _gender = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data Pekerjaan'),
        actions: <Widget>[
          FlatButton.icon(
            textColor: Colors.white,
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            label: Text('Simpan'),
            onPressed: updateData,
          )
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('jobs')
            .document(widget.jobID)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return editJobs(snapshot.data);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  editJobs(DocumentSnapshot snapshot) {
    return Container(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              new TextFields(
                value: snapshot.data['judul'],
                labelText: 'Judul Pekerjaan',
                iconData: Icons.title,
                onSaved: (input) => _judul = input,
                obscureText: false,
                textInputType: TextInputType.text,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
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
                              hintText: snapshot.data['deskripsi']),
                        ),
                      ),
                    )),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: DropDownFormField(
                  titleText: 'Kategori Pekerjaan',
                  hintText: snapshot.data['kategoriPekerjaan'],
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
                value: snapshot.data['gaji'],
                labelText: 'Gaji per Jam',
                iconData: Icons.attach_money,
                onSaved: (input) => _gaji = input,
                obscureText: false,
                textInputType: TextInputType.number,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: DropDownFormField(
                  titleText: 'Jam Kerja',
                  hintText: snapshot.data['jamKerja'],
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
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: DropDownFormField(
                  titleText: 'Pendidikan Minimal',
                  hintText: snapshot.data['pendidikan'],
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
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: DropDownFormField(
                  titleText: 'Gender Yang Dibutuhkan',
                  hintText: snapshot.data['gender'],
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
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: DropDownFormField(
                  titleText: 'Kota',
                  hintText: snapshot.data['kota'],
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
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _lokasi == null
                        ? 'Lokasi belum dipilih'
                        : 'Lokasi Anda: $_lokasi',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              showCircular
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      String _gajiFormat = _gaji.replaceAll(',', '');
      Map<String, dynamic> jobData = {
        'judul': _judul,
        'kategoriPekerjaan': _kategoriPekerjaan,
        'gender': _gender,
        'jamKerja': _jamKerja,
        'gaji': _gajiFormat.replaceAll('.', ''),
        'pendidikan': _pendidikan,
        'deskripsi': _deskripsi,
        'lokasi': _lokasi,
        'latitude': _lat,
        'longitude': _long,
        'position': myLocation.data,
      };
      Firestore.instance
          .collection('jobs')
          .document(widget.jobID)
          .updateData(jobData)
          .whenComplete(() {
        setState(() {
          showCircular = false;
        });
        EdgeAlert.show(context,
            title: 'Sukses',
            description: 'Data Pekerjaan Berhasil Diubah',
            gravity: EdgeAlert.TOP,
            icon: Icons.check_circle,
            backgroundColor: Colors.green);
      });
      Navigator.pop(context);
    }
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
