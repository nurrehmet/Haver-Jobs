import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:haverjob/utils/global.dart';
import 'package:http/http.dart' as http;
class GetJobData extends StatelessWidget {
  
  String provider;
  var url;
  GetJobData({this.provider});

  String rmHtml(String htmlText) {
    RegExp exp = RegExp(
      r"<[^>]*>",
      multiLine: true,
      caseSensitive: true
    );
    return htmlText.replaceAll(exp, '');
  }

  String uperCase(String str){
    return str.toUpperCase();
  }

  Future<List> getData() async {
   switch(provider){
      case "lokernas":{
       url = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.blogger.com%2Ffeeds%2F5309385973701982564%2Fposts%2Fdefault&api_key=ivmpn3zddtsjvbhoqg8qqnubrv0a7tmkrxload4l";
      }
      break;
      case "disnakerja":{
       url = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.disnakerja.com%2Ffeed%2F&api_key=ivmpn3zddtsjvbhoqg8qqnubrv0a7tmkrxload4l";
      }
    } 
  //  var url = 'https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.blogger.com%2Ffeeds%2F5309385973701982564%2Fposts%2Fdefault&api_key=ivmpn3zddtsjvbhoqg8qqnubrv0a7tmkrxload4l';
   http.Response response = await http.get(url);
   var data = jsonDecode(response.body)['items'];
   return data;
  }
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // Success case
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                // leading: provider == "lokernas" ? Image(image:NetworkImage(snapshot.data[index]['thumbnail'])) : CircleAvatar(child: Text('DK'),),
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.data[index]['title'],style: TextStyle(fontWeight: FontWeight.bold,color: mainColor),),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(provider == "lokernas" ? snapshot.data[index]['description']: rmHtml(snapshot.data[index]['content']).trim(),
                                  maxLines: 4,),
                                ),
                                // trailing: Text(snapshot.data[index]['link']),
                              ),
                              ListTile(
                                trailing: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(uperCase(snapshot.data[index]['categories'][0]),style: TextStyle(color: secColor),),
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(snapshot.data[index]['pubDate'],style: styleFade,),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: snapshot.data.length,
              );
            }
            // Error case
            return Text('Something went wrong');
          } else {
            // Loading data
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    
  }
}