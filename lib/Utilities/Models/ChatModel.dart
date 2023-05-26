import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {

  String? sender;
  String? message;
  String? chatid;
  Timestamp? timestamp;
  bool? seen;
  ChatModel({
    this.sender,
    this.message,
    this.chatid,
    this.seen,
    this.timestamp,
  });


  ChatModel fromMap(Map<String,dynamic> map){
    sender = map['sender'];
    message = map['message'];
    chatid = map['chatid'];
    seen = map['seen'];
    timestamp = map['timestamp'];
    return ChatModel(chatid: chatid,message: message,seen: seen,sender: sender,timestamp: timestamp);
  }

  
  Map<String,dynamic> toMap(){
    return{
      "sender": sender,
      "message": message,
      "chatid": chatid,
      "seen": seen,
      "timestamp": timestamp,
    };
  }
}
