

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'enums.dart';

class MethodHelper{

  static Future<bool> hasInternetConnection() async{
    try{
      final result = await InternetAddress.lookup('www.google.com');
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
        return true;
      }
    } on SocketException catch (_){
      return false;
    }
    return false;
  }


  static void showSnackBar(BuildContext context,Color backgroundColor,label){
    var snackBar = SnackBar(
      backgroundColor: backgroundColor,
      content: Text('ola'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String capitalize(String value){
    String capitalizedText = value[0].toUpperCase() + value.substring(1).toLowerCase();
    return capitalizedText;
  }

}














