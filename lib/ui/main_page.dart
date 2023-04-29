
import 'package:appointment_app_v2/ui/auth/verify_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth/login.dart';
import 'main/home.dart';


class MainPage extends ConsumerStatefulWidget{
  const MainPage({Key? key}): super(key: key);

  @override
  MainPageState createState() => MainPageState();
}


class MainPageState extends ConsumerState<MainPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if( snapshot.connectionState == ConnectionState.waiting){
              return Text('waiting');
            } else if(snapshot.hasError){
              return Text('has error');
            }else if(snapshot.hasData){
              //return Home();
              return VerifyEmail();
            }else{
              return Login();
            }
          }
      ),
    );
  }
}



