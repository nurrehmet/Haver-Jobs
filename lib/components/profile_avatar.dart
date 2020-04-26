import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatefulWidget {
    double radius;
    ProfileAvatar({this.radius});

  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  String imageUrl;

  void initState() {
    getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircleAvatar(
        radius: widget.radius == null? 30:widget.radius,
        backgroundImage: imageUrl == null
            ? NetworkImage(
                'https://iupac.org/wp-content/uploads/2018/05/default-avatar.png')
            : NetworkImage(imageUrl),
      ),
    );
  }

  getImage() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      var _userID = user.uid;
      var ref = FirebaseStorage.instance.ref().child('avatar/$_userID');
      ref.getDownloadURL().then((loc) => setState(() => imageUrl = loc));
    });
  }
}
