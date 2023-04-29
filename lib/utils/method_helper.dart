

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'constants.dart';
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

  static void transitionPage(BuildContext context,Widget childCurrent,Widget nextWidget,PageNavigatorType pageNavigatorType,PageTransitionType pageTransitionType){

    switch(pageNavigatorType){
      case PageNavigatorType.PUSH:
        Navigator.of(context).push(
            PageTransition(childCurrent: childCurrent,child: nextWidget, type: pageTransitionType, duration: Duration(milliseconds: PAGE_TRANSITION_DURATION))
        );
        break;
      case PageNavigatorType.PUSH_REPLACEMENT:
        Navigator.of(context).pushReplacement(
            PageTransition(childCurrent: childCurrent,child: nextWidget, type: pageTransitionType, duration: Duration(milliseconds: PAGE_TRANSITION_DURATION))
        );
        break;
      default:
        break;
    }

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














