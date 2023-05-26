import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapplication/HomeScreen/HomePageScreen.dart';
import 'package:mychatapplication/HomeScreen/IntroPage.dart';
import 'package:mychatapplication/Utilities/AlertMessages/ToastMessages.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/LoadingDialog.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/MyButton.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CodeVerifyScreen extends StatefulWidget {
  const CodeVerifyScreen({super.key, required this.verificationId});
  
  final String verificationId;

  @override
  State<CodeVerifyScreen> createState() => _CodeVerifyScreenState();
}

class _CodeVerifyScreenState extends State<CodeVerifyScreen> {

  final _codecontroller = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              children:
                 [
                Text("Verify via 6-digit code that come to your number via sms",style: GoogleFonts.jost(color: Colors.white,fontSize: 17),)
                 ]
                ),
    
    
             
            const SizedBox(
              height: 10,
            ),
    
    
    
            PinCodeTextField(
              keyboardType: TextInputType.number,            
              textStyle: GoogleFonts.lato(color: Colors.white),
              pinTheme: PinTheme(             
                inactiveColor: Colors.grey,
                activeColor: Colors.black,
                borderWidth: 1,
                selectedColor: Colors.grey,
                shape: PinCodeFieldShape.circle,
               borderRadius: BorderRadius.circular(10)
              ),
              controller: _codecontroller,
              appContext: context, 
              length: 6, 
              onChanged: (value) {
                
              },
             ),
      
      
              const SizedBox(
                height: 15,
              ),
              
      
              MyButton(
                buttontxt: "Submit", 
                loading: loading, 
                ontap: ()async{
    
                  setState(() {
                    loading = true;
                  });
                  
                  final credential = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId, 
                    smsCode: _codecontroller.text.toString());
    
                  await auth.signInWithCredential(credential).then((value) async {
    
                    setState(() {
                      loading = false;
                    });
                    Loadingdialog().showloadingdialog(context);
                    final user = auth.currentUser;
                    final userdoc = await FirebaseFirestore.instance.collection("User").doc(user!.uid).get();
                    Map<String,dynamic> userdata = userdoc.data() as Map<String,dynamic>;
                    String imageurl = userdata['profile url'].toString();
                    if(userdoc.exists)
                    {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePageScreen(profileurl: imageurl,)));
                    }
                    else{
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Intropage()));
                    }
    
                  }).onError((error, stackTrace) {
    
                    setState(() {
                      loading = false;
                    });
                    Navigator.pop(context);
                    Displayerror().toastmessage(error.toString());
                  });
      
                })
          ],
        ),
      ),
      ]
    ),
    );
  }
}