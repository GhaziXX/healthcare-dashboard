import 'dart:io';

import 'package:admin/backend/firebase/authentification_services.dart';
import 'package:admin/backend/firebase/firestore_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as dh;

class ProfilePictureSelect extends StatefulWidget {
  const ProfilePictureSelect({
    Key key,
    this.borderRadius = 100.0,
    this.circleRadius = 70.0,
    @required this.isMobile,
    @required this.userId,
  }) : super(key: key);
  final double borderRadius;
  final double circleRadius;
  final bool isMobile;
  final String userId;

  @override
  _ProfilePictureSelectState createState() => _ProfilePictureSelectState();
}

Object image;

class _ProfilePictureSelectState extends State<ProfilePictureSelect> {
  @override
  void initState() {
    image = getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        child: !widget.isMobile
            ? HoverWidget(
                child: CircleAvatar(
                  radius: widget.circleRadius,
                  backgroundImage: image,
                ),
                hoverChild: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      CircleAvatar(
                        radius: widget.circleRadius,
                        backgroundImage: image,
                      ),
                      Container(
                        width: 2 * widget.circleRadius,
                        color: Colors.white.withOpacity(0.2),
                        child: IconButton(
                          splashRadius: 0.1,
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _showImagePicker();
                          },
                        ),
                      ),
                    ]),
                onHover: (event) {},
              )
            : Stack(alignment: AlignmentDirectional.bottomCenter, children: [
                CircleAvatar(
                  radius: widget.circleRadius,
                  backgroundImage: image,
                ),
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Container(
                      height: 3 * widget.circleRadius / 4,
                      width: 2 * widget.circleRadius,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    IconButton(
                      splashRadius: 0.1,
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _showImagePicker();
                      },
                    ),
                  ],
                ),
              ]),
      ),
    );
  }

  Object getImage() {
    return FirebaseAuth.instance.currentUser.photoURL != null
        ? NetworkImage(FirebaseAuth.instance.currentUser.photoURL)
        : AssetImage("assets/images/user.png");
  }

  void _showImagePicker() async {
    if (kIsWeb) {
      dh.InputElement uploadInput = dh.FileUploadInputElement()
        ..accept = "image/*";
      uploadInput.click();
      uploadInput.onChange.listen((event) {
        final file = uploadInput.files.first;
        if (file != null) {
          final reader = dh.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoadEnd.listen((event) async {
            final imageName = file.relativePath.split('/').last;
            final blob = DateTime.now();
            try {
              final reference = FirebaseStorage.instance.ref(imageName);
              await reference.child("$blob").putBlob(file);
              final uri = await reference.child("$blob").getDownloadURL();
              FirestoreServices().updatePhotoURL(
                  userId: widget.userId, url: uri);
              updateProfile(imageURI: uri).then((value) {
                if (value == true) {
                  setState(() {
                    image = getImage();
                  });
                }
              });
            } on FirebaseException catch (e) {
              print("error $e");
            }
          });
        }
      });
    } else {
      final result = await ImagePicker().getImage(
        imageQuality: 70,
        maxWidth: 1440,
        source: ImageSource.gallery,
      );
      if (result != null) {
        print("ena hna");
        final file = File(result.path);
        final imageName = result.path.split('/').last;
        print("imageName is $imageName");
        try {
          final reference = FirebaseStorage.instance.ref(imageName);
          await reference.putFile(file);
          final uri = await reference.getDownloadURL();
          updateProfile(imageURI: uri).then((value) {
            FirestoreServices().updatePhotoURL(
                  userId: widget.userId, url: uri);
            if (value == true) {
              setState(() {
                image = getImage();
              });

              
            }
          });
        } on FirebaseException catch (e) {
          print("error $e");
        }
      } else {
        // User canceled the picker
      }
    }
  }
}
