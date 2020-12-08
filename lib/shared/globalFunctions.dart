import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:trevo/shared/colors.dart';
bool emailRegexPass(String email){
  bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  return emailValid;
}

bool passwordRegexPass(String password){
  if(password.length>=6){
    return true;
  }else{
    return false;
  }
}


void showFlashBar(String message,BuildContext context){
  Flushbar(
    message: message,
    backgroundColor: Colors.blueGrey[900],
    duration: Duration(seconds: 3),
    flushbarStyle: FlushbarStyle.FLOATING,
    icon: Icon(Icons.error,size: 26,color: Colors.redAccent,),
    leftBarIndicatorColor: Colors.redAccent,
  )..show(context);
}


void showNormalFlashBar(String title,String message,BuildContext context){
  Flushbar(
    message: message,
    title: title,
    backgroundColor: Colors.blueGrey[900],
    duration: Duration(seconds: 3),
    flushbarStyle: FlushbarStyle.FLOATING,
    icon: Icon(Icons.notifications,size: 26,color: Colors.green,),
    leftBarIndicatorColor: Colors.green,
  )..show(context);
}