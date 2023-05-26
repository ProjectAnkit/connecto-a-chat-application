// ignore: file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapplication/Utilities/Services/LoadingServices.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadingservice().movescreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Center(
                    child: AnimatedContainer(
                      height: 60,
                      width: 60,
                      duration: Duration(seconds: 2),
                      child: Image(image: AssetImage("assets/MyLogo.png")), 
                    ),
                  ),
                ],
              ),
            ),
          
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 120.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("connecto",style: GoogleFonts.jost(color: Colors.white,fontSize: 30),),
                    Text("by ProjectAnkit",style: GoogleFonts.jost(color: Colors.white),)
                  ],
                ),
              ),
            )
          ],
        ),

      )
    );
  }
}