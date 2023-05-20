
import 'package:appointment_app_v2/ui_items/my_text_form_field.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:page_transition/page_transition.dart';
import '../../style/general_style.dart';
import '../../ui_items/my_app_bar.dart';
import '../../ui_items/my_button.dart';
import '../../ui_items/my_label.dart';
import '../../ui_items/my_responsive_layout.dart';
import '../../utils/method_helper.dart';
import '../../utils/validators.dart';
import '../../view_model/forgot_password/forgot_password_view_model_imp.dart';
import '../main_page.dart';

class ForgotPassword extends ConsumerStatefulWidget {
  const ForgotPassword({Key? key}): super(key: key);

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends ConsumerState<ForgotPassword> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailHasError = false;
  bool _isEmailFocused = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future _sendPasswordResetByEmail(String email) async{
    if(await MethodHelper.hasInternetConnection()){
      if(_formKey.currentState!.validate()){
        await ForgotPasswordModelImp().sendPasswordResetEmail(email).catchError((e){
          if(e.code == 'auth/invalid-email'){
            MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'auth/invalid-email');
          }else if(e.code == 'auth/missing-android-pkg-name'){
            MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'auth/missing-android-pkg-name');
          }else if(e.code == 'auth/missing-continue-uri'){
            MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'auth/missing-continue-uri');
          }else if(e.code == 'auth/missing-ios-bundle-id'){
            MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'auth/missing-ios-bundle-id');
          }else if(e.code == 'auth/invalid-continue-uri'){
            MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'auth/invalid-continue-uri');
          }else if(e.code == 'auth/unauthorized-continue-uri'){
            MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'auth/unauthorized-continue-uri');
          }else if(e.code == 'auth/user-not-found'){
            MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'auth/user-not-found');
          }else if(e.code == 'auth/unauthorized-continue-uri'){
            MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'auth/unauthorized-continue-uri');
          }
        });
      }
    }else{
      MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Sem ligação à internet.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        MethodHelper.transitionPage(context, widget, MainPage(), PageNavigatorType.PUSH_REPLACEMENT, PageTransitionType.leftToRightJoined);
        return false;
      },
      child: Scaffold(
        backgroundColor: light1,
        appBar: MyAppBar(
          type: MyAppBarType.LEADING_ICON,
          leadingIcon: IconlyLight.arrow_left,
          label: 'Forgot password',
          onTap: (){
            MethodHelper.transitionPage(context, widget, MainPage(), PageNavigatorType.PUSH_REPLACEMENT, PageTransitionType.leftToRightJoined);
          },
        ),
        resizeToAvoidBottomInset : true,
        body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody(),)
      ),
    );
  }

  Widget mobileBody(){
    return SingleChildScrollView(
      child: Container(
        color: light1,
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 48.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 43.h,),

            SvgPicture.asset('images/forgot_password_image.svg',width: 276.w,height: 250.h),

            SizedBox(height: 33.h,),

            Align(
              alignment: Alignment.centerLeft,
              child: MyLabel(
                type: MyLabelType.BODY_XLARGE,
                fontWeight: MyLabel.MEDIUM,
                label: 'Select which contact details should we use to reset your password',
                color: grey900,
              ),
            ),

            SizedBox(height: 24.h,),

            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [

                  MyTextFormField(
                    type: MyTextFormFieldType.SUFFIX,
                    textEditingController: _emailController,
                    suffixIcon: IconlyLight.message,
                    label: 'Email',
                    hasError: _emailHasError,
                    errorText: 'hrello',
                    isFieldFocused: _isEmailFocused,
                    onFocusChange: (hasFocus){
                      setState(() {_isEmailFocused = hasFocus;});
                    },
                    validator: (value){
                      if(value == null || value.isEmpty || !Validators.isEmailValid(value)){
                        setState(() {_emailHasError = true;});
                        return '';
                      }
                      setState(() {_emailHasError = false;});
                      return null;
                    }
                  ),

                  SizedBox(height: 20.h,),

                  MyButton(type: MyButtonType.FILLED, label: 'Recover Password',onPressed: () => _sendPasswordResetByEmail(_emailController.text.trim())),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }



}