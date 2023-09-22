
import 'package:appointment_app_v2/ui_items/my_text_form_field.dart';
import 'package:appointment_app_v2/utils/enums.dart';
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
import '../../utils/validators.dart';
import '../../view_model/forgot_password/forgot_password_view_model_imp.dart';

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

  /// Sends a password reset email to the provided email address.
  ///
  /// This function first checks if the device has an internet connection using [MethodHelper.hasInternetConnection()].
  /// If there's a connection, it validates the form using [_formKey]. If the form is valid,
  /// it initiates the process of sending a password reset email using [ForgotPasswordModelImp().sendPasswordResetEmail(email)].
  /// If an error occurs during the email sending process, specific error messages are shown based on the error code.
  ///
  /// Parameters:
  /// - [email]: The email address to which the password reset email will be sent.
  ///
  /// Returns: A [Future] that completes when the password reset email sending process is finished.
  Future _sendPasswordResetByEmail(String email) async {
    // Check if the device has an internet connection.
    if (await MethodHelper.hasInternetConnection()) {
      // Validate the form using _formKey.
      if (_formKey.currentState!.validate()) {
        // Send password reset email using ForgotPasswordModelImp().
        await ForgotPasswordModelImp().sendPasswordResetEmail(email).catchError((e) {
          if (e.code == 'invalid-email') {
            MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'Please enter a valid email.');
          } else if (e.code == 'user-not-found') {
            MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'No user found for that email.');
          } else {
            MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'Something went wrong. Please try again later.');
          }
        });
      }
    } else {
      MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'Sem ligação à internet.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: light1,
      appBar: MyAppBar(
        type: MyAppBarType.LEADING_ICON,
        leadingIcon: IconlyLight.arrow_left,
        label: 'Forgot password',
        onTap: (){
          Navigator.of(context).pop();
        },
      ),
      resizeToAvoidBottomInset : true,
      body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
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
            SizedBox(height: 43.h),
            SvgPicture.asset('images/blue/forgot_password_image.svg',width: 276.w,height: 250.h),
            SizedBox(height: 33.h),
            Align(
              alignment: Alignment.centerLeft,
              child: MyLabel(
                type: MyLabelType.BODY_XLARGE,
                fontWeight: MyLabel.MEDIUM,
                label: 'Select which contact details should we use to reset your password',
                color: grey900,
              ),
            ),
            SizedBox(height: 24.h),
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
                  MyButton(type: MyButtonType.FILLED,labelColor: light1,backgroundColor: blue,foregroundColor: light1, label: 'Recover Password',onPressed: () => _sendPasswordResetByEmail(_emailController.text.trim())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



}