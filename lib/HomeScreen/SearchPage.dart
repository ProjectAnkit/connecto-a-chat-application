import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapplication/ChatPage/ChatRoom.dart';
import 'package:mychatapplication/ChatPage/CustomWidget/UsersCard.dart';
import 'package:mychatapplication/Utilities/Models/ChatRoomModel.dart';
import 'package:mychatapplication/Utilities/Models/UserModel.dart';

class SearchPageScreen extends StatefulWidget {
  const SearchPageScreen({super.key, required this.OwnUser});
  final UserModel OwnUser;

  @override
  State<SearchPageScreen> createState() => _SearchPageScreenState();
}

class _SearchPageScreenState extends State<SearchPageScreen> {


  final _searchcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;


  Future <ChatRoomModel?> getChatRoomid(UserModel targetUser)async{
    
    ChatRoomModel chatRoom = ChatRoomModel();
    ChatRoomModel finalChatroom;
    final user = auth.currentUser;
    QuerySnapshot snapshot = await firestore.collection("Chatroom").where("participants.${user!.uid}",isEqualTo: true).where("participants.${targetUser.uid}",isEqualTo: true).get();
 
    if(snapshot.docs.isNotEmpty){
      Map<String,dynamic> exisChatroom = snapshot.docs[0].data() as Map<String,dynamic>;

      ChatRoomModel existingChatroom = chatRoom.fromMap(exisChatroom);
      finalChatroom = existingChatroom;
      
      return finalChatroom;
    }

    else {

     ChatRoomModel newChatRoom = ChatRoomModel(
      chatRoomid: DateTime.now().millisecondsSinceEpoch.toString(),
      lastmessage: "",
      participants: {
       user.uid.toString(): true,
        targetUser.uid.toString(): true,
      },
      unblocked: {
        user.uid.toString(): true,
        targetUser.uid.toString(): true,
      },
      updatedtime: Timestamp.now(),
      createdon: Timestamp.now(),
      users: [user.uid.toString(),targetUser.uid.toString()],

     );
     await firestore.collection("Chatroom").doc(newChatRoom.chatRoomid).set(newChatRoom.toMap());
     finalChatroom = newChatRoom;
     return finalChatroom;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black,
        title:  Text("connecto",style: GoogleFonts.jost(fontSize: 25),),
        centerTitle: true,
        
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0,vertical: 5),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
      
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                     height: 60,
                     width: MediaQuery.of(context).size.width*0.8,
                     decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(65),border: Border.all(color: Colors.grey)),
                     child: Padding(
                       padding: const EdgeInsets.only(left: 14.0),
                       child: Center(
                         child: TextFormField(
                           controller: _searchcontroller,
                           decoration:  InputDecoration(
                             border: InputBorder.none,
                             hintText: "Search user",
                             hintStyle: GoogleFonts.jost(),
                           ),
                         ),
                       ),
                     ),
                ),

                IconButton(onPressed: (){setState(() {});}, icon: Icon(Icons.search), color: Colors.black,)
              ],
            ),
      
            const SizedBox(
              height: 5,
            ),
      
            const Divider(),
      
            const SizedBox(
              height: 10,
            ),
            
      
            StreamBuilder(
              stream: firestore.collection("User").where("email",isGreaterThanOrEqualTo: _searchcontroller.text.toString(),isLessThan: _searchcontroller.text.toString()+ "z").where("email",isNotEqualTo: widget.OwnUser.email).snapshots(),
              builder: ((context, snapshot){    

                if(snapshot.connectionState == ConnectionState.waiting){
                  
                  return Text("loading...",style: GoogleFonts.jost(),);
                }
                
                else if(snapshot.data!.docs.isEmpty)
                {
                   return Text("no results found",style: GoogleFonts.jost(),);
                }


                else {
                QuerySnapshot<Object> datasnapshot = snapshot.data as QuerySnapshot<Object>;
                
                 return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index){
                      UserModel searchedUser = UserModel();
                      Map<String,dynamic> userModel = datasnapshot.docs[index].data() as Map<String,dynamic>;
                      UserModel targetuser = searchedUser.fromMap(userModel);
                       return InkWell(
                        onTap: () async{
                          ChatRoomModel? chatroom = await getChatRoomid(targetuser);
                          // ignore: use_build_context_synchronously
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatPage(
                            Chatroom: chatroom, 
                            OwnUserModel: widget.OwnUser, 
                            targetUser: searchedUser, 
                            ),),);
                        },
                         child: UserCard(
                          targetUser: targetuser,
                          subtitle: targetuser.email!.isEmpty? targetuser.phoneNumber.toString(): targetuser.email.toString(),
                          imageurl: targetuser.imageurl.toString(),
                          name:targetuser.name.toString(),
                          msgtime: "", 
                          uid: targetuser.uid.toString(),
                         ),
                       );
                    }),
                );
                }

              })
              ),
          ],
        ),
      ),
    );
  }
}