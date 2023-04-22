import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:appointment_app_v2/ui/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
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
              splash: Icons.home,
              nextScreen: Login(),
              splashTransition: SplashTransition.fadeTransition,
              pageTransitionType: PageTransitionType.fade,
              backgroundColor: Colors.blue),
          onGenerateRoute: (settings){
            switch (settings.name) {
              case '/login':
                return PageTransition(child: Container(), type: PageTransitionType.fade);
              case '/forgot_password':
                return PageTransition(child: Container(), type: PageTransitionType.rightToLeft);
              case '/register':
                return PageTransition(child: Container(), type: PageTransitionType.rightToLeft);
            }
          }
        );
      },
    );
  }
}


