
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapplication/ChatPage/ChatRoom.dart';
import 'package:mychatapplication/ChatPage/CustomWidget/UsersCard.dart';
import 'package:mychatapplication/HomeScreen/SearchPage.dart';
import 'package:mychatapplication/HomeScreen/ViewProfilePage.dart';
import 'package:mychatapplication/LoginPages/Loginpage.dart';
import 'package:mychatapplication/Utilities/Models/ChatRoomModel.dart';
import 'package:mychatapplication/Utilities/Models/UserModel.dart';
import 'package:mychatapplication/Utilities/Services/GetUserModelfromid.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key, this.profileurl}); 
  final String? profileurl;

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  getUserModel _getUserModel = getUserModel();
  bool block = false;
 
  @override
  Widget build(BuildContext context) {
     final user = auth.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          final userdoc = await firestore.collection("User").doc(user!.uid).get();
          Map<String,dynamic> userdata = userdoc.data() as Map<String,dynamic>;
          String profilepic = userdata["profile url"].toString(); 
          String name = userdata["name"].toString();
          String email = userdata["email"].toString();
          String bio = userdata["bio"].toString();
          String phoneNuber = userdata["phoneNumber"].toString();
           // ignore: use_build_context_synchronously
           Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPageScreen(
            OwnUser: UserModel(
              bio: bio,
              email: email,
              imageurl: profilepic,
              name: name,
              phoneNumber: phoneNuber,
            )),
           ),
           );
          }
        ,backgroundColor: Colors.black,child: const Icon(Icons.person_add_alt_sharp,color: Colors.white,),
      ),
      
      appBar:AppBar(
        leading: IconButton(onPressed: (){
                 auth.signOut();
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
        }, icon: Icon(Icons.logout_rounded)),
        backgroundColor: Colors.black,
        title: Text("connecto",style: GoogleFonts.jost(fontSize: 25)),
        centerTitle: true,
        actions: [
            InkWell(
              onTap: ()async{
          
          final userdoc = await firestore.collection("User").doc(user!.uid).get();
          Map<String,dynamic> userdata = userdoc.data() as Map<String,dynamic>;
          String profilepic = userdata["profile url"].toString(); 
          String name = userdata["name"].toString();
          String email = userdata["email"].toString();
          String bio = userdata["bio"].toString();
          String phoneNuber = userdata["phoneNumber"].toString();
           // ignore: use_build_context_synchronously
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewProfilePage(
            OwnUser: UserModel(
              bio: bio,
              email: email,
              imageurl: profilepic,
              name: name,
              phoneNumber: phoneNuber,
            )),
           ),
           );

              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.black,
                backgroundImage: CachedNetworkImageProvider(widget.profileurl.toString()),
                  ),
            ),
            SizedBox(width: 8,)
        ],
      ),
      
      
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children:  [
              Expanded(
                child: StreamBuilder(
                  stream: firestore.collection("Chatroom").where("users",arrayContains: user!.uid.toString()).orderBy("updatedtime").snapshots(),
                  builder: (context,snapshot){
                    ChatRoomModel RoomModel = ChatRoomModel();
              
                   if(snapshot.connectionState == ConnectionState.waiting){
                    return Container();
                   }
              
                   else{
                     if(snapshot.hasData)
                     {
                       QuerySnapshot<Object> dataSnapshot = snapshot.data as QuerySnapshot<Object>;
      
                     return ListView.builder(
                      itemCount: dataSnapshot.docs.length,
                      itemBuilder: (context,index){
                        
                        Map<String,dynamic> roommodel = dataSnapshot.docs[index].data() as Map<String,dynamic>;
                        ChatRoomModel chatRoomModel = RoomModel.fromMap(roommodel);
      
                        Map<String,dynamic> participants = chatRoomModel.participants as Map<String,dynamic>;
                        List<String> participantskeys = participants.keys.toList();
      
                        participantskeys.remove(user.uid);
                        
                        
                        return FutureBuilder(
                        
                        future: _getUserModel.getUserModelfromuid(participantskeys[0].toString()),
                        builder: (context,snapshot){
                          
                          
                          if(snapshot.connectionState == ConnectionState.done)
                          {
                            UserModel targetUser = snapshot.data as UserModel;
                             if(snapshot.hasData)
                             {
                               return InkWell(
                                onTap: ()async{
                                  QuerySnapshot unblock = await firestore.collection("Chatroom").where("unblocked.${user.uid}",isEqualTo: true).where("unblocked.${targetUser.uid}",isEqualTo: true).get();
                                  final userdoc = await firestore.collection("User").doc(user.uid).get();
                                  Map<String,dynamic> userdata = userdoc.data() as Map<String,dynamic>;
                                  String profilepic = userdata["profile url"].toString();
                                  String name = userdata["name"].toString();
                                  String email = userdata["email"].toString();
                                  String bio = userdata["bio"].toString();
                                  String phoneNuber = userdata["phoneNumber"].toString();
                                  
                                  if(unblock.docs.isEmpty)
                                  {
                                     setState(() {
                                       block = true;
                                     });
                                  }
                                  else
                                  {
                                    setState(() {
                                      block = false;
                                    });
                                  }
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatPage(
                                    OwnUserModel: UserModel(
                                      bio: bio,
                                      email: email,
                                      imageurl: profilepic,
                                      name: name,
                                      phoneNumber: phoneNuber,
                                    ),
                                    targetUser: targetUser, 
                                    Chatroom: chatRoomModel,
                                    blocked: block,
                                    )
                                     )
                                    );
                                },
                                 child: Column(
                                  children: [
                                    UserCard(
                                      targetUser: targetUser,
                                      name: targetUser.name.toString(), 
                                      subtitle: chatRoomModel.lastmessage.toString(),
                                      imageurl: targetUser.imageurl.toString(),
                                      uid: targetUser.uid.toString(),
                                      msgtime: "${chatRoomModel.updatedtime!.toDate().hour}:${chatRoomModel.updatedtime!.toDate().minute}",
                                      ),
                                      const Divider(color: Colors.grey,thickness: 0.2),
                                  ],
                                 ),
                               );
                             }
                             else{
                              return Container();
                             }
                          }
      
                          else{
                            return Container();
                          }
                        });
                      });
                     }

                     else{
                      return Center(child: Text("No messages yet!",style: GoogleFonts.jost(color: Colors.black),));
                     }
                   }
                  }),
              )
          ],
        ),
      ),
    );
  }
}