import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.buttontxt, required this.loading, required this.ontap});

  final String buttontxt;
  final bool loading;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10)),
        child: Center(
          child: Text(buttontxt,style: GoogleFonts.jost(color: Colors.white,fontSize: 16),),
        ),
      ),
    );
  }
}