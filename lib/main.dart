import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mychatapplication/LoadingScreen.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const Material(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    ),
  ));
}


//command to get SHA fingerprints "keytool -list -v -keystore "C:\Users\Username\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android"