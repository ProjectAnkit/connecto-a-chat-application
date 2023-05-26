import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../Utilities/Models/UserModel.dart';

class GetImage extends StatefulWidget {
  const GetImage({super.key, required this.OwnUser});
  final UserModel OwnUser;

  @override
  State<GetImage> createState() => _GetImageState();
}

class _GetImageState extends State<GetImage> {

  final auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;

  File? image;
  ImagePicker picker = ImagePicker();
  String userProfile = "";


   Future getImage()async{
    final user = auth.currentUser;
    final imagepath = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);

    if(imagepath!=null)
    {
       setState(() {
         image = File(imagepath.path);
        });

       String imageref = DateTime.now().millisecondsSinceEpoch.toString();
       final ref = storage.ref(imageref);
       await ref.putFile(image!.absolute);

       final profileurl = await ref.getDownloadURL();
       
       setState(() {
          userProfile = profileurl;
         });
       
       await firestore.collection("User").doc(user!.uid).update({
        "profile url" : profileurl,
       });
    }
  }


  @override
  Widget build(BuildContext context) {
    return  Column(
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          getImage();
                         });
                      },
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: image!=null? NetworkImage(userProfile) : NetworkImage(widget.OwnUser.imageurl.toString()),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                           getImage();
                          });
                      },
                      child: Text("Tap to Change your Profile",style: GoogleFonts.jost(color: Colors.deepPurple),))
                  ],
                );
  }
}