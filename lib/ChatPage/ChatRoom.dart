import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:mychatapplication/ChatPage/Utilities/MyTextSpace.dart';
import 'package:mychatapplication/Utilities/Models/ChatModel.dart';
import 'package:mychatapplication/Utilities/Models/ChatRoomModel.dart';
import 'package:mychatapplication/Utilities/Models/UserModel.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.OwnUserModel, required this.targetUser, required this.Chatroom, required this.blocked});

  final ChatRoomModel? Chatroom;
  final UserModel OwnUserModel;
  final UserModel targetUser;
  final bool blocked;
  
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  TextEditingController _msgcontroller = TextEditingController();
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  bool block = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    block = widget.blocked;
  }
   


   void sendmessage()async{
    final user = auth.currentUser;
    String msg = _msgcontroller.text.trim();
    QuerySnapshot snapshot = await firestore.collection("Chatroom").where("unblocked.${user!.uid}",isEqualTo: true).where("unblocked.${widget.targetUser.uid}",isEqualTo: true).get();
     if (snapshot.docs.isNotEmpty) {
      if (msg.isNotEmpty) {
        Timestamp msgtime = Timestamp.now();
        ChatModel messageModel = ChatModel(
          chatid: DateTime.now().millisecondsSinceEpoch.toString(),
          message: msg,
          seen: false,
          sender: user.uid,
          timestamp: msgtime,
        );

        firestore
            .collection("Chatroom")
            .doc(widget.Chatroom!.chatRoomid)
            .collection("messages")
            .doc(messageModel.chatid)
            .set(messageModel.toMap());

        firestore
            .collection("Chatroom")
            .doc(widget.Chatroom!.chatRoomid)
            .update({
          "updatedtime": msgtime,
          "lastmessage": msg,
        });
        _msgcontroller.clear();
        log("message sent");
      }
    }
  }



  @override
  Widget build(BuildContext context) {
   
    final user = auth.currentUser;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 231, 231),
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: true,
        title: ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(widget.targetUser.imageurl.toString()),),
          title: Text(widget.targetUser.name.toString(),style: GoogleFonts.jost(color: Colors.white),),
        subtitle: widget.targetUser.email!.isNotEmpty? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(widget.targetUser.email.toString(),style: GoogleFonts.jost(color: Colors.white),)):
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(widget.targetUser.phoneNumber.toString(),style: GoogleFonts.jost(color: Colors.white),)),
        ),
        actions: [
          PopupMenuButton(       
              itemBuilder: (context){
                return[
                     PopupMenuItem(
                      onTap: (){
                        setState(() {
                          block = true;
                        });
                        firestore.collection("Chatroom").doc(widget.Chatroom!.chatRoomid).update({
                          "unblocked.${widget.targetUser.uid}": false,
                        });
                      },
                      child: Text("block",style: GoogleFonts.jost(),)),


                       PopupMenuItem(
                      onTap: (){
                        setState(() {
                          block = false;
                        });
                        firestore.collection("Chatroom").doc(widget.Chatroom!.chatRoomid).update({
                          "unblocked.${widget.targetUser.uid}": true,
                        });
                      },
                      child: Text("Unblock",style: GoogleFonts.jost(),))
                ];
              }),
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset("assets/ChatBackground.jpg",fit: BoxFit.cover,alignment: Alignment.center)),
          Column(
            children: [
                 Expanded(
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 7.0),
                     child: StreamBuilder(
                      stream: firestore.collection("Chatroom").doc(widget.Chatroom!.chatRoomid).collection("messages").orderBy("timestamp",descending: true).snapshots(),
                      builder: (context,snapshot){
                      
                        if(snapshot.connectionState == ConnectionState.active){
                         
                         ChatModel msg = ChatModel();
                         QuerySnapshot<Object> datasnapshot = snapshot.data as QuerySnapshot<Object>;
                     
                        return GroupedListView<ChatModel, DateTime>(
                          sort: false,
                          reverse: true,
                          elements: datasnapshot.docs.map((doc) {
                            Map<String,dynamic> message = doc.data() as Map<String,dynamic>;
                            return msg.fromMap(message);
                          }).toList(), 
                          groupBy: (msg)
                          {
                            return DateTime(
                              msg.timestamp!.toDate().year,
                              msg.timestamp!.toDate().month,
                              msg.timestamp!.toDate().day,
                             );
                          },
                          groupSeparatorBuilder: (DateTime date) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(DateFormat('MMM d,yyyy').format(date),style: GoogleFonts.jost(fontSize: 12,color: Colors.black),),
                              ),
                            );
                          },
                          itemBuilder: (context, msg) {
                             return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: msg.sender==widget.targetUser.uid?MainAxisAlignment.start:MainAxisAlignment.end,
                              children: [
                                
                                msg.sender==widget.targetUser.uid?
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical:6.0),
                                  child: Text("${msg.timestamp!.toDate().hour}:${msg.timestamp!.toDate().minute}",style: GoogleFonts.jost(color: Colors.black,fontSize: 10),),
                                ):Container(),
                         
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Container(
                                    decoration: BoxDecoration(color:msg.sender==widget.targetUser.uid? Colors.black54:Colors.grey[400],borderRadius: BorderRadius.circular(45)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(msg.message.toString(),style: GoogleFonts.jost(fontSize: 18,color: Colors.white),),
                                    )),
                                ),
                                
                                msg.sender==user!.uid?
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical:6.0),
                                  child: Text("${msg.timestamp!.toDate().hour}:${msg.timestamp!.toDate().minute}",style: GoogleFonts.jost(color: Colors.black,fontSize: 10),),
                                ):Container()
                              ],
                            );
                          },
                          );
                      }
                         
                         
                      else{
                        return const Center(child: CircularProgressIndicator(color: Colors.black),);
                      }
                     }),
                   ),
                 ),
               
                const SizedBox(
                  height: 3,
                ),
          
                block?
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.grey),
                  child: Center(
                    child: Text("blocked",style: GoogleFonts.jost(color: Colors.black),),
                  ),
                ) :         
                Align(
                alignment: Alignment.bottomCenter,
                 child: MyMessageSpace(
                  controller: _msgcontroller,
                  hint: "Type your message",
                  ontap: sendmessage,
                 ),
               )
               
            ],
          ),
        ]
      ),
    );
  }
}