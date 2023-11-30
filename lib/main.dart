import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mychatapplication/LoadingScreen.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}



void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp();
 
  runApp(const Material(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    ),
  ));
}
 
 

//command to get SHA fingerprints "keytool -list -v -keystore "C:\Users\Username\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android"