import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychatapplication/HomeScreen/HomePageScreen.dart';
import 'package:mychatapplication/HomeScreen/IntroPage.dart';
import 'package:mychatapplication/LoginPages/Loginpage.dart';

class loadingservice{

   void movescreen(BuildContext context)async{

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    final firestore = FirebaseFirestore.instance;
    final userdoc  = await firestore.collection("User").doc(user?.uid).get();

    if(user==null)
    {
       Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
     });
    }
    
    else if(user.emailVerified || user.phoneNumber!.isNotEmpty){
      if(userdoc.exists)
      {
          Map<String,dynamic> userdata = userdoc.data() as Map<String,dynamic>;
          String profilepic = userdata["profile url"].toString(); 
        Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePageScreen(profileurl: profilepic,)));
       });
      }

      else{
        Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Intropage()));
     });
      }    
    }
   }  
}