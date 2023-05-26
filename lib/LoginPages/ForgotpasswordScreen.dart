import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapplication/Utilities/AlertMessages/ToastMessages.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/LoadingDialog.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/MyButton.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/MyFieldSpace.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final auth = FirebaseAuth.instance;
  final _emailcontroller = TextEditingController();
  bool loading = false;
  

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailcontroller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        automaticallyImplyLeading: true,
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
              Wrap(
                children: [
                  Text("Enter the email id which is linked to your connecto account",style: GoogleFonts.jost(color: Colors.white,fontSize: 17),),
                ],
              ),
      
              const SizedBox(
                height: 5,
              ),
      
              MyFieldSpace(
                controller: _emailcontroller, 
                encrypt: false, 
                hinttext: "enter email", 
                validator: "eg. xyz@gmail.com"
                ),
        
              const SizedBox(
                height: 10,
              ),
        
              
              MyButton(
                buttontxt: "submit", 
                loading: loading, 
                ontap: ()async{
                  setState(() {
                    loading = true;
                  });
                   
                 try{
                  Loadingdialog().showloadingdialog(context);
                  auth.sendPasswordResetEmail(email: _emailcontroller.text.toString());
      
                  Displaysuccess().toastmessage("password reset mail is sent to your email account which is linked to connecto");
      
                  setState(() {
                    loading = false;
                    _emailcontroller.clear();
                  });
                 }
      
                 catch(e){
                  setState(() {
                    loading = false;
                    _emailcontroller.clear();
                  });
                  Navigator.pop(context);
                  Displayerror().toastmessage(e.toString());
                 }
                 
                })
            ],
          ),
        ),
        ]
      ),
    );
  }
}