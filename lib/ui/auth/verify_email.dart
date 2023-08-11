
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
      _sendVerificationEmail();
      _timer = Timer.periodic(Duration(seconds: 3),(_) => _checkEmailVerified());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future _sendVerificationEmail() async{
    await VerifyEmailModelImp().sendEmailVerification().catchError((e){
      MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Ocorreu algo inesperado. Por favor, tente mais tarde.');
    });
  }

  Future _checkEmailVerified() async{

    /// callback after email verification
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      _isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(_isEmailVerified) _timer?.cancel();
  }

  Future _signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return _isEmailVerified ? PersistentBottomNavbar() : WillPopScope(
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