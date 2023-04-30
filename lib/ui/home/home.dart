


import 'dart:ffi';

import 'package:appointment_app_v2/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../style/general_style.dart';
import '../../ui_items/my_app_bar.dart';
import '../../ui_items/my_button.dart';
import '../../ui_items/my_responsive_layout.dart';


class Home extends ConsumerStatefulWidget {
  const Home({Key? key}): super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
          appBar: MyAppBar(
            type: MyAppBarType.LEADING_ICON,
            leadingIcon: CupertinoIcons.line_horizontal_3,
            label: 'Home',
            onTap: (){
              //MethodHelper.transitionPage(context, widget, Login(), PageTransitionType.leftToRightJoined);
            },
          ),
          resizeToAvoidBottomInset : false,
          body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
      ),
    );
  }

  Widget mobileBody(){
    return Container(
      color: white,
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 48.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyButton(type: MyButtonType.FILLED, label: 'Logout',onPressed: () async{
            await FirebaseAuth.instance.signOut();
          }),

        ],
      ),
    );
  }

}