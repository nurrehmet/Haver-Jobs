import 'package:flutter/material.dart';
import 'package:haverjob/models/kategori_perusahaan.dart';
import 'package:place_picker/place_picker.dart';


class SignUpScreen extends StatefulWidget {
  static final id = 'signup_screen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  //data employee seeker
  String _nama, _email, _password, _alamat, _noHp, _kategoriPerusahaan;
  //data employee
  String _gender, _pendidikan, _tglLahir, _pengKerja, _hariKerja, _gaji;
  double _lat, long;
  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(_email);
      print(_password);
    }
    print(_kategoriPerusahaan);
  }
  //get location
  void showPlacePicker() async{
    LocationResult result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PlacePicker("AIzaSyDX1cPMy9zPG39wvwaDl85NJddg7SFNBEI"))
    );
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
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
        children: <Widget>[Text('Registrasi Employee')],
      ),
    );
  }

  //dropdown listener
  List<KategoriPerusahaan> _dataKategoriPerusahaan =
      KategoriPerusahaan.getKategoriPerusahaan();
  List<DropdownMenuItem<KategoriPerusahaan>> _dropdownMenuItems;
  KategoriPerusahaan _selectedKategoriPerusahaan;
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_dataKategoriPerusahaan);
    _selectedKategoriPerusahaan = _dropdownMenuItems[0].value;
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
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Nama',
                          labelStyle: TextStyle(fontFamily: 'Product Sans')),
                      validator: (value) {
                        if (value.trim().isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                      onSaved: (input) => _nama = input,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(fontFamily: 'Product Sans')),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!value.contains('@') || (!value.contains('.com')))
                          return 'Masukan format Email yang valid';
                        return null;
                      },
                      onSaved: (input) => _email = input,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(fontFamily: 'Product Sans')),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length < 6) {
                          return 'Password harus berjumlah 6 karakter atau lebih';
                        }
                        return null;
                      },
                      onSaved: (input) => _password = input,
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Alamat',
                          labelStyle: TextStyle(fontFamily: 'Product Sans')),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Alamat tidak boleh kosong';
                        }
                        return null;
                      },
                      onSaved: (input) => _alamat = input,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'No Handphone',
                          labelStyle: TextStyle(fontFamily: 'Product Sans')),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'No Handphone tidak boleh kosong';
                        }
                        return null;
                      },
                      onSaved: (input) => _noHp = input,
                    ),
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
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Kategori yang dipilih adalah ${_selectedKategoriPerusahaan.name}',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
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
                              'Pilih Lokasi Anda',
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
                          child: Container(
                            width: 200.0,
                            child: FlatButton.icon(
                              icon: Icon(Icons.search,color: Colors.white,),
                              onPressed: (){
                                showPlacePicker();
                              },
                              padding: EdgeInsets.all(10.0),
                              color: Colors.lightGreen,
                              label: Text(
                                'Pilih Lokasi Anda',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    width: 250.0,
                    child: FlatButton(
                      onPressed: _submit,
                      padding: EdgeInsets.all(10.0),
                      color: Colors.blue,
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    width: 250.0,
                    child: FlatButton(
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.all(10.0),
                      color: Colors.grey,
                      child: Text(
                        'Kembali ke Awal',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
}
