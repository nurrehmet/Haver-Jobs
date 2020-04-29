import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';

bool _statusKerja;
final databaseReference = Firestore.instance;

class StatusKerja extends StatefulWidget {
  String userId;
  bool statusKerja;
  StatusKerja({this.userId,this.statusKerja});
  @override
  _StatusKerjaState createState() => _StatusKerjaState();
}

class _StatusKerjaState extends State<StatusKerja> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: Colors.amber,
      child: SwitchListTile(
        activeColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text('Status Bekerja'),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text('Nyalakan untuk menerima tawaran pekerjaan dari Perusahaan (Auto ON saat pendaftaran)'),
        ),
        value: widget.statusKerja == null ? false:widget.statusKerja,
        onChanged: (bool value) {
          setState(() {
            _statusKerja = value;
          });
          setStatusKerja();
        },
        secondary: const Icon(Icons.lightbulb_outline,color: Colors.white),
      ),
    );
  }

  void setStatusKerja() async {
    final DocumentReference postRef = Firestore.instance.document('employee/${widget.userId}');
    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if (postSnapshot.exists) {
        await tx.update(postRef, <String, dynamic>{
          'statusKerja': _statusKerja
        });
      }
    }).whenComplete(() {
      EdgeAlert.show(context,
          title: 'Sukses',
          description: 'Status Kerja Berhasil Diubah',
          gravity: EdgeAlert.TOP,
          icon: Icons.check_circle,
          backgroundColor: Colors.green);
    });
  }
}
