
import 'package:appointment_app_v2/ui/auth/forgot_password.dart';
import 'package:appointment_app_v2/ui/auth/register/fill_profile.dart';
import 'package:appointment_app_v2/ui_items/my_text_form_field.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:appointment_app_v2/utils/method_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:page_transition/page_transition.dart';
import '../../style/general_style.dart';
import '../../ui_items/my_button.dart';
import '../../ui_items/my_divider.dart';
import '../../ui_items/my_label.dart';
import '../../ui_items/my_responsive_layout.dart';
import '../../utils/validators.dart';
import '../../view_model/login/login_view_model_imp.dart';

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}): super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends ConsumerState<Login> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _emailHasError = false;
  bool _passwordHasError = false;
  bool _showPasswordText = true;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: light1,
      resizeToAvoidBottomInset : true,
      body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
    );
  }

  Future _signIn() async{
    if(await MethodHelper.hasInternetConnection()){
      if(_formKey.currentState!.validate()){
        LoginViewModelImp().signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        ).catchError((e){
          if(e.code == 'invalid-email'){
            MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Email address is not valid.');
          }else if(e.code == 'user-disabled'){
            MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'The user corresponding to the given email has been disabled.');
          }else if(e.code == 'user-not-found'){
            MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'No user found for that email.');
          }else if(e.code == 'wrong-password'){
            MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Wrong password provided for that user.');
          }
        });
      }
    }else{
      MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Sem ligação à internet.');
    }
  }

  Future _signInWithGoogle() async{
    if(await MethodHelper.hasInternetConnection()){
      LoginViewModelImp().signInWithGoogle().catchError((e){
        print(e);
      });
    }else{
      MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Sem ligação à internet.');
    }
  }

  Widget mobileBody(){
    return SingleChildScrollView(
      child: Container(
        color: light1,
        padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 0.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 99.h),

            SvgPicture.asset('images/logo_medica.svg',width: 140.w,height: 140.h),

            SizedBox(height: 27.h),

            MyLabel(
              type: MyLabelType.H3,
              fontWeight: MyLabel.BOLD,
              label: 'Login to your account',
            ),

            SizedBox(height: 27.h),

            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [

                  MyTextFormField(
                    type: MyTextFormFieldType.PREFIX,
                    textEditingController: _emailController,
                    prefixIcon: IconlyBold.message,
                    label: 'Email',
                    hasError: _emailHasError,
                    errorText: 'Please enter a valid email',
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

                  SizedBox(height: 20.h),

                  MyTextFormField(
                    type: MyTextFormFieldType.PREFIX_SUFIX,
                    textEditingController: _passwordController,
                    prefixIcon: IconlyBold.lock,
                    label: 'Password',
                    isObscure: true,
                    showObscureText: _showPasswordText,
                    hasError: _passwordHasError,
                    errorText: '',
                    isFieldFocused: _isPasswordFocused,
                    onFocusChange: (hasFocus){
                      setState(() {_isPasswordFocused = hasFocus;});
                    },
                    validator: (value){
                      return null;
                    },
                    triggerObscureTextVisibility: (){
                      setState(() {_showPasswordText = !_showPasswordText;});
                    },
                  ),

                  SizedBox(height: 20.h),

                  MyButton(type: MyButtonType.FILLED, label: 'Sign in',onPressed: _signIn),

                ],
              ),
            ),

            SizedBox(height: 20.h),

            GestureDetector(
              onTap: (){
                MethodHelper.transitionPage(context, widget, ForgotPassword(), PageNavigatorType.PUSH_REPLACEMENT,PageTransitionType.rightToLeftJoined);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: MyLabel(
                  type: MyLabelType.BODY_LARGE,
                  fontWeight: MyLabel.BOLD,
                  label: 'Forgot the password?',
                  color: blue,
                ),
              ),
            ),

            SizedBox(height: 27.h),

            MyDivider(type: MyDividerType.GENERAL,label: 'or'),

            SizedBox(height: 30.h),

            MyButton(type: MyButtonType.IMAGE, label: 'Continue with google',imgUrl: 'images/google_logo.svg',onPressed: _signInWithGoogle),

            SizedBox(height: 27.h),

            GestureDetector(
              onTap: (){
                MethodHelper.transitionPage(context, widget, FillProfile(), PageNavigatorType.PUSH_REPLACEMENT, PageTransitionType.rightToLeftJoined);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyLabel(
                    type: MyLabelType.BODY_MEDIUM,
                    label: 'Don\'t have an acocunt?',
                    color: grey500,
                  ),
                  SizedBox(width: 8.w),
                  MyLabel(
                    type: MyLabelType.BODY_MEDIUM,
                    label: 'Sign up',
                    color: blue,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}