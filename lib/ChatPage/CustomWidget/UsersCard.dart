import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utilities/Models/UserModel.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.name, required this.subtitle, required this.imageurl, required this.msgtime,required this.uid, required this.targetUser});
  final UserModel targetUser;
  final String name;
  final String subtitle;
  final String imageurl;
  final String msgtime; 
  final String uid;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name,style: GoogleFonts.jost(color: Colors.black),overflow: TextOverflow.ellipsis),
      subtitle: subtitle.isNotEmpty? Text(subtitle,style: GoogleFonts.jost(color: Colors.grey[700]),overflow: TextOverflow.ellipsis,maxLines: 1,): Text("Say hi! to your new friend",style: GoogleFonts.jost(color: Colors.deepPurpleAccent[600]),),
      leading:  CircleAvatar(
        backgroundColor: Colors.white,
          backgroundImage: NetworkImage(imageurl)
      ),
      trailing: Text(msgtime,style: GoogleFonts.jost(color: Colors.black)),
    );
  }
}