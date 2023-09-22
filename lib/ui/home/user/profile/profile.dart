
import 'dart:io';
import 'dart:typed_data';

import 'package:appointment_app_v2/state_management/persistent_bottom_navbar_state.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_completed.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_upcoming.dart';
import 'package:appointment_app_v2/ui/home/user/profile/content/edit_language.dart';
import 'package:appointment_app_v2/ui/home/user/profile/content/edit_notifications.dart';
import 'package:appointment_app_v2/ui/home/user/profile/content/edit_profile.dart';
import 'package:appointment_app_v2/ui/home/user/profile/content/invite_friends.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:appointment_app_v2/view_model/profile/profile_view_model_imp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:uuid/uuid.dart';
import '../../../../data_ref/users_ref.dart';
import '../../../../model/user_model.dart';
import '../../../../state_management/choose_shop_state.dart';
import '../../../../state_management/fill_profile_state.dart';
import '../../../../style/general_style.dart';
import '../../../../ui_items/my_app_bar.dart';
import '../../../../ui_items/my_button.dart';
import '../../../../ui_items/my_label.dart';
import '../../../../ui_items/my_modal_bottom_sheet.dart';
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

  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _image = ref.read(currentUserPictureProvider)!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Picks an image from the device's gallery and updates the image path.
  ///
  /// This function uses the [ImagePicker] package to allow the user to pick an image
  /// from the device's gallery. Once an image is selected, its path is retrieved,
  /// and the image path provider is updated using [FillProfileModelImp().setValue()].
  /// The widget state is then updated to reflect the change.
  ///
  /// Returns: A [Future] that completes when an image is successfully picked and the state is updated.
  Future<void> _pickImage() async {
    var currentUser = FirebaseAuth.instance.currentUser!;
    var maxFileSizeInBytes = MAX_FILE_SIZE_UPLOAD_IN_BYTES;

    // Use ImagePicker to pick an image from the gallery.
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    // If no image is picked, return.
    if (image == null) return;

    var imageAsBytes = await image.readAsBytes();

    if (imageAsBytes.length <= maxFileSizeInBytes) {
      // Get the selected image's path.
      String imagePath = image.path;

      // Add File to Firebase
      File file = File(imagePath);
      String pathToSave = '/${FirebaseCollections.USER.name}/${currentUser.uid}-${Uuid().v1()}';
      ProfileViewModelImp().addUserPicture(file, pathToSave);

      // Update User
      Map<String, dynamic> fields = {
        UserModel.col_imagePath: pathToSave,
      };

      // Delete user old photo
      String pathToDelete = ref.read(currentUserProvider).imagePath;

      await ProfileViewModelImp().updateUser(fields);

      setState((){
        _image = imageAsBytes;
        ProfileViewModelImp().setValue(currentUserPictureProvider.notifier, ref, _image);
      });

      await ProfileViewModelImp().deleteUserPicture("/"+pathToDelete.substring(1));

    } else {
      // Display a warning dialog if the image size exceeds the limit.
      MethodHelper.showDialogAlert(
        context,
        MyDialogType.WARNING,
        'The size of the picture should be under ${MAX_FILE_SIZE} MB.',
      );
    }
  }

  _showSignOutBottomSheet(BuildContext context){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (context) {
        return MyModalBottomSheet(
            type: MyModalBottomSheetType.GENERAL,
            content: _signOutBottomSheet(context)
        );
      }
    );
  }

  Widget _signOutBottomSheet(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 24.h),
        MyLabel(
          type: MyLabelType.H4,
          fontWeight: MyLabel.BOLD,
          label: 'Logout',
          color: red,
        ),
        SizedBox(height: 24.h),
        const MyLabel(
          type: MyLabelType.BODY_XLARGE,
          fontWeight: MyLabel.MEDIUM,
          label: 'Are you sure you want logout?',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Flexible(
              child: MyButton(
                type: MyButtonType.FILLED,
                labelColor: blue,
                backgroundColor: lightBlue,
                foregroundColor: blue,
                label: 'Back',
                onPressed: (){Navigator.of(context).pop();}
              )
            ),
            SizedBox(width: 16.w),
            Flexible(
              child: MyButton(
                type: MyButtonType.FILLED,
                labelColor: light1,
                backgroundColor: blue,
                foregroundColor: light1,
                label: 'Yes, Logout',
                onPressed: () async {
                  await ProfileViewModelImp().signOut();
                  Navigator.of(context).pop();
                }
              )
            ),
          ],
        ),
        SizedBox(height: 24.h,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel user = ref.watch(currentUserProvider);
    return Scaffold(
      backgroundColor: light1,
      appBar: const MyAppBar(
        type: MyAppBarType.GENERAL,
        label: 'Profile',
        height: kToolbarHeight,
      ),
      resizeToAvoidBottomInset : true,
      body: MyResponsiveLayout(mobileBody: mobileBody(user), tabletBody: mobileBody(user))
    );
  }

  Widget _profilePicture(){
    return GestureDetector(
      onTap: _pickImage,
      child: SizedBox(
        width: 140.h,
        height: 140.h,
        child: CircleAvatar(
          radius: 58,
          backgroundColor: light1,
          backgroundImage: Image.asset(PROFILE_IMAGE_DIRECTORY).image,
          child: Stack(
            children: [
              Center(
                child: ClipOval(
                  child: Image.memory(
                    _image != null ? _image! : ref.watch(currentUserPictureProvider)!,
                    width: 140.w, // Adjust the width as needed
                    height: 140.w, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
    );
  }

  Widget mobileBody(UserModel user){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profilePicture(),
            SizedBox(height: 12.h),
            MyLabel(
              type: MyLabelType.H4,
              fontWeight: MyLabel.BOLD,
              label: '${user.firstname} ${user.lastname}',
              color: grey900,
            ),
            SizedBox(height: 8.h),
            MyLabel(
              type: MyLabelType.BODY_MEDIUM,
              fontWeight: MyLabel.SEMI_BOLD,
              label: '+351 ${MethodHelper.insertSpacesInString(user.phone, [3,3,3])}',
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
                MyProfileTile(type: MyProfileTileType.GENERAL,icon: IconlyLight.logout,label: 'Logout',isLogout: true,onTap: () => _showSignOutBottomSheet(context)),
              ],
            )
          ],
        ),
      ),
    );
  }
}