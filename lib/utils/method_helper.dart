

import 'dart:io';
import 'dart:math';

import 'package:appointment_app_v2/view_model/choose_professional/choose_professional_view_model_imp.dart';
import 'package:appointment_app_v2/view_model/choose_schedule/choose_schedule_view_model_imp.dart';
import 'package:appointment_app_v2/view_model/choose_service/choose_service_view_model_imp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../state_management/fill_profile_state.dart';
import '../state_management/make_appointments_state.dart';
import '../ui_items/my_dialog.dart';
import '../view_model/fill_profile/fill_profile_view_model_imp.dart';
import '../view_model/make_appointment_screen/make_appointment_screen_view_model_imp.dart';
import 'constants.dart';
import 'enums.dart';

class MethodHelper{

  /// Checks if the device has an active internet connection.
  ///
  /// This function performs a DNS lookup for the 'www.google.com' domain to determine if the device has internet connectivity. It returns a [Future<bool>] indicating whether the device is connected to the internet.
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  /// Handles navigation between screens based on the specified [PageNavigatorType].
  ///
  /// This function switches between different screens using the [Navigator] class. The [type] parameter determines the navigation behavior, and the [screenToNavigate] parameter specifies the screen to navigate to. The [currentScreen] parameter is optional and represents the current screen from which navigation is initiated.
  static void switchPage(BuildContext context, PageNavigatorType type, Widget screenToNavigate, Widget? currentScreen) {
    switch (type) {
      case PageNavigatorType.PUSH:
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeftJoined,
            child: screenToNavigate,
            childCurrent: currentScreen,
            duration: const Duration(milliseconds: PAGE_TRANSITION_DURATION),
          ),
        );
        break;
      case PageNavigatorType.PUSH_REMOVE_UNTIL:
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeftJoined,
            child: screenToNavigate,
            childCurrent: currentScreen,
            duration: const Duration(milliseconds: PAGE_TRANSITION_DURATION),
          ),
              (Route<dynamic> route) => false,
        );
        break;
      case PageNavigatorType.PUSH_NEW_PAGE:
        pushNewScreen(
          context,
          screen: screenToNavigate,
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
        break;
    }
  }

  /// Displays a custom alert dialog with the specified [type] and [label].
  ///
  /// This function shows a custom alert dialog using the [showDialog] function. The [context] parameter specifies the context in which the dialog should be displayed. The [type] parameter determines the appearance and behavior of the dialog, and the [label] parameter provides the message to display in the dialog. The dialog has a positive button that dismisses the dialog when pressed.
  static void showDialogAlert(BuildContext context, MyDialogType type, String label) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MyDialog(
          type: type,
          label: label,
          positiveButtonOnPressed: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  /// Capitalizes the first letter of the input string and converts the rest to lowercase.
  ///
  /// This function takes an [value] input string and returns a new string where the first letter is capitalized and the rest of the letters are converted to lowercase. The original input string is not modified.
  ///
  /// Example:
  /// ```dart
  /// String input = "hElLo";
  /// String result = capitalize(input); // Result: "Hello"
  /// ```
  static String capitalize(String value) {
    String capitalizedText = value[0].toUpperCase() + value.substring(1).toLowerCase();
    return capitalizedText;
  }

  /// Compresses the input file using FlutterImageCompress and returns the compressed file.
  ///
  /// This function takes an [file] input File and compresses it using the FlutterImageCompress library. The compressed file is saved as a new temporary file and returned. If compression fails, null is returned.
  ///
  /// Example:
  /// ```dart
  /// File input = File("path/to/original/image.jpg");
  /// File? compressedFile = await testCompressAndGetFile(input);
  /// ```
  static Future<File?> testCompressAndGetFile(File file) async {
    List<String> parts = file.absolute.path.split('/');
    String filenameWithExt = parts.last;
    String fileFormat = filenameWithExt.split('.').last;

    var dir = await getTemporaryDirectory();
    var targetPath = dir.absolute.path + "/temp.$fileFormat";
    File? result;

    try {
      result = await FlutterImageCompress.compressAndGetFile(
        format: fileFormat == 'png' ? CompressFormat.png : CompressFormat.jpeg,
        file.absolute.path,
        targetPath,
        quality: 80,
      );
    } catch (e) {
      debugPrint(e.toString());
    }

    return result;
  }


  /// Clears the values of profile-related provider variables.
  ///
  /// This function resets the values of various provider variables related to filling a profile. It is often used when you need to reset the profile information in a form or screen.
  ///
  /// Example:
  /// ```dart
  /// clearFillProfileControllers(ref);
  /// ```
  static void clearFillProfileControllers(WidgetRef ref) async {
    FillProfileModelImp().setValue(imagePathProvider.notifier, ref, PROFILE_IMAGE_DIRECTORY);
    FillProfileModelImp().setValue(firstNameProvider.notifier, ref, '');
    FillProfileModelImp().setValue(lastNameProvider.notifier, ref, '');
    FillProfileModelImp().setValue(dateOfBirthProvider.notifier, ref, '');
    FillProfileModelImp().setValue(emailProvider.notifier, ref, '');
    FillProfileModelImp().setValue(phoneNumberProvider.notifier, ref, '');
  }

  /// Returns a File object representing a default profile image.
  ///
  /// This function loads a default profile image from the specified asset path,
  /// creates a temporary File on the device, writes the image data to the File,
  /// and returns the File object representing the default profile image.
  ///
  /// Example:
  /// ```dart
  /// File defaultProfileImage = await returnFillProfileImage(PROFILE_IMAGE_DIRECTORY);
  /// ```
  ///
  /// Parameters:
  /// - `localImageDirectory`: The path to the default profile image asset in your application.
  ///
  /// Returns:
  /// A Future containing the File object representing the default profile image.
  static Future<File> returnFillProfileImage(String localImageDirectory) async {
    var bytes = await rootBundle.load(localImageDirectory);
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/profile.png');
    await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    return file;
  }

  /// Converts an hour and minute to a formatted time string in "hh:mm" format.
  ///
  /// This function takes an `hour` and `minute` as integers and converts them into
  /// a formatted time string with leading zeros if necessary. The resulting format is "hh:mm".
  ///
  /// Example:
  /// ```dart
  /// String formattedTime = convertHourAndMinuteToFormattedDate(9, 30); // "09:30"
  /// ```
  ///
  /// Parameters:
  /// - `hour`: The hour value as an integer.
  /// - `minute`: The minute value as an integer.
  ///
  /// Returns:
  /// A formatted time string in "hh:mm" format.
  static String convertHourAndMinuteToFormattedDate(int hour, int minute) {
    String hourDate = hour < 10 ? "0$hour" : hour.toString();
    String minuteDate = minute < 10 ? "0$minute" : minute.toString();
    return '$hourDate:$minuteDate';
  }

  /// Converts a Firestore Timestamp to a TimeOfDay object.
  ///
  /// This function takes a Firestore `timestamp` and converts it into a `TimeOfDay` object.
  /// It extracts the hour and minute components from the timestamp's corresponding `DateTime`
  /// and creates a `TimeOfDay` object.
  ///
  /// Example:
  /// ```dart
  /// Timestamp timestamp = Timestamp.fromDate(DateTime(2023, 8, 10, 9, 30));
  /// TimeOfDay timeOfDay = convertTimestampToTimeOfDay(timestamp); // 09:30 AM
  /// ```
  ///
  /// Parameters:
  /// - `timestamp`: The Firestore `Timestamp` object to be converted.
  ///
  /// Returns:
  /// A `TimeOfDay` object representing the time from the provided `timestamp`.
  static TimeOfDay convertTimestampToTimeOfDay(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return TimeOfDay(hour: date.hour, minute: date.minute);
  }

  /// Converts a TimeOfDay object to a Firestore Timestamp.
  ///
  /// This function takes a `TimeOfDay` object and converts it into a Firestore `Timestamp` object.
  /// It creates a new `DateTime` object with the current date and the hour and minute values from the `TimeOfDay`.
  ///
  /// Example:
  /// ```dart
  /// TimeOfDay timeOfDay = TimeOfDay(hour: 9, minute: 30);
  /// Timestamp timestamp = convertTimeOfDayToTimestamp(timeOfDay);
  /// ```
  ///
  /// Parameters:
  /// - `timeOfDay`: The `TimeOfDay` object to be converted.
  ///
  /// Returns:
  /// A `Timestamp` object representing the time from the provided `TimeOfDay`.
  static Timestamp convertTimeOfDayToTimestamp(TimeOfDay timeOfDay) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return Timestamp.fromDate(dateTime);
  }

  /// Converts a TimeOfDay object to a numerical representation of time in hours.
  ///
  /// This function takes a `TimeOfDay` object and converts it into a numerical representation
  /// of time in hours. The conversion is based on the hour and minute values of the `TimeOfDay`.
  /// The result is a floating-point number with the hour value plus the fraction of the minute.
  ///
  /// Example:
  /// ```dart
  /// TimeOfDay timeOfDay = TimeOfDay(hour: 9, minute: 30);
  /// double timeInHours = timeOfDayToDouble(timeOfDay); // Returns 9.5
  /// ```
  ///
  /// Parameters:
  /// - `myTime`: The `TimeOfDay` object to be converted.
  ///
  /// Returns:
  /// A floating-point number representing the time in hours and minutes.
  static double timeOfDayToDouble(TimeOfDay myTime) {
    return myTime.hour + myTime.minute / 60.0;
  }

  /// Resets appointment-related variables to their default values.
  ///
  /// This function is used to reset various variables related to appointments
  /// and scheduling to their default or initial values. It's useful when you need
  /// to clean up the state or data related to appointments and scheduling.
  static void cleanAppointmentsVariables(WidgetRef ref) {
    ChooseProfessionalViewModelImp().setValue(currentProfessionalIndexProvider.notifier, ref, -1);
    ChooseServiceViewModelImp().setValue(currentServiceIndexProvider.notifier, ref, -1);
    ChooseScheduleViewModelImp().setValue(currentSlotIndexProvider.notifier, ref, -1);
    ChooseScheduleViewModelImp().setValue(selectedDayProvider.notifier, ref, DateTime.now());
    MakeAppointmentScreenViewModelImp().setValue(currentAppointmentIndexProvider.notifier, ref, 0);
  }

  /// Retrieves an image from Firebase Storage and converts it to Uint8List.
  ///
  /// This function retrieves an image from Firebase Storage based on the provided path
  /// and converts it into a `Uint8List`. It returns the image data as a `Uint8List`,
  /// or `null` if an error occurs during the retrieval process.
  ///
  /// Parameters:
  /// - `path`: The path to the image in Firebase Storage.
  ///
  /// Returns:
  /// A `Uint8List` containing the image data, or `null` if an error occurs.
  static Future<Uint8List?> getImageAndConvertToUint8List(String path) async {
    final storageRef = FirebaseStorage.instance.ref();
    final islandRef = storageRef.child(path);

    try {
      const oneMegabyte = 1024 * 1024 * 5; // Maximum image size in bytes
      final Uint8List? data = await islandRef.getData(oneMegabyte);
      return data;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Downloads an image from a URL and saves it as a temporary file.
  ///
  /// This function downloads an image from the provided URL and saves it as a
  /// temporary file on the device. It generates a unique filename to avoid conflicts
  /// and uses an HTTP request to retrieve the image data. The downloaded image is
  /// written to the temporary file and returned as a `File` instance.
  ///
  /// Parameters:
  /// - `imageUrl`: The URL of the image to download.
  ///
  /// Returns:
  /// A `File` instance representing the downloaded image as a temporary file.
  static Future<File> urlToFile(String imageUrl) async {
    var rng = Random();

    // Get the device's temporary directory
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    // Generate a unique filename for the downloaded image
    File file = File('$tempPath' + (rng.nextInt(100)).toString() + '.png');

    // Download the image using an HTTP request
    http.Response response = await http.get(Uri.parse(imageUrl));

    // Write the downloaded image data to the temporary file
    await file.writeAsBytes(response.bodyBytes);

    // Return the File instance of the downloaded image
    return file;
  }

  /// Inserts spaces at specified intervals in a given input string.
  ///
  /// This function takes an input string and a list of integers representing a pattern. It inserts spaces at the specified intervals defined by the pattern to format the input string.
  ///
  /// Parameters:
  /// - `input`: The input string where spaces will be inserted.
  /// - `pattern`: A list of integers representing the pattern of space insertion intervals.
  ///
  /// Returns:
  /// - A new formatted string with spaces inserted according to the provided pattern.
  static String insertSpacesInString(String input, List<int> pattern) {
    StringBuffer result = StringBuffer();
    int index = 0;

    for (int partLength in pattern) {
      result.write(input.substring(index, index + partLength));
      index += partLength;

      if (index < input.length) {
        result.write(' ');
      }
    }

    return result.toString();
  }

}














