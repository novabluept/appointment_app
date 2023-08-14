
import 'package:appointment_app_v2/ui/auth/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../style/general_style.dart';
import 'auth/login.dart';

class AuthObserver extends ConsumerStatefulWidget{
  const AuthObserver({Key? key}): super(key: key);

  @override
  AuthObserverState createState() => AuthObserverState();
}

class AuthObserverState extends ConsumerState<AuthObserver> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        debugPrint("");
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context,snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(
                  child: SpinKitRing(
                    color: blue,
                    size: 60.w,
                  ),
                );
              }else if(snapshot.hasError) {
                return const Text('has error');
              }else if(snapshot.hasData){
                return const VerifyEmail();
              }else{
                return const Login();
              }
            }
        ),
      ),
    );
  }
}



