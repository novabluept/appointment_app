
import 'dart:io';

import 'package:appointment_app_v2/state_management/state.dart';
import 'package:appointment_app_v2/ui/auth/register/fill_profile.dart';
import 'package:appointment_app_v2/ui/main_page.dart';
import 'package:appointment_app_v2/ui_items/my_text_form_field.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:page_transition/page_transition.dart';
import '../../../model/user_model.dart';
import '../../../style/general_style.dart';
import '../../../ui_items/my_app_bar.dart';
import '../../../ui_items/my_button.dart';
import '../../../ui_items/my_label.dart';
import '../../../ui_items/my_responsive_layout.dart';
import '../../../utils/constants.dart';
import '../../../utils/method_helper.dart';
import '../../../utils/validators.dart';
import '../../../view_model/create_password/create_password_view_model_imp.dart';

class CreatePassword extends ConsumerStatefulWidget {
  const CreatePassword({Key? key}): super(key: key);

  @override
  CreatePasswordState createState() => CreatePasswordState();
}

class CreatePasswordState extends ConsumerState<CreatePassword> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordHasError = false;
  bool _confirmPasswordHasError = false;
  bool _showPasswordText = true;
  bool _showConfirmPasswordText = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future _signUpAndAddUserDetails() async{
    if(await MethodHelper.hasInternetConnection()){
      if(_formKey.currentState!.validate()){
        String imagePath = ref.watch(imagePathProvider);
        final image = File(imagePath);
        final firstName = ref.watch(firstNameProvider);
        final lastName = ref.watch(lastNameProvider);
        final dateOfBirth = ref.watch(dateOfBirthProvider);
        final email = ref.watch(emailProvider);
        final phone = ref.watch(phoneNumberProvider);

        /// Create user in FireAuth
        await _signUp(email,_passwordController.text);

        /// Get user Id
        final userId = FirebaseAuth.instance.currentUser?.uid;
        if(userId != null){
          /// Create user in FireStore Database
          await _addUserDetails(userId,image,firstName,lastName,dateOfBirth,email,phone);
        }
        MethodHelper.clearFillProfileControllers(ref);
        MethodHelper.transitionPage(context, widget, MainPage(),PageNavigatorType.PUSH_REPLACEMENT, PageTransitionType.rightToLeftJoined);
      }
    }else{
      MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Sem ligação à internet.');
    }
  }

  Future _signUp(String email,String password) async{
    await CreatePasswordModelImp().signUp(email.trim(),password.trim()).catchError((e){
      if (e.code == 'email-already-in-use'){
        MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'The account already exists for that email.');
      }else if(e.code == 'invalid-email'){
        MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'The email address is not valid.');
      }else if(e.code == 'operation-not-allowed'){
        MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'The email/password accounts are not enabled.');
      }else if(e.code == 'weak-password'){
        MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'The password provided is too weak.');
      }
    });
  }

  Future _addUserDetails(String userId,File image,String firstName,String lastName,String dateOfBirth,String email,String phone) async{

    /// User Model
    UserModel user = UserModel(
      userId: userId,
      firstname: MethodHelper.capitalize(firstName.trim()),
      lastname: MethodHelper.capitalize(lastName.trim()),
      dateOfBirth: dateOfBirth.trim(),
      phone: email.trim(),
      email: phone.trim(),
      imagePath: '/${FirebaseCollections.USER.name}/$userId',
      role: UserRole.USER.name
    );

    await CreatePasswordModelImp().addUserDetails(userId,user);
    await _addProfilePicture(image,user.imagePath);
  }

  Future _addProfilePicture(File file,String pathToSave) async{
    await CreatePasswordModelImp().addProfilePicture(file,pathToSave);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        MethodHelper.transitionPage(context, widget, const FillProfile(), PageNavigatorType.PUSH_REPLACEMENT,PageTransitionType.leftToRightJoined);
        return false;
      },
      child: Scaffold(
        backgroundColor: white,
        resizeToAvoidBottomInset : true,
        appBar: MyAppBar(
          type: MyAppBarType.LEADING_ICON,
          leadingIcon: IconlyLight.arrow_left,
          label: 'Create password',
          onTap: (){
            MethodHelper.transitionPage(context, widget, const FillProfile(), PageNavigatorType.PUSH_REPLACEMENT, PageTransitionType.leftToRightJoined);
          },
        ),
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

            SvgPicture.asset('images/create_password_image.svg',width: 329.w,height: 250.h),

            SizedBox(height: 71.h,),

            const Align(
              alignment: Alignment.centerLeft,
              child: MyLabel(
                type: MyLabelType.BODY_XLARGE,
                fontWeight: MyLabel.MEDIUM,
                label: 'Create your password',
              ),
            ),

            SizedBox(height: 24.h,),

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

                  SizedBox(height: 24.h,),

                  MyTextFormField(
                    type: MyTextFormFieldType.PREFIX_SUFIX,
                    textEditingController: _confirmPasswordController,
                    prefixIcon: IconlyBold.lock,
                    label: 'Confirm password',
                    isObscure: true,
                    showObscureText: _showConfirmPasswordText,
                    hasError: _confirmPasswordHasError,
                    errorText: 'Password does\'t match',
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

                  SizedBox(height: 24.h,),

                  MyButton(type: MyButtonType.FILLED, label: 'Continue',onPressed: _signUpAndAddUserDetails),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}