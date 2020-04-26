import 'dart:io';
import 'dart:async';
import 'package:edge_alert/edge_alert.dart';
import 'package:haverjob/components/profile_avatar.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPicture extends StatefulWidget {
  String userID;
  UploadPicture({this.userID});
  @override
  _UploadPictureState createState() => _UploadPictureState();
}

class _UploadPictureState extends State<UploadPicture> {
  File _image;
  String _uploadedFileURL;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Center(
              child: _image == null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new ProfileAvatar(
                        radius: 50,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(_image),
                      ),
                    ),
              // : Image.file(_image, height: 100,width: 100,fit:BoxFit.cover),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton.extended(
                    heroTag: 'Hero1',
                    onPressed: getImage,
                    label: Text('Pilih Gambar'),
                    tooltip: 'Pick Image',
                    icon: Icon(Icons.add_a_photo),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    onPressed: uploadFile,
                    heroTag: 'Hero2',
                    label: Text('Upload'),
                    tooltip: 'Upload',
                    icon: Icon(Icons.cloud_upload),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future uploadFile() async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('avatar/${widget.userID}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
      EdgeAlert.show(context,
          title: 'Sukses',
          description: 'Foto Profil Berhasil Di Upload',
          gravity: EdgeAlert.TOP,
          icon: Icons.check_circle,
          backgroundColor: Colors.green);

      print(fileURL);
    });
  }
}
