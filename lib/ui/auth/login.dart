



import 'package:appointment_app_v2/ui/auth/forgot_password.dart';
import 'package:appointment_app_v2/ui/auth/register/fill_profile.dart';
import 'package:appointment_app_v2/ui_items/my_text_form_field.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:appointment_app_v2/utils/method_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import '../../style/general_style.dart';
import '../../ui_items/my_button.dart';
import '../../ui_items/my_divider.dart';
import '../../ui_items/my_label.dart';
import '../../ui_items/my_responsive_layout.dart';
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

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : true,
      body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody(),)
    );
  }

  Future _signIn() async{
    LoginViewModelImp().signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  Widget mobileBody(){
    return Container(
      color: white,
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 48.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 99.h,),

          SvgPicture.asset('images/logo_medica.svg',width: 140.w,height: 140.h),

          SizedBox(height: 27.h,),

          MyLabel(
            type: MyLabelType.H3,
            fontWeight: MyLabel.BOLD,
            label: 'Login to your account',
          ),

          SizedBox(height: 27.h,),

          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [

                MyTextFormField(type: MyTextFormFieldType.PREFIX,textEditingController: _emailController,prefixIcon: CupertinoIcons.mail_solid, label: 'Email',validator: (value){

                }),

                SizedBox(height: 20.h,),

                MyTextFormField(type: MyTextFormFieldType.PREFIX,textEditingController: _passwordController,prefixIcon: CupertinoIcons.lock_fill, label: 'Password',isPassword: true,validator: (value){

                }),

                SizedBox(height: 20.h,),

                MyButton(type: MyButtonType.FILLED, label: 'Sign in',onPressed: _signIn),

              ],
            ),
          ),

          SizedBox(height: 20.h,),

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

          SizedBox(height: 27.h,),

          MyDivider(type: MyDividerType.GENERAL,label: 'or'),

          SizedBox(height: 30.h,),

          MyButton(type: MyButtonType.IMAGE, label: 'Continue with google',imgUrl: 'images/google_logo.svg',onPressed: (){
            print('olaaaa');
          }),

          SizedBox(height: 27.h,),

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
                SizedBox(width: 8.w,),
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
    );
  }
}