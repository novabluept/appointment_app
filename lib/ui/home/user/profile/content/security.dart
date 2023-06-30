
import 'dart:io';

import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_completed.dart';
import 'package:appointment_app_v2/ui/home/user/appointments_history/content/appointments_upcoming.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class Security extends ConsumerStatefulWidget {
  const Security({Key? key}): super(key: key);

  @override
  SecurityState createState() => SecurityState();
}

class SecurityState extends ConsumerState<Security> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordHasError = false;
  bool _confirmPasswordHasError = false;
  bool _showPasswordText = true;
  bool _showConfirmPasswordText = true;
  bool _isPasswordFocused = false;
  bool _isConfirmPasswordFocused = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future _saveValues() async{

    if(_formKey.currentState!.validate()){
      /*await FillProfileModelImp().setValue(firstNameProvider.notifier, ref, _firstNameController.text.trim());
      await FillProfileModelImp().setValue(lastNameProvider.notifier, ref, _lastNameController.text.trim());
      await FillProfileModelImp().setValue(dateOfBirthProvider.notifier, ref, _dateOfBirthController.text.trim());
      await FillProfileModelImp().setValue(emailProvider.notifier, ref, _emailController.text.trim());
      await FillProfileModelImp().setValue(phoneNumberProvider.notifier, ref, _phoneNumberController.text.trim());

      MethodHelper.transitionPage(context, widget, CreatePassword(), PageNavigatorType.PUSH_REPLACEMENT, PageTransitionType.rightToLeftJoined);*/
    }
  }

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
            label: 'Security',
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

            SizedBox(height: 24.h),

            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                children: [
                  MyTextFormField(
                    type: MyTextFormFieldType.PREFIX_SUFIX,
                    textEditingController: _passwordController,
                    prefixIcon: IconlyBold.lock,
                    label: 'Password',
                    isObscure: true,
                    showObscureText: _showPasswordText,
                    hasError: _passwordHasError,
                    errorText: 'Password must contain at least 6 characters',
                    isFieldFocused: _isPasswordFocused,
                    onFocusChange: (hasFocus){
                      setState(() {_isPasswordFocused = hasFocus;});
                    },
                    validator: (value){
                      if(value == null || value.isEmpty || !Validators.isPasswordValid(value)){
                        setState(() {_passwordHasError = true;});
                        return '';
                      }
                      setState(() {_passwordHasError = false;});
                      return null;
                    },
                    triggerObscureTextVisibility: (){
                      setState(() {_showPasswordText = !_showPasswordText;});
                    },

                  ),

                  SizedBox(height: 24.h),

                  MyTextFormField(
                    type: MyTextFormFieldType.PREFIX_SUFIX,
                    textEditingController: _confirmPasswordController,
                    prefixIcon: IconlyBold.lock,
                    label: 'Confirm password',
                    isObscure: true,
                    showObscureText: _showConfirmPasswordText,
                    hasError: _confirmPasswordHasError,
                    errorText: 'Password does\'t match',
                    isFieldFocused: _isConfirmPasswordFocused,
                    onFocusChange: (hasFocus){
                      setState(() {_isConfirmPasswordFocused = hasFocus;});
                    },
                    validator: (value){
                      if(value == null || value.isEmpty || _passwordController.text.trim() != _confirmPasswordController.text.trim()){
                        setState(() {_confirmPasswordHasError = true;});
                        return '';
                      }
                      setState(() {_confirmPasswordHasError = false;});
                      return null;
                    },
                    triggerObscureTextVisibility: (){
                      setState(() {_showConfirmPasswordText = !_showConfirmPasswordText;});
                    },
                  ),

                  SizedBox(height: 24.h),

                  MyButton(type: MyButtonType.FILLED, label: 'Continue',onPressed: (){}),
                ],
              ),
            ),
          ],


        ),
      ),
    );
  }

}