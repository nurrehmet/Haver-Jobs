import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:haverjob/components/profile_avatar.dart';
import 'package:haverjob/components/widgets.dart';
import 'package:haverjob/screens/direction_map.dart';
import 'package:haverjob/utils/global.dart';
import 'package:url_launcher/url_launcher.dart';

class AkunDetail extends StatelessWidget {
  String userID, nama, jarak;
  AkunDetail({this.userID, this.nama, this.jarak});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //     'Data Diri Pekerja',
        //     style: TextStyle(color: mainColor, fontWeight: bold, fontSize: 22),
        //   ),
        actions: <Widget>[
          FlatButton(
            child: Icon(
              Icons.bookmark_border,
              color: secColor,
            ),
            onPressed: () {},
          )
        ],
        iconTheme: IconThemeData(
          color: secColor, //change your color here
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('employee')
            .document(userID)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return accountScreen(snapshot.data);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  accountScreen(DocumentSnapshot snapshot) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: new Container(
        height: 100,
        color: Colors.white.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              height: 70,
              width: 260,
              child: RoundedButton(
                text: 'Hubungi Whatsapp',
                color: secColor,
                onPress: () async {
                  await launch(
                      "https://api.whatsapp.com/send?phone=${snapshot.data['noHp']}&text=&source=&data=&app_absent=");
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: FloatingActionButton.extended(
                elevation: 0,
                icon: Icon(Icons.near_me),
                label: Text('Arahkan'),
                backgroundColor: mainColor,
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    trailing: ProfileAvatar(
                      uid: userID,
                      detailEmployee: true,
                    ),
                    title: Text(
                      snapshot.data['nama'],
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        snapshot.data['keahlian'] +
                            ' - ' +
                            snapshot.data['kota'],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  ListTile(
                    leading: Text(jarak == null
                        ? 'Pendidikan: ' + snapshot.data['pendidikan']
                        : 'Jarak ' + jarak + ' KM'),
                    trailing: Text(
                        'Rp.' + snapshot.data['gaji'].toString() + '/ jam'),
                  )
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Data Diri',
                style: styleBold,
              ),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text(snapshot.data['email']),
            ),
            ListTile(
              title: Text('Jam Kerja'),
              subtitle: Text(snapshot.data['jamKerja']),
            ),
            Visibility(
              visible: jarak == null ? false : true,
              child: ListTile(
                title: Text('Pendidikan'),
                subtitle: Text(snapshot.data['pendidikan']),
              ),
            ),
            ListTile(
              title: Text('Usia'),
              subtitle: Text(snapshot.data['usia']),
            ),
            ListTile(
              title: Text('Pengalaman Kerja'),
              subtitle: Text(snapshot.data['pengKerja']),
            ),
            ListTile(
              title: Text('Alamat'),
              subtitle: Text(snapshot.data['alamat']),
            )
          ],
        ),
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: <Widget>[
      //       SizedBox(
      //         height: 20,
      //       ),
      //       Container(
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(25.0),
      //               topRight: Radius.circular(25.0)),
      //           boxShadow: [
      //             BoxShadow(
      //               color: Colors.grey,
      //               blurRadius: 25.0, // soften the shadow
      //               spreadRadius: 5.0, //extend the shadow
      //               offset: Offset(
      //                 15.0, // Move to right 10  horizontally
      //                 15.0, // Move to bottom 10 Vertically
      //               ),
      //             ),
      //           ],
      //         ),
      //         child: Padding(
      //           padding: const EdgeInsets.all(8.0),
      //           child: Column(
      //             children: <Widget>[
      //               Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: ProfileAvatar(
      //                   uid: snapshot.documentID,
      //                   detailEmployee: true,
      //                   radius: 70,
      //                 ),
      //               ),
      //               Container(
      //                 child: Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: ListTile(
      //                     title: Center(
      //                       child: Text(snapshot.data['nama'],
      //                           textAlign: TextAlign.center,
      //                           style: TextStyle(
      //                             fontWeight: FontWeight.bold,
      //                             fontSize: 22,
      //                           )),
      //                     ),
      //                     subtitle: Center(
      //                       child: Text('${snapshot.data['keahlian']}  ',
      //                           textAlign: TextAlign.center,
      //                           style: TextStyle(
      //                             fontSize: 18,
      //                           )),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //               SizedBox(
      //                 height: 20,
      //               ),
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
      //                 children: <Widget>[
      //                   Container(
      //                     decoration: BoxDecoration(
      //                         color: Colors.grey[200],
      //                         borderRadius: BorderRadius.circular(10)),
      //                     height: 70,
      //                     width: 100,
      //                     child: Center(
      //                       child: Icon(Icons.bookmark_border),
      //                     ),
      //                   ),
      //                   InkWell(

      //                     child: Container(
      //                       decoration: BoxDecoration(
      //                           color: Colors.green[200],
      //                           borderRadius: BorderRadius.circular(10)),
      //                       height: 70,
      //                       width: 200,
      //                       child: Center(
      //                         child: Text('Hubungi Whatsapp'),
      //                       ),
      //                     ),
      //                   )
      //                 ],
      //               ),
      //               SizedBox(
      //                 height: 20,
      //               ),
      //               Visibility(
      //                 visible: jarak == null ? false : true,
      //                 child: ListTile(
      //                   leading: Icon(
      //                     Icons.directions,
      //                     color: Colors.blue,
      //                   ),
      //                   title: Text('Jarak',
      //                       style: TextStyle(
      //                         fontWeight: FontWeight.bold,

      //                       )),
      //                   subtitle: Text('$jarak KM'),
      //                 ),
      //               ),
      //               ListTile(
      //                 leading: Icon(
      //                   Icons.location_city,
      //                   color: Colors.blue,
      //                 ),
      //                 title: Text('Kota',
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                     )),
      //                 subtitle: Text(snapshot.data['kota']),
      //               ),
      //               ListTile(
      //                 leading: Icon(
      //                   Icons.map,
      //                   color: Colors.blue,
      //                 ),
      //                 title: Text('Alamat',
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                     )),
      //                 subtitle: Text(snapshot.data['alamat']),
      //               ),
      //               ListTile(
      //                 leading: Icon(
      //                   Icons.access_time,
      //                   color: Colors.blue,
      //                 ),
      //                 title: Text('Jam Kerja',
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                     )),
      //                 subtitle: Text(snapshot.data['jamKerja']),
      //               ),
      //               ListTile(
      //                 leading: Icon(
      //                   Icons.attach_money,
      //                   color: Colors.blue,
      //                 ),
      //                 title: Text('Gaji per Jam',
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                     )),
      //                 subtitle: Text(snapshot.data['gaji'].toString()),
      //               ),
      //               ListTile(
      //                 leading: Icon(
      //                   Icons.access_time,
      //                   color: Colors.blue,
      //                 ),
      //                 title: Text('Pengalaman Kerja',
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                     )),
      //                 subtitle: Text(snapshot.data['pengKerja'] == null
      //                     ? 'Pengalaman Kerja Belum Tersedia'
      //                     : snapshot.data['pengKerja']),
      //               ),
      //               ListTile(
      //                 trailing: FlatButton(
      //                   textColor: Colors.blue,
      //                   onPressed: () async {
      //                     await launch("tel:${snapshot.data['noHp']}");
      //                   },
      //                   child: Text('HUBUNGI',
      //                       style: TextStyle(
      //                         color: Colors.green,
      //                         fontWeight: FontWeight.bold,
      //                       )),
      //                 ),
      //                 leading: Icon(
      //                   Icons.phone,
      //                   color: Colors.blue,
      //                 ),
      //                 title: Text('No Handphone',
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                     )),
      //                 subtitle: Text(snapshot.data['noHp']),
      //               ),
      //               ListTile(
      //                 trailing: FlatButton(
      //                   textColor: Colors.blue,
      //                   onPressed: () async {
      //                     await launch("mailto:${snapshot.data['email']}");
      //                   },
      //                   child: Text('KIRIM EMAIL',
      //                       style: TextStyle(
      //                         fontWeight: FontWeight.bold,
      //                       )),
      //                 ),
      //                 leading: Icon(
      //                   Icons.email,
      //                   color: Colors.blue,
      //                 ),
      //                 title: Text('Email',
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                     )),
      //                 subtitle: Text(snapshot.data['email']),
      //               ),
      //               ListTile(
      //                 leading: Icon(
      //                   Icons.school,
      //                   color: Colors.blue,
      //                 ),
      //                 title: Text('Pendidikan Terakhir',
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                     )),
      //                 subtitle: Text(snapshot.data['pendidikan']),
      //               ),
      //               ListTile(
      //                 leading: Icon(
      //                   Icons.date_range,
      //                   color: Colors.blue,
      //                 ),
      //                 title: Text('Usia',
      //                     style: TextStyle(
      //                       fontWeight: FontWeight.bold,
      //                     )),
      //                 subtitle: Text(snapshot.data['usia']),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
