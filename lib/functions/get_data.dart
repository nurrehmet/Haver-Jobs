import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserData {
  String col, doc, docField;
  GetUserData({this.doc, this.col, this.docField});

  getFieldData() async {
    await Firestore.instance
        .collection(col)
        .document(doc)
        .get()
        .then((DocumentSnapshot ds) {
      return ds.data[docField];
    });
  }
}
