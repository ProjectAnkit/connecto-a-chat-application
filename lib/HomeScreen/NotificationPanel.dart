import 'package:flutter/material.dart';

class NotificationPanel extends StatefulWidget {
  const NotificationPanel({super.key, this.title, this.notification});
  final String? title;
  final String? notification;

  @override
  State<NotificationPanel> createState() => _NotificationPanelState();
}

class _NotificationPanelState extends State<NotificationPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Notification Panel"),
        centerTitle: true,
      ),

      body: Column(
        children: [
           ListTile(
            title: Text(widget.title.toString()),
            subtitle: Text(widget.notification.toString()),
            leading: Icon(Icons.circle_notifications,color: Colors.black,size: 40,),
           )
        ],
      ),
    );
  }
}