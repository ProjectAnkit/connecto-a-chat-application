
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapplication/HomeScreen/HomePageScreen.dart';
import 'package:mychatapplication/HomeScreen/Utilities/GetImageWidget.dart';
import 'package:mychatapplication/Utilities/AlertMessages/ToastMessages.dart';
import 'package:mychatapplication/Utilities/Models/UserModel.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key, required this.OwnUser});
  // ignore: non_constant_identifier_names
  final UserModel OwnUser;

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {

  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _biocontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;


 

  @override
  void dispose() {

    super.dispose();
    _namecontroller.dispose();
    _emailcontroller.dispose();
    _biocontroller.dispose();
  }


 


  Future<void> Uploaddata() async {
    final user = auth.currentUser;

    try{  
       
      await firestore.collection("User").doc(user!.uid).update({
        "name" : _namecontroller.text,
        "email": _emailcontroller.text,
        "bio"  : _biocontroller.text,
      });
    }
    catch(e){
      Displayerror().toastmessage(e.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    _namecontroller.text = widget.OwnUser.name.toString();
    _emailcontroller.text = widget.OwnUser.email.toString();
    _biocontroller.text = widget.OwnUser.bio.toString();

    return Scaffold(
      appBar: AppBar(
       leading: IconButton(icon: const Icon(Icons.arrow_back),onPressed: (){
        Uploaddata();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  HomePageScreen(profileurl: widget.OwnUser.imageurl.toString(),)));
       }),
        backgroundColor: Colors.black,
        title:  Text("connecto",style: GoogleFonts.jost(fontSize: 25),),
        centerTitle: true,  
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           
            Center(
            child: GetImage(OwnUser: widget.OwnUser),
            ),
            
            const SizedBox(
              height: 80,
            ),
            
           
              
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: TextFormField(
                controller: _namecontroller,
                style: GoogleFonts.jost(),
                decoration: InputDecoration(
                  helperText: "Your name",
                  helperStyle: GoogleFonts.jost(),
                ),
              ),
            ),
            
            const SizedBox(
              height: 20,
            ),
            
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 14.0),
               child: TextFormField(
                controller: _biocontroller,
                style: GoogleFonts.jost(),
                maxLength: 60,
                decoration: InputDecoration(
                  helperText: "bio",
                  helperStyle: GoogleFonts.jost(),
                ),
                         ),
             ),
              
            const SizedBox(
              height: 60,
            ),
              
          ],
                ),
        ),
      ),
    );
  }
}