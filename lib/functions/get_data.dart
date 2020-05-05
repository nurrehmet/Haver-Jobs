import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetESName extends StatelessWidget {
  String userID;
  GetESName({this.userID});
  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> provideDocumentFieldStream() {
      return Firestore.instance
          .collection('employee-seeker')
          .document(userID)
          .snapshots();
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: provideDocumentFieldStream(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            //snapshot -> AsyncSnapshot of DocumentSnapshot
            //snapshot.data -> DocumentSnapshot
            //snapshot.data.data -> Map of fields that you need :)

            Map<String, dynamic> documentFields = snapshot.data.data;
            //TODO Okay, now you can use documentFields (json) as needed

            return Text(documentFields['namaPerusahaan']);
          }
        });
  }
}
