import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapplication/HomeScreen/HomePageScreen.dart';
import 'package:mychatapplication/HomeScreen/IntroPage.dart';
import 'package:mychatapplication/LoginPages/ForgotpasswordScreen.dart';
import 'package:mychatapplication/LoginPages/MobileVerification.dart';
import 'package:mychatapplication/SignUpPages/SignUpPage.dart';
import 'package:mychatapplication/Utilities/AlertMessages/ToastMessages.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/LoadingDialog.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/MyButton.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/MyFieldSpace.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final firestore = FirebaseFirestore.instance.collection("User");

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _password.dispose();

  }



   void signin(String email,String password)async{

    setState(() {
      loading  = true;
    }); 
  
    try{
       Loadingdialog().showloadingdialog(context);
       await auth.signInWithEmailAndPassword(
        email: email, 
        password: password);

        final user = auth.currentUser;
    
       if(user!=null && user.emailVerified)
       {
           
           final userdoc = await firestore.doc(user.uid).get();

           if(userdoc.exists)
           {
                  Map<String,dynamic> userdata = userdoc.data() as Map<String,dynamic>;
                  String profilepic = userdata["profile url"].toString(); 
                  await Future.delayed(Duration(seconds: 3));
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  HomePageScreen(profileurl: profilepic,)));
           }
           else{
              await Future.delayed(Duration(seconds: 3));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>  Intropage()));
           }

            setState(() {
             loading = false;
             _email.clear();
             _password.clear();
           });
                        
       }

       else{
        setState(() {
          loading = false;
          _email.clear();
        _password.clear();
        });
        Navigator.pop(context);
        Displayerror().toastmessage("user id doesn't exist, signup to create an account");
        auth.signOut();
       }
    }


    catch(e){
      setState(() {
        loading = false;
         _email.clear;
        _password.clear;
      });
       Navigator.pop(context);
      Displayerror().toastmessage(e.toString());
    }
   }



  @override
  Widget build(BuildContext context) {
    return Scaffold(     
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        title: Text("connecto",style: GoogleFonts.jost(fontSize: 25)),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset("assets/AppBackground.png",fit: BoxFit.cover,alignment: Alignment.center)),
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                   
                   Text("Hey there , welcome back !",style: GoogleFonts.jost(color: Colors.white,fontSize: 25),),
      
      
                   const SizedBox(height: 20,),
      
                   MyFieldSpace(
                    controller: _email, 
                    encrypt: false, 
                    hinttext: "email", 
                    validator: "eg. xyz@gmail.com"
                    ),
                 
                 const SizedBox(
                  height: 10,
                 ),
        
                 MyFieldSpace(
                    controller: _password, 
                    encrypt: true, 
                    hinttext: "password", 
                    validator: "eg .4e@4F799_t^"
                    ),
      
      
                    const SizedBox(
                      height: 5,
                    ),
      
      
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> const ForgotPasswordScreen()));
                    },
                    child: Text("Forgot Password?",style: GoogleFonts.jost(color: Colors.deepPurple),),
                  ),
                ),
      
         
                 const SizedBox(
                  height: 20,
                ),
      
      
                MyButton(
                  buttontxt: "login", 
                  loading: loading, 
                  ontap: (){
                       signin(_email.text.toString(), _password.text.toString());
                  }),
      
                  
                
                const SizedBox(
                  height: 5,
                ),
      
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account ?",style: GoogleFonts.jost(color: Colors.white),),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpPage()));
                      },
                      child: Text(" sign up",style: GoogleFonts.jost(color: Colors.deepPurple),))
                  ],
                ),
      
                 
               const SizedBox(
                  height: 20,
                ),


                InkWell(
                  onTap: (){
      
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  MobileVerifyScreen()));
                              
                  },
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(border: Border.all(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                    child: Center(
                      child: Text("Using phone number",style: GoogleFonts.jost(color: Colors.white,fontSize: 16),),
                    ),
                  ),
                )
                
            ],
          ),
        ),
        ]
      ),
    );
  }
}