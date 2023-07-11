
import 'dart:io';

import 'package:appointment_app_v2/state_management/choose_shop_state.dart';
import 'package:appointment_app_v2/ui/auth/register/fill_profile.dart';
import 'package:appointment_app_v2/ui/main_page.dart';
import 'package:appointment_app_v2/ui_items/my_text_form_field.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../state_management/fill_profile_state.dart';
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
import 'package:uuid/uuid.dart';


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
  bool _isPasswordFocused = false;
  bool _isConfirmPasswordFocused = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future _signUpAndAddUserDetails() async{
    if(await MethodHelper.hasInternetConnection()){
      if(_formKey.currentState!.validate()){

        final email = ref.read(emailProvider);
        final password = _passwordController.text;

        /// Create user and add details in FireAuth
        await _signUp(email,password);
      }
    }else{
      MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Sem ligação à internet.');
    }
  }

  Future _signUp(String email,String password) async{
    await CreatePasswordModelImp().signUp(email.trim(),password.trim()).then((value) async {

      String imagePath = ref.read(imagePathProvider);
      final image = File(imagePath);
      final firstName = ref.read(firstNameProvider);
      final lastName = ref.read(lastNameProvider);
      final dateOfBirth = ref.read(dateOfBirthProvider);
      final email = ref.read(emailProvider);
      final phone = ref.read(phoneNumberProvider);

      final userId = FirebaseAuth.instance.currentUser?.uid;

      await _addUserDetails(userId!,image,firstName,lastName,dateOfBirth,email,phone);

    }).catchError((e){
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
    String imagePath = '/${FirebaseCollections.USER.name}/${userId}-${Uuid().v1()}'; /// collection / userId + uuid ( time generated type )

    /// User Model
    UserModel user = UserModel(
      userId: userId,
      firstname: MethodHelper.capitalize(firstName.trim()),
      lastname: MethodHelper.capitalize(lastName.trim()),
      dateOfBirth: dateOfBirth.trim(),
      phone: email.trim(),
      email: phone.trim(),
      imagePath: imagePath,
      role: UserRole.USER.name
    );

    await CreatePasswordModelImp().addUserDetails(userId,user).then((value) async {
      await _addProfilePicture(image,imagePath);
    }).catchError((onError){
      MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Ocorreu algo inesperado. Por favor, tente mais tarde.');
    });

  }

  Future _addProfilePicture(File file,String pathToSave) async{
    await CreatePasswordModelImp().addProfilePicture(file,pathToSave).then((value) {
      MethodHelper.clearFillProfileControllers(ref);
      MethodHelper.transitionPage(context, widget, MainPage(),PageNavigatorType.PUSH_REPLACEMENT, PageTransitionType.rightToLeftJoined);
    }).catchError((onError){
      MethodHelper.showSnackBar(context, SnackBarType.WARNING, 'Ocorreu algo inesperado. Por favor, tente mais tarde.');
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        MethodHelper.transitionPage(context, widget, const FillProfile(), PageNavigatorType.PUSH_REPLACEMENT,PageTransitionType.leftToRightJoined);
        return false;
      },
      child: Scaffold(
        backgroundColor: light1,
        resizeToAvoidBottomInset : true,
        appBar: MyAppBar(
          type: MyAppBarType.LEADING_ICON,
          leadingIcon: IconlyLight.arrow_left,
          label: 'Create password',
          onTap: (){
            MethodHelper.transitionPage(context, widget, const FillProfile(), PageNavigatorType.PUSH_REPLACEMENT, PageTransitionType.leftToRightJoined);
          },
        ),
        body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
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

            SizedBox(height: 43.h),

            SvgPicture.asset('images/create_password_image.svg',width: 329.w,height: 250.h),

            SizedBox(height: 71.h),

            const Align(
              alignment: Alignment.centerLeft,
              child: MyLabel(
                type: MyLabelType.BODY_XLARGE,
                fontWeight: MyLabel.MEDIUM,
                label: 'Create your password',
              ),
            ),

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