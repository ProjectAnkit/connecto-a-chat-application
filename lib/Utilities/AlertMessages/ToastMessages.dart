import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Displayerror{

  void toastmessage(String error){
     Fluttertoast.showToast(
      msg: error,
      backgroundColor: Color.fromARGB(255, 219, 62, 62),
      gravity: ToastGravity.BOTTOM,
      textColor: Color.fromARGB(255, 254, 254, 254),
      toastLength: Toast.LENGTH_SHORT
      );
  }
}

class Displaysuccess{

  void toastmessage(String success){
     Fluttertoast.showToast(
      msg: success,
      backgroundColor: Color.fromARGB(255, 14, 204, 99),
      gravity: ToastGravity.BOTTOM,
      textColor: Color.fromARGB(255, 254, 254, 254),
      toastLength: Toast.LENGTH_SHORT
      );
  }
}