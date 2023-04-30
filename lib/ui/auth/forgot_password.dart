
import 'package:appointment_app_v2/ui_items/my_text_form_field.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  Future _sendPasswordResetByEmail(String email) async{
    if(_formKey.currentState!.validate()){
      await ForgotPasswordModelImp().sendPasswordResetEmail(email);
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
        appBar: MyAppBar(
          type: MyAppBarType.LEADING_ICON,
          leadingIcon: CupertinoIcons.arrow_left,
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
        color: white,
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
                    suffixIcon: CupertinoIcons.mail,
                    label: 'Email',
                    validator: (value){
                      if(value == null || value.isEmpty || !Validators.isEmailValid(value)){
                        return '';
                      }
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