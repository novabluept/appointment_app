
import 'dart:io';

import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_completed.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_upcoming.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../style/general_style.dart';
import '../../../../../ui_items/my_app_bar.dart';
import '../../../../../ui_items/my_button.dart';
import '../../../../../ui_items/my_label.dart';
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../ui_items/my_text_form_field.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/validators.dart';

class InviteFriends extends ConsumerStatefulWidget {
  const InviteFriends({Key? key}): super(key: key);

  @override
  InviteFriendsState createState() => InviteFriendsState();
}

class InviteFriendsState extends ConsumerState<InviteFriends> {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
          backgroundColor: light1,
          resizeToAvoidBottomInset : true,
          appBar: MyAppBar(
            type: MyAppBarType.LEADING_ICON,
            leadingIcon: IconlyLight.arrow_left,
            label: 'Invite Friends',
            onTap: (){
              Navigator.of(context).pop();
            },
          ),
          body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
      ),
    );
  }

  Widget mobileBody(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: 43.h),

            SvgPicture.asset('images/blue/invite_friends_image.svg',width: 276.w,height: 250.h),

            SizedBox(height: 33.h),

            Align(
              alignment: Alignment.centerLeft,
              child: MyLabel(
                type: MyLabelType.BODY_XLARGE,
                fontWeight: MyLabel.MEDIUM,
                label: 'Bring your friends along and invite them now!',
                color: grey900,
              ),
            ),

            SizedBox(height: 24.h),

            MyButton(type: MyButtonType.FILLED,labelColor: light1,backgroundColor: blue,foregroundColor: light1, label: 'Invite Friends',onPressed: (){}),

          ],
        ),
      ),
    );
  }

}