import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'dart:convert';


class Jobs {
  String title;
  String description;
  String content;
  String link;

  Jobs({this.title,this.description,this.content,this.link});

  factory Jobs.fromJson(Map<String, dynamic> parsedJson){
    return Jobs(
      title: parsedJson['title'].toString(),
      description: parsedJson['description'].toString(),
      content: parsedJson['content'].toString()
    );
  }
}
