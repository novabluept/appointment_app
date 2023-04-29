import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:appointment_app_v2/style/general_style.dart';
import 'package:appointment_app_v2/ui/auth/forgot_password.dart';
import 'package:appointment_app_v2/ui/auth/login.dart';
import 'package:appointment_app_v2/ui/auth/register/create_password.dart';
import 'package:appointment_app_v2/ui/auth/register/fill_profile.dart';
import 'package:appointment_app_v2/ui/main_page.dart';
import 'package:appointment_app_v2/utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized(); /// Firebase
  await Firebase.initializeApp(); /// Firebase

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 882),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '',
          theme: ThemeData(
            useMaterial3:true,
            primarySwatch: Colors.blue,
          ),
          home: AnimatedSplashScreen(
              duration: 3000,
              splash: SvgPicture.asset('images/logo_medica_full.svg',width: 240.w,height: 60.h),
              nextScreen: MainPage(),
              splashTransition: SplashTransition.fadeTransition,
              pageTransitionType: PageTransitionType.fade,
              backgroundColor: white),
        );
      },
    );
  }
}


