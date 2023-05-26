import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyFieldSpace extends StatelessWidget {
  const MyFieldSpace({super.key, required this.controller, required this.encrypt, required this.hinttext, this.validator, this.textInputType, this.Textlength});

  final TextEditingController controller;
  final bool encrypt;
  final String hinttext;
  final String? validator;
  final TextInputType? textInputType;
  final int? Textlength;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            maxLength: Textlength,
            style: GoogleFonts.jost(color: Colors.white),
            keyboardType: textInputType,
            controller: controller,
            obscureText: encrypt,
            validator: (value) {
              if(controller.text.isEmpty){
                  return validator;
              }
              else{
                  return null;
              }
            },
            decoration: InputDecoration( 
              border: InputBorder.none,
              hintText: hinttext,
              hintStyle: GoogleFonts.jost(color: Colors.grey)
              ),
          ),
        ),
      ),
    );
  }
}