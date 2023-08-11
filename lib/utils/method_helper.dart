

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import '../state_management/make_appointments_state.dart';
import '../state_management/choose_shop_state.dart';
import '../state_management/fill_profile_state.dart';
import '../style/general_style.dart';
import '../ui_items/my_label.dart';
import '../view_model/choose_schedule/choose_schedule_view_model_imp.dart';
import '../view_model/fill_profile/fill_profile_view_model_imp.dart';
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
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => nextWidget,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            maintainState: false, // Prevents maintaining the state of ChooseProfessional
          ),
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

  static void showSnackBar(BuildContext context,SnackBarType snackBarType,label){
    var snackBar = SnackBar(
      backgroundColor: snackBarType == SnackBarType.SUCCESS ? green : red,
      content: MyLabel(
        type: MyLabelType.BODY_MEDIUM,
        fontWeight: MyLabel.MEDIUM,
        label: label,
        color: light1,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String capitalize(String value){
    String capitalizedText = value[0].toUpperCase() + value.substring(1).toLowerCase();
    return capitalizedText;
  }

  static Future<File?> testCompressAndGetFile(File file) async {

    List<String> parts = file.absolute.path.split('/');
    String filenameWithExt = parts.last;
    String fileFormat = filenameWithExt.split('.').last;

    var dir = await getTemporaryDirectory();
    var targetPath = dir.absolute.path + "/temp.$fileFormat";
    var result;

    try{
      result = await FlutterImageCompress.compressAndGetFile(
        format: fileFormat == 'png' ? CompressFormat.png : CompressFormat.jpeg,
        file.absolute.path,
        targetPath,
        quality: 80,
      );
    }catch(e){
      print(e);
    }


    return result;
  }

  static clearFillProfileControllers(WidgetRef ref) async{
    FillProfileModelImp().setValue(imagePathProvider.notifier, ref, PROFILE_IMAGE_DIRECTORY);
    FillProfileModelImp().setValue(firstNameProvider.notifier, ref, '');
    FillProfileModelImp().setValue(lastNameProvider.notifier, ref, '');
    FillProfileModelImp().setValue(dateOfBirthProvider.notifier, ref, '');
    FillProfileModelImp().setValue(emailProvider.notifier, ref, '');
    FillProfileModelImp().setValue(phoneNumberProvider.notifier, ref, '');
  }

  static Future<File> returnFillProfileImage(String localImageDirectory) async {
    var bytes = await rootBundle.load(localImageDirectory);
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/profile.png');
    await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file;
  }

  static String convertHourAndMinuteToFormattedDate(int hour,int minute) {
    String hourDate = hour < 10 ? "0"+ hour.toString() : hour.toString();
    String minuteDate = minute < 10 ? "0"+ minute.toString() : minute.toString();
    return hourDate + ":" + minuteDate;
  }

  static TimeOfDay convertTimestampToTimeOfDay(Timestamp timestamp){
    DateTime date = timestamp.toDate();
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }

  static Timestamp convertTimeOfDayToTimestamp(TimeOfDay timeOfDay){
    DateTime now = DateTime.now(); // Get the current date to create a DateTime object
    DateTime dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return Timestamp.fromDate(dateTime);
  }

  static double timeOfDayToDouble(TimeOfDay myTime){
    return myTime.hour + myTime.minute/60.0;
  }

  static void cleanAppointmentsVariables(WidgetRef ref){
    ChooseScheduleViewModelImp().setValue(currentProfessionalIndexProvider.notifier, ref, -1);
    ChooseScheduleViewModelImp().setValue(currentServiceIndexProvider.notifier, ref, -1);
    ChooseScheduleViewModelImp().setValue(currentSlotIndexProvider.notifier, ref, -1);
    ChooseScheduleViewModelImp().setValue(currentAppointmentIndexProvider.notifier, ref, 0);
    ChooseScheduleViewModelImp().setValue(selectedDayProvider.notifier, ref, DateTime.now());
  }

  static Future<Uint8List?> getImageAndCovertToUint8list(String path) async{
    final storageRef = FirebaseStorage.instance.ref();

    final islandRef = storageRef.child(path);

    try {
      const oneMegabyte = 1024 * 1024 * 5;
      final Uint8List? data = await islandRef.getData(oneMegabyte);
      return data;
    } on Error catch (e) {
      print(e.toString());
    }
    return null;
  }

}














