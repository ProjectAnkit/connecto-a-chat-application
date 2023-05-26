import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loadingdialog{
  Future showloadingdialog(BuildContext context){
    return showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context){
        return const AlertDialog(
          backgroundColor: Colors.transparent,
          actions: [
            Center(child: SpinKitPouringHourGlass(color: Colors.white,))
          ],
        );
      });
   }
}