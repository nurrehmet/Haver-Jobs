import 'dart:convert';
import 'dart:math';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:haverjob/models/jobs.dart';
import 'package:haverjob/screens/jobs/job_details_v2.dart';
import 'package:haverjob/utils/ad_manager.dart';
import 'package:haverjob/utils/global.dart';
import 'package:http/http.dart' as http;

class GetJobData extends StatefulWidget {
  String provider;

  GetJobData({this.provider});

  @override
  _GetJobDataState createState() => _GetJobDataState();
}

class _GetJobDataState extends State<GetJobData> {
  var url;
  final databaseReference = Firestore.instance;
    AdmobInterstitial interstitialAd;

  @override
  void initState() {
    super.initState();
    interstitialAd = AdmobInterstitial(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
    interstitialAd.load();
  }

  String rmHtml(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }

  String uperCase(String str) {
    return str.toUpperCase();
  }

  Future<List> getData() async {
    switch (widget.provider) {
      case "bumn":
        {
          url =
              "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.disnakerja.com%2Fjob%2Ftag%2Fbumn%2Ffeed%2F&api_key=ivmpn3zddtsjvbhoqg8qqnubrv0a7tmkrxload4l";
        }
        break;
      case "instansi":
        {
          url =
              "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.disnakerja.com%2Fjob%2Ftag%2Fcpns%2Ffeed%2F&api_key=ivmpn3zddtsjvbhoqg8qqnubrv0a7tmkrxload4l";
        }
        break;
      case "medis":
        {
          url =
              "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.disnakerja.com%2Fjob%2Ftag%2Fmedis%2Ffeed%2F&api_key=ivmpn3zddtsjvbhoqg8qqnubrv0a7tmkrxload4l";
        }
        break;
      case "migas":
        {
          url =
              "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.disnakerja.com%2Fjob%2Ftag%2Fmigas%2Ffeed%2F&api_key=ivmpn3zddtsjvbhoqg8qqnubrv0a7tmkrxload4l";
        }
        break;
      case "mining":
        {
          url =
              "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.disnakerja.com%2Fjob%2Ftag%2Fmining%2Ffeed%2F&api_key=ivmpn3zddtsjvbhoqg8qqnubrv0a7tmkrxload4l";
        }
        break;
      case "manufaktur":
        {
          url =
              "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.disnakerja.com%2Fjob%2Ftag%2Fmanufaktur%2Ffeed%2F&api_key=ivmpn3zddtsjvbhoqg8qqnubrv0a7tmkrxload4l";
        }
        break;
      case "disnakerja":
        {
          url =
              "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fwww.disnakerja.com%2Ffeed%2F&api_key=ivmpn3zddtsjvbhoqg8qqnubrv0a7tmkrxload4l";
        }
    }
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
                              onTap: () {
                                interstitialAd.show();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobsDetailV2(
                                        title: snapshot.data[index]['title'],
                                        content: widget.provider == "lokernas"
                                            ? snapshot.data[index]
                                                ['description']
                                            : snapshot.data[index]['content'],
                                        url: snapshot.data[index]['link'],
                                        pubDate: snapshot.data[index]
                                            ['pubDate'],
                                      ),
                                    ));
                              },
                              // leading: provider == "lokernas" ? Image(image:NetworkImage(snapshot.data[index]['thumbnail'])) : CircleAvatar(child: Text('DK'),),
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data[index]['title'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: mainColor),
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  widget.provider == "lokernas"
                                      ? snapshot.data[index]['description']
                                      : rmHtml(snapshot.data[index]['content'])
                                          .trim(),
                                  maxLines: 4,
                                ),
                              ),
                              // trailing: Text(snapshot.data[index]['link']),
                            ),
                            ListTile(
                              trailing: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  uperCase(
                                      snapshot.data[index]['categories'][0]),
                                  style: TextStyle(color: secColor),
                                ),
                              ),
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data[index]['pubDate'],
                                  style: styleFade,
                                ),
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
