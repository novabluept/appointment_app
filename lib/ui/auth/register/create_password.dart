
import 'dart:io';

import 'package:appointment_app_v2/ui/auth_observer.dart';
import 'package:appointment_app_v2/ui_items/my_text_form_field.dart';
import 'package:appointment_app_v2/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';
import 'package:uuid/uuid.dart';
import '../../../model/user_model.dart';
import '../../../state_management/fill_profile_state.dart';
import '../../../style/general_style.dart';
import '../../../ui_items/my_app_bar.dart';
import '../../../ui_items/my_button.dart';
import '../../../ui_items/my_label.dart';
import '../../../ui_items/my_responsive_layout.dart';
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
  bool _isPasswordFocused = false;
  bool _isConfirmPasswordFocused = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: light1,
      resizeToAvoidBottomInset : true,
      appBar: MyAppBar(
        type: MyAppBarType.LEADING_ICON,
        leadingIcon: IconlyLight.arrow_left,
        label: 'Create password',
        onTap: (){
          Navigator.of(context).pop();
        },
      ),
      body: MyResponsiveLayout(mobileBody: mobileBody(), tabletBody: mobileBody())
    );
  }

  /// Attempts to sign up a user and add their details.
  ///
  /// This function checks for internet connection, validates user inputs,
  /// and then attempts to sign up the user using the provided [email] and [password].
  /// If successful, the user's details are added in Firebase Authentication.
  ///
  /// Returns: A [Future] that completes when the sign-up and user details addition are finished.
  Future _signUpAndAddUserDetails() async {
    // Check for internet connection using MethodHelper.
    if (await MethodHelper.hasInternetConnection()) {
      // Validate the form input using the _formKey.
      if (_formKey.currentState!.validate()) {
        // Get the user's email and password from the context.
        final email = ref.read(emailProvider);
        final password = _passwordController.text;

        // Create user and add details in FireAuth.
        await _signUp(email, password);
      }
    } else {
      // Show a dialog alert if there's no internet connection.
      MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'Sem ligação à internet.');
    }
  }

  /// Attempts to sign up a user with provided email and password, and adds user details.
  ///
  /// This function initiates the user sign-up process using the provided [email] and [password].
  /// If the sign-up is successful, the function proceeds to add the user details including
  /// [image], [firstName], [lastName], [dateOfBirth], [email], and [phone].
  ///
  /// Parameters:
  /// - [email]: The email address for the new user account.
  /// - [password]: The password for the new user account.
  ///
  /// Returns: A [Future] that completes when the sign-up and user details addition are finished.
  Future _signUp(String email, String password) async {
    await CreatePasswordModelImp().signUp(email.trim(), password.trim()).then((value) async {
      String imagePath = ref.read(imagePathProvider);
      final image = File(imagePath);
      final firstName = ref.read(firstNameProvider);
      final lastName = ref.read(lastNameProvider);
      final dateOfBirth = ref.read(dateOfBirthProvider);
      final email = ref.read(emailProvider);
      final phone = ref.read(phoneProvider);

      final userId = FirebaseAuth.instance.currentUser?.uid;

      await _addUserDetails(userId!, image, firstName, lastName, dateOfBirth, email, phone);
    }).catchError((e) {
      if (e.code == 'email-already-in-use') {
        MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'The email address is not valid.');
      } else if (e.code == 'weak-password') {
        MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'The password provided is too weak.');
      } else {
        MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'Something went wrong. Please try again later.');
      }
    });
  }

  /// Adds user details and profile picture for a successfully signed up user.
  ///
  /// This function adds the provided user [details] (including [image], [firstName],
  /// [lastName], [dateOfBirth], [email], and [phone]) to the user's profile in Firebase
  /// Firestore. It also adds the user's [image] to Firebase Storage under the specified [imagePath].
  /// After adding user details and profile picture, the function proceeds to send an email verification.
  ///
  /// Parameters:
  /// - [userId]: The unique ID of the signed-up user.
  /// - [image]: The profile image file of the user.
  /// - [firstName]: The first name of the user.
  /// - [lastName]: The last name of the user.
  /// - [dateOfBirth]: The date of birth of the user.
  /// - [email]: The email address of the user.
  /// - [phone]: The phone number of the user.
  ///
  /// Returns: A [Future] that completes when the user details addition, profile picture addition,
  /// and email verification process are finished.
  Future _addUserDetails(
      String userId, File image, String firstName, String lastName,
      String dateOfBirth, String email, String phone
      ) async {
    String imagePath = '/${FirebaseCollections.USER.name}/${userId}-${Uuid().v1()}'; /// collection / userId + uuid (time generated type)

    UserModel user = UserModel(
        userId: userId,
        firstname: MethodHelper.capitalize(firstName.trim()),
        lastname: MethodHelper.capitalize(lastName.trim()),
        dateOfBirth: dateOfBirth.trim(),
        phone: phone.trim(),
        email: email.trim(),
        imagePath: imagePath,
        role: UserRole.USER.name
    );

    await CreatePasswordModelImp().addUser(userId, user).then((value) async {
      await _addProfilePicture(image, imagePath).then((value) async {
        await _sendEmailVerification();
      });
    }).catchError((onError) {
      MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'Something went wrong. Please try again later.');
    });
  }

  /// Adds a profile picture for the signed-up user to Firebase Storage.
  ///
  /// This function adds the provided [file] (profile picture) to Firebase Storage
  /// under the specified [pathToSave]. If an error occurs during the addition process,
  /// a warning dialog is shown to the user.
  ///
  /// Parameters:
  /// - [file]: The profile picture [File] of the user.
  /// - [pathToSave]: The path under which the profile picture should be saved in Firebase Storage.
  ///
  /// Returns: A [Future] that completes when the profile picture addition process is finished.
  Future _addProfilePicture(File file, String pathToSave) async {
    await CreatePasswordModelImp().addUserPicture(file, pathToSave).catchError((onError) {
      MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'Something went wrong. Please try again later.');
    });
  }

  /// Sends an email verification link to the signed-up user's email address.
  ///
  /// This function initiates the process of sending an email verification link
  /// to the signed-up user's email address using [CreatePasswordModelImp]. If successful,
  /// it clears the fill profile controllers, navigates to the [AuthObserver] page,
  /// and removes the current page from the navigation stack.
  ///
  /// Returns: A [Future] that completes when the email verification process is finished.
  Future _sendEmailVerification() async {
    await CreatePasswordModelImp().sendEmailVerification().then((value) {
      MethodHelper.clearFillProfileControllers(ref);
      MethodHelper.switchPage(context, PageNavigatorType.PUSH_REMOVE_UNTIL, const AuthObserver(), widget);

    }).catchError((onError) {
      MethodHelper.showDialogAlert(context, MyDialogType.WARNING, 'Something went wrong. Please try again later.');
    });
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
            SvgPicture.asset('images/blue/create_password_image.svg',width: 329.w,height: 250.h),
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
                  MyButton(type: MyButtonType.FILLED,labelColor: light1,backgroundColor: blue,foregroundColor: light1, label: 'Continue',onPressed: _signUpAndAddUserDetails),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}