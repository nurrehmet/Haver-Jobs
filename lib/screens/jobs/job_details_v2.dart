import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/utils/ad_manager.dart';
import 'package:haverjob/utils/global.dart';
import 'package:url_launcher/url_launcher.dart';

class JobsDetailV2 extends StatefulWidget {
  String title;
  String content;
  String img;
  String url;
  String pubDate;
  JobsDetailV2({this.title, this.content, this.img, this.url, this.pubDate});

  @override
  _JobsDetailV2State createState() => _JobsDetailV2State();
}

class _JobsDetailV2State extends State<JobsDetailV2> {
  final databaseReference = Firestore.instance;
  bool saved = false;
  String _userID;

  void initState() {
    getID();
    getSavedStatus();
    super.initState();
  }

  getSavedStatus() async {
    var savedStatus = await databaseReference
        .collection('saved-jobs')
        .where('savedBy', isEqualTo: _userID)
        .where('title', isEqualTo: widget.title)
        .getDocuments();
    if (savedStatus.documents.isNotEmpty) {
      setState(() {
        saved = true;
      });
    }
  }

  getID() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      _userID = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, title: Text(widget.title)),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(right: 0, left: 0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      AdmobBanner(
                        adSize: AdmobBannerSize.LARGE_BANNER,
                        adUnitId: AdManager.bannerAdUnitId,
                      ),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Html(data: widget.content),
                ),
              ),
              AdmobBanner(
                adSize: AdmobBannerSize.BANNER,
                adUnitId: AdManager.bannerAdUnitId,
              ),
              SizedBox(
                height: 70,
              )
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(color: Colors.grey[350], width: 0.5))),
        child: Row(
          children: <Widget>[
            Container(
              width: 250,
              child: RoundedButton(
                text: "Kirim Email Lamaran",
                color: secColor,
                onPress: () async {
                  launch('mailto:' '');
                },
              ),
            ),
            FlatButton.icon(
                textColor: saved == true ? secColor : Colors.grey,
                onPressed: saved == false
                    ? () {
                        setState(() {
                          saved = true;
                        });
                        saveJob();
                      }
                    : () {},
                icon: Icon(Icons.bookmark),
                label: Text(saved == false ? 'Simpan' : 'Saved'))
          ],
        ),
      ),
    );
  }

  void saveJob() async {
    await databaseReference.collection("saved-jobs").add({
      'title': widget.title,
      'content': widget.content,
      'pubDate': widget.pubDate,
      'link': widget.url,
      'savedBy': _userID,
      'saved': 'true'
    }).whenComplete(() => {
          EdgeAlert.show(context,
              title: 'Sukses',
              description: 'Lowongan Pekerjaan Berhasil Disimpan',
              gravity: EdgeAlert.TOP,
              icon: Icons.check_circle,
              backgroundColor: secColor)
        });
  }
}
