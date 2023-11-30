import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mychatapplication/HomeScreen/NotificationPanel.dart';
class NotificationServices{

FirebaseMessaging messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


 Future<void>initlocalNotification(BuildContext context,RemoteMessage message)async{
   var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
   var iosinitializationSettings = const DarwinInitializationSettings();

   var initilizationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosinitializationSettings,
   );

   await _flutterLocalNotificationsPlugin.initialize(
    initilizationSettings,
    onDidReceiveNotificationResponse: (payload){
      handleNotifications(context, message);
    });
 }

 void handleNotifications(BuildContext context, RemoteMessage message)
 {
     if(message.data['type']=="notification")
     {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> NotificationPanel(title: message.notification!.title.toString(),notification: message.notification!.body.toString(),)));
     }
 }

 Future<void>showNotification(RemoteMessage message)async{
    
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(), 
      "high_importance_channel",
      importance: Importance.max,
      showBadge: true ,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('jetsons_doorbell')
      );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id, 
      channel.name,
      importance: Importance.max,
      channelDescription: "connecto channel",
      priority: Priority.max,
      ticker: 'ticker',
      );

    DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero,(){
      _flutterLocalNotificationsPlugin.show(
        0, 
        message.notification!.title.toString(), 
        message.notification!.body.toString(), 
        notificationDetails
        );
    });
 }




 void initFirebase(BuildContext context){

    FirebaseMessaging.onMessage.listen((message) {

      RemoteNotification? notification = message.notification ;
      AndroidNotification? android = message.notification!.android ;

      if (kDebugMode) {
        print("notifications title:${notification!.title}");
        print("notifications body:${notification.body}");
        print('count:${android!.count}');
        print('data:${message.data.toString()}');
      }

      if(Platform.isIOS){
        forgroundMessage();
      }

      if(Platform.isAndroid){
        initlocalNotification(context, message);
        showNotification(message);
      }
    });
  }



 Future<void>reqpushnotifications()async{

  final FCMtoken = await messaging.getToken();
  print(FCMtoken);

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  if(settings.authorizationStatus == AuthorizationStatus.authorized){
  }
  else if(settings.authorizationStatus == AuthorizationStatus.provisional){
  }
  else{
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }
}

Future forgroundMessage() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

}

