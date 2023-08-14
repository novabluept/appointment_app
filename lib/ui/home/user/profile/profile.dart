
import 'dart:io';

import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_completed.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_upcoming.dart';
import 'package:appointment_app_v2/ui/home/user/profile/content/edit_language.dart';
import 'package:appointment_app_v2/ui/home/user/profile/content/edit_notifications.dart';
import 'package:appointment_app_v2/ui/home/user/profile/content/edit_profile.dart';
import 'package:appointment_app_v2/ui/home/user/profile/content/invite_friends.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../../../state_management/choose_shop_state.dart';
import '../../../../state_management/fill_profile_state.dart';
import '../../../../style/general_style.dart';
import '../../../../ui_items/my_app_bar.dart';
import '../../../../ui_items/my_label.dart';
import '../../../../ui_items/my_profile_tile.dart';
import '../../../../ui_items/my_responsive_layout.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/method_helper.dart';
import '../appointments_history/content/appointments_cancelled.dart';
import 'content/security.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({Key? key}): super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends ConsumerState<Profile> {

  @override
  void dispose() {
    super.dispose();
  }

  Future pickImage() async{
    ///TODO: Fazer try catch e tratar de configurações
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    String imagePath = image.path;

    final imageTemporary = File(imagePath);
    //await FillProfileModelImp().setValue(imagePathProvider.notifier, ref, imagePath);
    //setState(() { this._image = imageTemporary;});
  }

  Future _signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: light1,
        appBar: const MyAppBar(
          type: MyAppBarType.GENERAL,
          label: 'Profile',
          height: kToolbarHeight,
        ),
        resizeToAvoidBottomInset : true,
        body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
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
            GestureDetector(
              onTap: pickImage,
              child: SizedBox(
                width: 140.h,
                height: 140.h,
                child: CircleAvatar(
                  radius: 58,
                  backgroundColor: light1,
                  backgroundImage: ref.watch(imagePathProvider) != PROFILE_IMAGE_DIRECTORY ? Image.file(File(ref.watch(imagePathProvider))).image : Image.asset(PROFILE_IMAGE_DIRECTORY).image,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                          width: 30.w,
                          height: 30.h,
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: blue,
                            child: Icon(IconlyBold.edit,color: light1,size: 16.sp),
                          ),
                        ),
                      ),
                    ]
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            MyLabel(
              type: MyLabelType.H4,
              fontWeight: MyLabel.BOLD,
              label: 'Andrew Ainsley',
              color: grey900,
            ),
            SizedBox(height: 8.h),
            MyLabel(
              type: MyLabelType.BODY_MEDIUM,
              fontWeight: MyLabel.SEMI_BOLD,
              label: '+1 111 467 378 399',
              color: grey900,
            ),
            SizedBox(height: 24.h),
            Divider(
              color: grey200,
              thickness: 1.0,
            ),
            SizedBox(height: 24.h),
            Column(
              children: [
                MyProfileTile(type: MyProfileTileType.GENERAL,icon: IconlyLight.profile,label: 'Edit Profile',onTap: (){
                  MethodHelper.switchPage(context, PageNavigatorType.PUSH_NEW_PAGE, const EditProfile(), null);
                }),
                SizedBox(height: 20.h),
                MyProfileTile(type: MyProfileTileType.GENERAL,icon: IconlyLight.notification,label: 'Notifications',onTap: (){
                  MethodHelper.switchPage(context, PageNavigatorType.PUSH_NEW_PAGE, const EditNotifications(), null);
                }),
                SizedBox(height: 20.h),
                MyProfileTile(type: MyProfileTileType.GENERAL,icon: IconlyLight.shield_done,label: 'Security',onTap: (){
                  MethodHelper.switchPage(context, PageNavigatorType.PUSH_NEW_PAGE, const Security(), null);
                }),
                SizedBox(height: 20.h),
                MyProfileTile(type: MyProfileTileType.GENERAL,icon: IconlyLight.more_square,label: 'Language',onTap: (){
                  MethodHelper.switchPage(context, PageNavigatorType.PUSH_NEW_PAGE, const EditLanguage(), null);
                }),
                SizedBox(height: 20.h),
                MyProfileTile(type: MyProfileTileType.GENERAL,icon: IconlyLight.user_1,label: 'Invite Friends',onTap: (){
                  MethodHelper.switchPage(context, PageNavigatorType.PUSH_NEW_PAGE, const InviteFriends(), null);
                }),
                SizedBox(height: 20.h),
                MyProfileTile(type: MyProfileTileType.GENERAL,icon: IconlyLight.logout,label: 'Logout',isLogout: true,onTap: _signOut),
              ],
            )
          ],
        ),
      ),
    );
  }
}