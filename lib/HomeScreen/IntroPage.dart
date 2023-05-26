import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mychatapplication/HomeScreen/HomePageScreen.dart';
import 'package:mychatapplication/Utilities/AlertMessages/ToastMessages.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/LoadingDialog.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/MyButton.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/MyFieldSpace.dart';

class Intropage extends StatefulWidget {
  const Intropage({super.key});

  @override
  State<Intropage> createState() => _IntropageState();
}

class _IntropageState extends State<Intropage> {

  File? image;
  String imageurl = "";
  final imagePicker = ImagePicker();
  bool loading = false;
  final auth = FirebaseAuth.instance;
  String gender = "Male";


    final _namecontroller = TextEditingController();
    final _biocontroller = TextEditingController();
    final storage = FirebaseStorage.instance;
    final firestore = FirebaseFirestore.instance.collection("User");

    


  Future getImage()async{

    final pickedfile = await imagePicker.pickImage(source: ImageSource.gallery,imageQuality: 80);

    if(pickedfile!=null)
    {
       setState(() {
         image = File(pickedfile.path);
         });
    }
    else{
       Displayerror().toastmessage("image not selected");
    }
  }




  Future upload()async{

    setState(() {
      loading = true;
    });

   try{
    Loadingdialog().showloadingdialog(context);

    if(image!=null)
    {
    final ref = storage.ref(DateTime.now().millisecondsSinceEpoch.toString());
    await ref.putFile(image!.absolute);
       imageurl = await ref.getDownloadURL();
    }
    else{
      imageurl = "https://firebasestorage.googleapis.com/v0/b/mychatapp-9a94d.appspot.com/o/Default%20Image.jpg?alt=media&token=a1928579-d01a-4605-8fa9-2cf1f32dac7e";
    }
     
    final user = auth.currentUser;
    
    firestore.doc(user!.uid).set({
      "name": _namecontroller.text.toString(),
      "email" : user.email,
      "profile url" : imageurl,
      "id": user.uid,
      "phone number": user.phoneNumber,
      "bio" : _biocontroller.text.toString(),
      "gender": gender,
    }).then((value) async{

      setState(() {
        loading = false;
      });
      
      // ignore: use_build_context_synchronously
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  HomePageScreen(profileurl: imageurl,)));
    }).onError((error, stackTrace) {

    setState(() {
      loading = false;
    });
     Navigator.pop(context);
    Displayerror().toastmessage(error.toString());
    });
   }

   catch(e){
    setState(() {
      loading = false;
    });
     Navigator.pop(context);
    Displayerror().toastmessage(e.toString());
   }
    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text("connecto",style: GoogleFonts.jost(fontSize: 25)),
        centerTitle: true,
      ),

      body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/AppBackground.png",),fit: BoxFit.fill,alignment: Alignment.center)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 4),
                child: Column(  
                  mainAxisAlignment: MainAxisAlignment.center,       
                  children: [
                      Center(
                        child: InkWell(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(color: Colors.grey[600],borderRadius: BorderRadius.circular(75)),
                            child:image!=null?ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: Image.file(image!.absolute,fit: BoxFit.cover,))
                                 :  Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Upload",style: GoogleFonts.jost(color: Colors.black,fontSize: 15),),
                                  const Icon(Icons.image,size: 30,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(
                        height: 3,
                      ),
                      
                      Text("Create Profile",style: GoogleFonts.jost(color: Colors.white,fontSize: 18),),
                      
                      const SizedBox(
                        height: 30,
                      ),
                      
                      
                      MyFieldSpace(
                        controller: _namecontroller, 
                        encrypt: false, 
                        hinttext: "Full Name", 
                        validator: "please enter your own name"
                        ),
                      
                     const SizedBox(
                      height: 10,
                     ),
                    
                    
                     MyFieldSpace(
                        controller: _biocontroller, 
                        encrypt: false, 
                        hinttext: "Bio", 
                        validator: "please enter your bio"
                        ),
                    
                    
                    const SizedBox(
                      height: 20,
                     ),
                 
                     
                    Row(
                      children: [
                        Text("Select your gender : ",style: GoogleFonts.jost(color: Colors.grey,fontSize: 18),),
                        Container(
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: DropdownButton(  
                                underline: Container(
                                  height: 1,
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                dropdownColor: Colors.grey,
                                value: gender,
                                items: ['Male','Female','transgender'].map((String value){
                                  return DropdownMenuItem<String>(
                                    onTap: (){
                                      setState(() {
                                      gender = value;
                                         });
                                    },
                                    value: value,
                                    child: Text(value,style: GoogleFonts.jost(color: Colors.white),));
                                }).toList(),
                                onChanged: (value){
                                  setState(() {
                                     gender = value.toString();
                                     });
                                }),
                            ),
                          ),
                        ),
                      ],
                    ),


                    const SizedBox(
                      height: 20,
                    ),
                    
                                    
                     MyButton(
                      buttontxt: "Continue", 
                      loading: loading, 
                      ontap: (){
                         
                        upload();
                           
                      })
                  ],
                ),
              ),
            ),
        ),
      
      
          
    );
  }
}