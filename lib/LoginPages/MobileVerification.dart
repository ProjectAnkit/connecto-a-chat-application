import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mychatapplication/LoginPages/CodeVerification.dart';
import 'package:mychatapplication/Utilities/AlertMessages/ToastMessages.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/LoadingDialog.dart';
import 'package:mychatapplication/Utilities/CustomWidgets/MyButton.dart';

class MobileVerifyScreen extends StatefulWidget {
  const MobileVerifyScreen({super.key});

  @override
  State<MobileVerifyScreen> createState() => _MobileVerifyScreenState();
}

class _MobileVerifyScreenState extends State<MobileVerifyScreen> {

  final _mobcontroller = TextEditingController();
  bool loading = false;
  final auth = FirebaseAuth.instance;
  String countrycode = "";

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
                Text("Please enter your phone number for verification",style: GoogleFonts.jost(color: Colors.white,fontSize: 17),)
                 ]
                ),
    
    
             
            const SizedBox(
              height: 20,
            ),
    
    
    
            Row(
                children: [
                  CountryCodePicker(
                    textStyle: GoogleFonts.jost(color: Colors.white),
                    onChanged: (value) {  
                      setState(() {
                         countrycode = value.dialCode.toString();
                      });
                    },
                  ),

                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextFormField(
                          maxLength: null,
                          style: GoogleFonts.jost(color: Colors.white),
                          keyboardType: TextInputType.number,
                          controller: _mobcontroller,
                          obscureText: false,
                          validator: (value) {
                            if (_mobcontroller.text.isEmpty) {
                              return "eg . 999 3333 777";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "phone number",
                              hintStyle: GoogleFonts.jost(color: Colors.grey)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      
      
              const SizedBox(
                height: 15,
              ),
              
      
              MyButton(
                buttontxt: "verify", 
                loading: loading, 
                ontap: (){
                   
                    setState(() {
                      loading = true;
                    });
                      
                     try{
                       Loadingdialog().showloadingdialog(context);
                       auth.verifyPhoneNumber(
                        phoneNumber: countrycode+_mobcontroller.text,
                        verificationCompleted: (_){
                            setState(() {
                              loading = false;
                            });
                        }, 
                        verificationFailed: (e){
                          setState(() {
                            loading = false;
                          });
                          Displayerror().toastmessage(e.toString());
                        }, 
                        codeSent: (verificationId, forceResendingToken) {
                          setState(() {
                            loading = false;
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> CodeVerifyScreen(verificationId: verificationId,)));
                        }, 
                        codeAutoRetrievalTimeout: (verificationId){
                          setState(() {
                            loading = false;
                          });
    
                        });
                     }
    
    
                     catch(e){
                      setState(() {
                        loading = false;
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