
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
import '../../../../../ui_items/my_responsive_layout.dart';
import '../../../../../ui_items/my_text_form_field.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/validators.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({Key? key}): super(key: key);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends ConsumerState<EditProfile> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _firstNameHasError = false;
  bool _lastNameHasError = false;
  bool _dateOfBirthHasError = false;
  bool _emailHasError = false;
  bool _phoneNumberHasError = false;
  bool _isFirstNameFocused = false;
  bool _isLastNameFocused = false;
  bool _isDateOfBirthFocused = false;
  bool _isEmailFocused = false;
  bool _isPhoneNumberFocused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _insertInitialTextEditingControllersValues();
    });

  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  _insertInitialTextEditingControllersValues(){
    /*_firstNameController.text = ref.watch(firstNameProvider);
    _lastNameController.text = ref.watch(lastNameProvider);
    _dateOfBirthController.text = ref.watch(dateOfBirthProvider);
    _emailController.text = ref.watch(emailProvider);
    _phoneNumberController.text = ref.watch(phoneNumberProvider);*/
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
            label: 'Edit profile',
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
                  type: MyTextFormFieldType.GENERAL,
                  textEditingController: _firstNameController,
                  label: 'First name',
                  contentPaddingHeight: 18,
                  hasError: _firstNameHasError,
                  errorText: 'Please enter a valid first name',
                  isFieldFocused: _isFirstNameFocused,
                  onFocusChange: (hasFocus){
                    setState(() {_isFirstNameFocused = hasFocus;});
                  },
                  validator: (value){
                    if(value == null || value.isEmpty || !Validators.hasMinimumAndMaxCharacters(value)){
                      setState(() {_firstNameHasError = true;});
                      return '';
                    }
                    setState(() {_firstNameHasError = false;});
                    return null;
                  }
              ),

              SizedBox(height: 24.h),

              MyTextFormField(
                  type: MyTextFormFieldType.GENERAL,
                  textEditingController: _lastNameController,
                  label: 'Last name',
                  contentPaddingHeight: 18,
                  hasError: _lastNameHasError,
                  errorText: 'Please enter a valid last name',
                  isFieldFocused: _isLastNameFocused,
                  onFocusChange: (hasFocus){
                    setState(() {_isLastNameFocused = hasFocus;});
                  },
                  validator: (value){
                    if(value == null || value.isEmpty || !Validators.hasMinimumAndMaxCharacters(value)){
                      setState(() {_lastNameHasError = true;});
                      return '';
                    }
                    setState(() {_lastNameHasError = false;});
                    return null;
                  }
              ),

              SizedBox(height: 24.h),

              MyTextFormField(
                  type: MyTextFormFieldType.SUFFIX,
                  textEditingController: _dateOfBirthController,
                  suffixIcon: IconlyLight.calendar,
                  label: 'Date of birth',
                  contentPaddingHeight: 18,
                  hasError: _dateOfBirthHasError,
                  errorText: 'Please enter a valid date of birth',
                  isDate: true,
                  isReadOnly: true,
                  showDateDialog: () async{
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1970),
                      lastDate: DateTime(2025),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        _dateOfBirthController.text = DateFormat(DATE_FORMAT).format(selectedDate);
                      }
                    });
                  },
                  isFieldFocused: _isDateOfBirthFocused,
                  onFocusChange: (hasFocus){
                    setState(() {_isDateOfBirthFocused = hasFocus;});
                  },
                  validator: (value){
                    if(value == null || value.isEmpty){
                      setState(() {_dateOfBirthHasError = true;});
                      return '';
                    }
                    setState(() {_dateOfBirthHasError = false;});
                    return null;
                  }
              ),

              SizedBox(height: 24.h),

              MyTextFormField(
                  type: MyTextFormFieldType.SUFFIX,
                  textEditingController: _emailController,
                  suffixIcon: IconlyLight.message,
                  label: 'Email',
                  contentPaddingHeight: 18,
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

              SizedBox(height: 24.h),

              MyTextFormField(
                  type: MyTextFormFieldType.PHONE,
                  textEditingController: _phoneNumberController,
                  label: 'Phone number',
                  contentPaddingHeight: 18,
                  hasError: _phoneNumberHasError,
                  errorText: 'Phone number should have the format: 9XYYYYYYY',
                  isFieldFocused: _isPhoneNumberFocused,
                  onFocusChange: (hasFocus){
                    setState(() {_isPhoneNumberFocused = hasFocus;});
                  },
                  validator: (value){
                    if(value == null || value.isEmpty || !Validators.isPhoneValid(value)){
                      setState(() {_phoneNumberHasError = true;});
                      return '';
                    }
                    setState(() {_phoneNumberHasError = false;});
                    return null;
                  }
              ),

                  SizedBox(height: 24.h),

                  MyButton(type: MyButtonType.FILLED, label: 'Update',onPressed: _saveValues),
                ],
              ),
            ),
          ],


        ),
      ),
    );
  }

}