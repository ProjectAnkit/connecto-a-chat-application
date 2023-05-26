import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapplication/LoginPages/Loginpage.dart';
import 'package:mychatapplication/Utilities/AlertMessages/ToastMessages.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/LoadingDialog.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/MyButton.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/MyFieldSpace.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _email = TextEditingController();
  final _password = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection("Users");

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

 void signup(String email,String password)async{

  setState(() {
    loading = true;
  });

    try{  
         Loadingdialog().showloadingdialog(context);
         await auth.createUserWithEmailAndPassword(
          email: email, 
          password: password,
          );

        final user = auth.currentUser;
       
        Displaysuccess().toastmessage("verification link is sent to your email id");
        await user!.sendEmailVerification();
        
       setState(() {
        auth.signOut();
          loading = false;
           _email.clear();
        _password.clear();

        });
    }

    catch(e){
          setState(() {
            auth.signOut();
            loading = false;
             _email.clear;
        _password.clear;

          });
          Navigator.pop(context);
          Displayerror().toastmessage("Incorrect email or already exists");
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
                   
                   Text("Hey there , connect with us !",style: GoogleFonts.jost(color: Colors.white,fontSize: 25),),
      
      
                   const SizedBox(height: 20,),
      
                   MyFieldSpace(
                    controller: _email, 
                    encrypt: false, 
                    hinttext: "enter email", 
                    validator: "eg. xyz@gmail.com"
                    ),
                 
                 const SizedBox(
                  height: 10,
                 ),
        
                 MyFieldSpace(
                    controller: _password, 
                    encrypt: true, 
                    hinttext: "create password", 
                    validator: "eg .4e@4F799_t^"
                    ),
      
      
                 const SizedBox(
                  height: 20,
                ),
      
      
                MyButton(
                  buttontxt: "signup", 
                  loading: loading, 
                  ontap: (){
                      signup(_email.text.toString(),_password.text.toString());
                  }),
      
                  
                
                const SizedBox(
                  height: 5,
                ),
      
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account ?",style: GoogleFonts.jost(color: Colors.white),),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
                      },
                      child: Text(" sign in",style: GoogleFonts.jost(color: Colors.deepPurple),))
                  ],
                ),

                
      
                 
            ],
          ),
        ),
        ]
      ),
    );
  }
}


