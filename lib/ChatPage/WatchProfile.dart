import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapplication/Utilities/Models/UserModel.dart';

class WatchProfileScreen extends StatefulWidget {
  const WatchProfileScreen({super.key, required this.targetUser});
  final UserModel targetUser;

  @override
  State<WatchProfileScreen> createState() => _WatchProfileScreenState();
}

class _WatchProfileScreenState extends State<WatchProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(   
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 440,
              width: MediaQuery.of(context).size.width,
              child: Image(image: CachedNetworkImageProvider(widget.targetUser.imageurl.toString()),fit: BoxFit.cover,),
            ),
      
            const SizedBox(
              height: 20,
            ),
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Name :",style: GoogleFonts.jost(color: Colors.deepPurple,fontSize: 13),)),
                    
                    const SizedBox(
                      height: 3,
                    ),
      
      
                    Align(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.targetUser.name.toString(),style: GoogleFonts.jost(color: Colors.black,fontSize: 20),)),
                ],
              ),
            ),
      
      
            const SizedBox(
              height: 20,
            ),
      
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Gender :",style: GoogleFonts.jost(color: Colors.deepPurple,fontSize: 13),)),
                    
                    const SizedBox(
                      height: 3,
                    ),
      
      
                    Align(
                    alignment: Alignment.centerLeft,
                    child: Text(widget.targetUser.gender.toString(),style: GoogleFonts.jost(color: Colors.black,fontSize: 20),)),
                ],
              ),
            ),
      
      
            const SizedBox(
              height: 20,
            ),
      
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Bio :",style: GoogleFonts.jost(color: Colors.deepPurple,fontSize: 16),)),
                    
                    const SizedBox(
                      height: 3,
                    ),
      
      
                    Align(
                    alignment: Alignment.centerLeft,
                    child: Wrap(
                      children: [
                        Text(widget.targetUser.bio.toString(),style: GoogleFonts.jost(color: Colors.black,fontSize: 20),)
                      ],
                    )),
                ],
              ),
            ),
      
            const SizedBox(
              height: 30,
            ),
      
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_circle_left_rounded,color: Colors.deepPurple,size: 30,),
                  Text("Go back",style: GoogleFonts.jost(color: Colors.deepPurple,fontSize: 18),)
                ],
              ),
            )
      
          ],
        ),
      ),
    );
  }
}