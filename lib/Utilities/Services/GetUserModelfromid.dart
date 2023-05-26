import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mychatapplication/Utilities/Models/UserModel.dart';

class getUserModel{
 
    Future<UserModel?> getUserModelfromuid(String uid)async{
    UserModel targetModel = UserModel();
    QuerySnapshot document = await FirebaseFirestore.instance.collection("User").where("id",isEqualTo: uid).get();

    if(document.docs.isNotEmpty)
    {
    Map<String,dynamic> targetUserMap = document.docs[0].data() as Map<String,dynamic>;
    UserModel targetUser = targetModel.fromMap(targetUserMap);
    return targetUser;
    }
    return null;    
  }
}