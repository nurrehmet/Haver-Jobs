import 'package:flutter/material.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:hexcolor/hexcolor.dart';

class FindEmployeeScreen extends StatefulWidget {
  @override
  _FindEmployeeScreenState createState() => _FindEmployeeScreenState();
}

class _FindEmployeeScreenState extends State<FindEmployeeScreen> {
  String _keahlian, _pendidikan;
  String _myActivityResult;
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
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _keahlian = '';
    _pendidikan = '';
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
    return Container(
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
            new RoundedButton(
              text: 'Cari Karyawan Part Time',
              onPress: () {
                var form = formKey.currentState;
                if (form.validate()) {
                  form.save();
                  setState(() {
                    _myActivityResult = _keahlian;
                  });
                }
                print(_keahlian + _pendidikan);
              },
              color: Hexcolor('#3f72af'),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text(_myActivityResult),
            )
          ],
        ),
      ),
    );
  }
}
