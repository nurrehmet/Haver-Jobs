import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeSeeker {
  String userID;
  String namaPerusahaan;
  EmployeeSeeker.fromSnapshot(DocumentSnapshot snapshot)
      : userID = snapshot.documentID,
        namaPerusahaan = snapshot['namaPerusahaan'];
}
