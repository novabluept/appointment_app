
import 'dart:async';
import 'package:appointment_app_v2/ui/home/persistent_bottom_navbar.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import '../../style/general_style.dart';
import '../../ui_items/my_app_bar.dart';
import '../../ui_items/my_button.dart';
import '../../ui_items/my_label.dart';
import '../../ui_items/my_responsive_layout.dart';
import '../../utils/method_helper.dart';
import '../../view_model/verify_email/verify_email_view_model_imp.dart';

class VerifyEmail extends ConsumerStatefulWidget {
  const VerifyEmail({Key? key}): super(key: key);

  @override
  VerifyEmailState createState() => VerifyEmailState();
}

class VerifyEmailState extends ConsumerState<VerifyEmail> {

  bool _isEmailVerified = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if(!_isEmailVerified){
      _timer = Timer.periodic(Duration(seconds: 5),(_) => _checkEmailVerified());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Initiates the process of sending a verification email.
  ///
  /// This function initiates the process of sending a verification email using [VerifyEmailModelImp().sendEmailVerification()].
  /// If an error occurs during the verification email sending process, a generic error message is shown.
  ///
  /// Returns: A [Future] that completes when the verification email sending process is finished.
  Future _sendVerificationEmail() async {
    // Initiate the process of sending a verification email using VerifyEmailModelImp().
    await VerifyEmailModelImp().sendEmailVerification().catchError((e) {
      MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'Something went wrong. Please try again later.');
    });
  }

  /// Checks whether the current user's email is verified.
  ///
  /// This function reloads the current user's information using [FirebaseAuth.instance.currentUser!.reload()] to ensure
  /// that the latest email verification status is obtained. The [_isEmailVerified] state variable is then updated based on
  /// the current user's email verification status. If the email is verified, any active timer is cancelled.
  ///
  /// Returns: A [Future] that completes when the email verification check is finished.
  Future _checkEmailVerified() async {
    // Reload the current user's information to ensure the latest email verification status.
    await FirebaseAuth.instance.currentUser!.reload();

    // Update the _isEmailVerified state variable based on the user's email verification status.
    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    // If the email is verified, cancel any active timer.
    if (_isEmailVerified) _timer?.cancel();
  }

  /// Signs out the current user from the application.
  ///
  /// This function initiates the sign-out process using [VerifyEmailModelImp().signOut()].
  ///
  /// Returns: A [Future] that completes when the sign-out process is finished.
  Future _signOut() async {
    // Initiate the sign-out process using VerifyEmailModelImp().
    await VerifyEmailModelImp().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return _isEmailVerified ? const PersistentBottomNavbar() : WillPopScope(
      onWillPop: () async{
        await _signOut();
        return false;
      },
      child: Scaffold(
          backgroundColor: light1,
          appBar: MyAppBar(
            type: MyAppBarType.LEADING_ICON,
            leadingIcon: IconlyLight.arrow_left,
            label: 'Verify Email',
            onTap: _signOut,
          ),
          resizeToAvoidBottomInset : false,
          body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
      ),
    );
  }

  Widget mobileBody(){
    return Container(
      color: light1,
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 48.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 43.h),
          SvgPicture.asset('images/blue/verify_email_image.svg',width: 237.w,height: 200.h),
          SizedBox(height: 33.h),
          Align(
            alignment: Alignment.centerLeft,
            child: MyLabel(
              type: MyLabelType.BODY_XLARGE,
              fontWeight: MyLabel.MEDIUM,
              label: 'We have dispatched an email to your inbox for verification purposes.',
              color: grey900,
            ),
          ),
          SizedBox(height: 24.h),
          MyButton(type: MyButtonType.FILLED,labelColor: light1,backgroundColor: blue,foregroundColor: light1, label: 'Resend email',onPressed: _sendVerificationEmail),
          SizedBox(height: 24.h),
          MyButton(type: MyButtonType.OUTLINED,labelColor: blue,backgroundColor: Colors.transparent,foregroundColor: blue, label: 'Cancel',onPressed: _signOut),
        ],
      ),
    );
  }

}