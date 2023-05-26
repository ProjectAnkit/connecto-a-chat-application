// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoomModel {

  String? chatRoomid;
  String? lastmessage;
  Timestamp? updatedtime;
  Timestamp? createdon;
  Map<String,dynamic>? participants;
  Map<String,dynamic>? unblocked;
  List<dynamic>?users;

  ChatRoomModel({
    this.chatRoomid,
    this.lastmessage,
    this.updatedtime,
    this.createdon,
    this.participants,
    this.unblocked,
    this.users,
  });


  ChatRoomModel fromMap(Map<String,dynamic> map){
    chatRoomid = map["chatRoomid"];
    participants = map["participants"];
    lastmessage = map["lastmessage"];
    updatedtime = map["updatedtime"];
    createdon = map["createdon"];
    unblocked = map["unblocked"];
    users = map["users"];
    return ChatRoomModel(chatRoomid: chatRoomid,participants: participants,lastmessage: lastmessage,updatedtime: updatedtime, createdon :createdon,users: users,unblocked: unblocked);
  }


  Map<String,dynamic> toMap(){
    return{
      "chatRoomid" : chatRoomid,
      "participants" : participants,
      "lastmessage": lastmessage,
      "updatedtime": updatedtime,
      "createdon": createdon,
      "unblocked": unblocked,
      "users": users
    };
  }
}
